#!/usr/bin/env node

// const fs = require('fs');
const util = require('util');
const exec = util.promisify(require('child_process').exec);
const fs = require('fs');
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
    const dest = path.join(process.env.HOME, targetName);
    if (fs.existsSync(dest)) {
      await executeCmd(`rm ${dest}`);
    }
    if (fs.existsSync(src)) {
      fs.symlink(src, dest, err => {
        if (err) console.error(err);
      });
    } else {
      console.error(`Source file ${src} does not exist`);
    }
  }

  async function executeCmd(cmd) {
    try {
      console.log(`executing: ${cmd}`);
      await exec(cmd);
    } catch (e) {
      console.error(e);
    }
  }

  /**
   * @param {string} dirPath
   * @param {string} dirName
   **/
  async function createDirSymbolLink(dirPath, dirName) {
    const src = path.join(process.cwd(), dirPath, dirName);
    const dest = path.join(process.env.HOME, dirPath, dirName);
    if (fs.existsSync(dest)) {
      await exec(`rm -rf ${dest}`);
    }
    if (fs.existsSync(src)) {
      fs.symlink(src, dest, err => {
        if (err) console.error(err);
      });
    } else {
      console.error(`Source directory ${src} does not exist`);
    }
  }
})();
