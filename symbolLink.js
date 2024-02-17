#!/usr/bin / env node

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
    '.gitconfig',
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
    'ripgrep',
    'zathura',
  ];

  const getHomeDir = () => process.env.HOME || process.env.USERPROFILE;

  await Promise.allSettled(fileList.map(f => createFileSymbolLink(f)));
  await createFileSymbolLink('.gitignore', '.ignore');
  await Promise.allSettled(dotConfigDirList.map(d => createDirSymbolLink('.config', d)));
  await createDirSymbolLink('.vim/autoload', 'lightline');

  /**
   * @param {string} sourceName
   * @param {string} target //optional
   **/
  async function createFileSymbolLink(sourceName, target) {
    const targetName = target || sourceName;
    const src = path.join(process.cwd(), sourceName);
    const dest = path.join(getHomeDir(), targetName);
    if (fsSync.existsSync(dest)) {
      await fs.unlink(dest);
    }
    await createSymLink(src, dest);
  }

  /**
   * @param {string} dirPath
   * @param {string} dirName
   **/
  async function createDirSymbolLink(dirPath, dirName) {
    const src = path.join(process.cwd(), dirPath, dirName);
    const dest = path.join(getHomeDir(), dirPath, dirName);
    if (fsSync.existsSync(dest)) {
      await fs.rmdir(dest);
    }
    await createSymLink(src, dest);
  }


  async function createSymLink(src, dest) {
    if (fsSync.existsSync(src)) {
      try {
        await fs.symlink(src, dest);
      } catch (err) {
        console.error(err);
      }
    } else {
      console.error(`Source ${src} does not exist`);
    }
  }
})();
