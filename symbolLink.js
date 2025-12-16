#!/usr/bin/env node

const fs = require('node:fs/promises');
const fsSync = require('fs');
const path = require('path');

(async () => {
  const isWindows = process.platform === 'win32';

  // Files that are generally safe to link on any platform
  const commonFiles = [
    '.vimrc',
    '.coc.vim',
    '.gitignore',
    '.eslintrc.js',
  ];

  // Unix-only files (zsh, tmux, fish, etc.)
  const unixOnlyFiles = [
    '.zshrc',
    '.oh-my-zsh/custom/vcfvct.zsh',
    '.tmux.conf',
    '.tmux.conf.local',
  ];

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
  if (isWindows) {
    const skipped = unixOnlyFiles.concat(fishFiles).filter(f => fileExistsInRepo(f));
    if (skipped.length) console.info('Skipping Unix-only files on Windows: ' + skipped.join(', '));
  }

  let dotConfigs = dotConfigDirList.slice();
  if (isWindows) {
    const skippedDirs = dotConfigs.filter(d => dotConfigDirsUnixOnly.has(d));
    if (skippedDirs.length) console.info('Skipping Unix-only config dirs on Windows: ' + skippedDirs.join(', '));
    dotConfigs = dotConfigs.filter(d => !dotConfigDirsUnixOnly.has(d));
  }

  const getHomeDir = () => process.env.HOME || process.env.USERPROFILE;

  await Promise.allSettled(fileList.map(function (f) { return createSymLink(f); }));
  await createSymLink('.gitignore', '.ignore');
  await Promise.allSettled(dotConfigs.map(function (d) { return createSymLink('.config/' + d); }));
  console.info('------ All symLinks created (or attempted). ------');

  function fileExistsInRepo(relPath) {
    return fsSync.existsSync(path.join(process.cwd(), relPath));
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

})();
