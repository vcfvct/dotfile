#!/usr/bin/env node

const fs = require('fs');
const util = require('util');
const exec = util.promisify(require('child_process').exec);

(async () => {
  const fileList = [
    '.zshrc',
    '.vimrc',
    '.coc.vim',
    '.tmux.conf',
    '.tmux.conf.local',
    '.gitconfig',
    '.gitignore',
    '.oh-my-zsh/custom/vcfvct.zsh',
  ];

  const dotConfigDirList = [
    'nvim',
    'alacritty',
    'ripgrep',
  ]

  await Promise.all(fileList.map(f => createFileSymbolLink(f)));
  await createFileSymbolLink('.gitignore', '.ignore');
  await Promise.all(dotConfigDirList.map(d => createDirSymbolLink('.config', d)));
  await createDirSymbolLink('.vim/autoload', 'lightline');

  /**
   * @param {string} sourceName 
   * @param {string} target //optional 
   **/
  async function createFileSymbolLink(sourceName, target) {
    const targetName = target || sourceName;
    const src = `${process.cwd()}/${sourceName}`;
    const dest = `${process.env.HOME}/${targetName}`;
    let cmd = `rm ${dest}`;
    console.log(`executing: ${cmd}`);
    await exec(cmd);
    cmd = `ln -s ${src} ${dest}`;
    console.log(`executing: ${cmd}`);
    await exec(cmd);
  }

  /**
   * @param {string} dirPath 
   * @param {string} dirName
   **/
  async function createDirSymbolLink(dirPath, dirName) {
    const src = `${process.cwd()}/${dirPath}/${dirName}`;
    const dest = `${process.env.HOME}/${dirPath}`;
    let cmd = `rm -rf ${dest}/${dirName}`;
    console.log(`executing: ${cmd}`);
    await exec(cmd);
    cmd = `ln -s ${src} ${dest}`;
    console.log(`executing: ${cmd}`);
    await exec(cmd);

  }
})();
