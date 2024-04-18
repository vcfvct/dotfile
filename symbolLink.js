#!/usr/bin/env node

const fs = require('node:fs/promises');
const fsSync = require('fs');
const path = require('path');

(async () => {
  const fileList = [
    '.zshrc',
    '.vimrc',
    '.coc.vim',
    '.tmux.conf',
    '.tmux.conf.local',
    // '.gitconfig',
    '.gitignore',
    '.eslintrc.js',
    '.oh-my-zsh/custom/vcfvct.zsh',
    '.config/fish/config.fish',
    '.config/fish/fishfile',
    '.config/fish/functions/gll.fish',
    '.config/fish/functions/wttr.fish',
    '.config/fish/functions/fish_user_key_bindings.fish',
    '.config/fish/functions/fzf_find_edit.fish',
    '.config/fish/functions/fzf_reverse_isearch.fish',
  ];

  const dotConfigDirList = [
    'alacritty',
    'hyper',
    'kitty',
    'nvim',
    'ripgrep',
    'zathura',
  ];

  const getHomeDir = () => process.env.HOME || process.env.USERPROFILE;

  await Promise.allSettled(fileList.map(f => createSymLink(f)));
  await createSymLink('.gitignore', '.ignore');
  await Promise.allSettled(dotConfigDirList.map(d => createSymLink(`.config/${d}`)));
  console.info('------ All symLinks created. ------');

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
        throw new Error(`Source ${srcFullPath} does not exist`);
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
          await fs.rm(destFullPath, { recursive: true, force: true })
        } else {
          throw new Error(`The destination: ${destFullPath} is not directory/symLink.`)
        }
      }
      // create symLink if src exists
      await fs.symlink(srcFullPath, destFullPath);
      console.info(`SymLink created: ${srcFullPath} -> ${destFullPath}`);
    } catch (err) {
      console.error(err);
    }
  }
})();
