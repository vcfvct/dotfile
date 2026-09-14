#!/usr/bin/env node

const fs = require('node:fs/promises');
const fsSync = require('fs');
const path = require('path');

(async () => {
  for (const argument of process.argv.slice(2)) {
    if (!['--devbox', '--plan', '--verify'].includes(argument)) throw new Error(`Unknown option: ${argument}`);
  }
  const isWindows = process.platform === 'win32';
  const devbox = process.argv.includes('--devbox');
  const planOnly = process.argv.includes('--plan');
  const verifyOnly = process.argv.includes('--verify');
  if (planOnly && verifyOnly) throw new Error('Choose --plan or --verify, not both.');

  // Files that are generally safe to link on any platform
  const commonFiles = [
    '.vimrc',
    // '.coc.vim',
    '.gitignore',
    '.gitconfig',
    '.eslintrc.js',
    '.tmux.common.conf',
  ];

  // Unix-only files (zsh, tmux, fish, etc.)
  const unixOnlyFiles = [
    '.zshrc',
    '.oh-my-zsh/custom/vcfvct.zsh',
    '.tmux.conf',
    '.tmux.conf.local',
  ];

  // psmux uses this entry point before considering ~/.tmux.conf.
  const windowsOnlyFiles = ['.psmux.conf', '.psmux-battery.ps1'];

  // Fish-related files (also Unix-only)
  const fishFiles = [
    '.config/fish/config.fish',
    '.config/fish/fishfile',
    '.config/fish/functions/gll.fish',
    '.config/fish/functions/wttr.fish',
    '.config/fish/functions/fish_user_key_bindings.fish',
    '.config/fish/functions/fzf_find_edit.fish',
    '.config/fish/functions/fzf_reverse_isearch.fish',
  ];

  // dotfiles directories; some are Unix-only
  const dotConfigDirList = [
    'alacritty',
    'hyper',
    'kitty',
    'nvim',
    'ripgrep',
    'zathura',
  ];
  const dotConfigDirsUnixOnly = new Set(['zathura']);

  // Build final file list based on platform
  let fileList = commonFiles.slice();
  if (!isWindows) fileList = fileList.concat(unixOnlyFiles, fishFiles);
  if (isWindows) fileList = fileList.concat(windowsOnlyFiles);
  if (isWindows) {
    const skipped = unixOnlyFiles.concat(fishFiles).filter(f => fileExistsInRepo(f));
    if (skipped.length && !planOnly) console.info('Skipping Unix-only files on Windows: ' + skipped.join(', '));
  }

  let dotConfigs = dotConfigDirList.slice();
  if (isWindows) {
    const skippedDirs = dotConfigs.filter(d => dotConfigDirsUnixOnly.has(d));
    if (skippedDirs.length && !planOnly) console.info('Skipping Unix-only config dirs on Windows: ' + skippedDirs.join(', '));
    dotConfigs = dotConfigs.filter(d => !dotConfigDirsUnixOnly.has(d));
  }

  const getHomeDir = () => process.env.HOME || process.env.USERPROFILE;

  if (devbox) {
    const allowed = new Set([
      ...commonFiles, ...windowsOnlyFiles, ...fishFiles,
      '.tmux.conf', '.tmux.conf.local',
    ]);
    const entries = fileList.filter(f => allowed.has(f)).map(f => [f, f]);
    entries.push(['.gitignore', '.ignore']);
    entries.push(['.config/nvim', isWindows
      ? path.join(process.env.LOCALAPPDATA, 'nvim') : '.config/nvim']);
    entries.push(['.config/ripgrep', '.config/ripgrep']);
    const plan = entries.map(([source, destination]) => ({
      source: path.resolve(process.cwd(), source),
      destination: path.resolve(getHomeDir(), destination),
    }));
    // Validate the entire manifest before moving any existing configuration.
    for (const entry of plan) {
      const stat = await fs.stat(entry.source);
      entry.directory = stat.isDirectory();
      entry.mode = isWindows && !entry.directory ? 'copy' : 'link';
      let parent = path.dirname(entry.destination);
      const root = path.parse(parent).root;
      while (parent !== root) {
        try {
          if ((await fs.lstat(parent)).isSymbolicLink()) {
            throw new Error(`Refusing to write through linked parent: ${parent}`);
          }
        } catch (error) {
          if (error.code !== 'ENOENT') throw error;
        }
        parent = path.dirname(parent);
      }
    }
    if (planOnly) {
      console.log(JSON.stringify(plan, null, 2));
      return;
    }
    if (verifyOnly) {
      for (const entry of plan) {
        if (entry.mode === 'copy') {
          if (!(await fs.readFile(entry.source)).equals(await fs.readFile(entry.destination))) {
            throw new Error(`Copy verification failed: ${entry.destination}`);
          }
        } else if (await fs.realpath(entry.destination) !== await fs.realpath(entry.source)) {
          throw new Error(`Link verification failed: ${entry.destination}`);
        }
      }
      console.log(`Verified ${plan.length} dotfile targets.`);
      return;
    }
    for (const entry of plan) await createSafeLink(entry);
    return;
  }
  if (planOnly || verifyOnly) throw new Error('--plan and --verify require --devbox');

  await Promise.allSettled(fileList.map(function (f) { return createSymLink(f); }));
  await createSymLink('.gitignore', '.ignore');
  await Promise.allSettled(dotConfigs.map(function (d) { return createSymLink('.config/' + d); }));
  console.info('------ All symLinks created (or attempted). ------');

  function fileExistsInRepo(relPath) {
    return fsSync.existsSync(path.join(process.cwd(), relPath));
  }

  async function createSafeLink({ source, destination, directory, mode }) {
    let existing;
    try {
      existing = await fs.lstat(destination);
    } catch (error) {
      if (error.code !== 'ENOENT') throw error;
    }
    if (existing?.isSymbolicLink()) {
      const target = path.resolve(path.dirname(destination), await fs.readlink(destination));
      if (target === source) return;
    } else if (existing?.isFile() && mode === 'copy') {
      if ((await fs.readFile(source)).equals(await fs.readFile(destination))) return;
    }
    await fs.mkdir(path.dirname(destination), { recursive: true });
    const backup = `${destination}.devbox-backup-${require('node:crypto').randomUUID()}`;
    if (existing) {
      await fs.rename(destination, backup);
      console.log(`Backup: ${backup}`);
    }
    try {
      if (mode === 'copy') {
        await fs.copyFile(source, destination, fsSync.constants.COPYFILE_EXCL);
      } else {
        await fs.symlink(source, destination, isWindows && directory ? 'junction' : undefined);
      }
      if (mode === 'copy') {
        if (!(await fs.readFile(source)).equals(await fs.readFile(destination))) {
          throw new Error(`Copy verification failed: ${destination}`);
        }
      } else if (await fs.realpath(destination) !== await fs.realpath(source)) {
        throw new Error(`Link verification failed: ${destination}`);
      }
      console.log(`${mode}: ${source} -> ${destination}`);
    } catch (error) {
      // Never remove an unexpected destination, even when rollback is blocked.
      if (existing && !fsSync.existsSync(destination)) await fs.rename(backup, destination);
      throw error;
    }
  }

  /**
   * @param {string} src, source file path
   * @param {string} dest, optional, destination file path
   *
   * create symLink from src to dest,
   * create dest directory if not exists,
   * delete dest if exists
   **/
  async function createSymLink(src, dest) {
    const destPath = dest || src;
    const srcFullPath = path.join(process.cwd(), src);
    const destFullPath = path.join(getHomeDir(), destPath);
    try {
      if (!fsSync.existsSync(srcFullPath)) {
        console.error('Source does not exist, skipping: ' + srcFullPath);
        return;
      }

      const destParentDir = path.dirname(destFullPath);
      if (!fsSync.existsSync(destParentDir)) {
        await fs.mkdir(destParentDir, { recursive: true });
      }

      // check dest type, remove dest if exists
      if (fsSync.existsSync(destFullPath)) {
        const stats = await fs.lstat(destFullPath);
        if (stats.isSymbolicLink() || stats.isFile()) {
          await fs.unlink(destFullPath);
        } else if (stats.isDirectory()) {
          await fs.rm(destFullPath, { recursive: true, force: true });
        } else {
          console.error('The destination is not a directory or symlink, skipping: ' + destFullPath);
          return;
        }
      }

      // determine source type to pick symlink type on Windows
      const srcStats = await fs.lstat(srcFullPath);
      const srcIsDir = srcStats.isDirectory();
      const symlinkType = isWindows ? (srcIsDir ? 'junction' : 'file') : (srcIsDir ? 'dir' : 'file');

      try {
        await fs.symlink(srcFullPath, destFullPath, symlinkType);
        console.info('SymLink created: ' + srcFullPath + ' -> ' + destFullPath);
      } catch (err) {
        console.error('Failed to create symlink for ' + srcFullPath + ' -> ' + destFullPath + ': ' + (err.code || err.message));
      }
    } catch (err) {
      console.error(err);
    }
  }

})().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
