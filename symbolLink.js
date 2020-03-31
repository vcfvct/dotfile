#!/usr/bin/env node

const fs = require('fs');
const util = require('util');
const exec = util.promisify(require('child_process').exec);

(async () => {
  const fileList = ['.zshrc', '.vimrc', '.coc.vim', '.tmux.conf', '.tmux.conf.local', '.gitconfig', '.gitignore', '.vim/autoload/lightline/colorscheme/onedark.vim'];

  await Promise.all(fileList.map(f => createSymbolLink(f)));

  async function createSymbolLink(filePath) {
    const src = `${process.cwd()}/${filePath}`;
    const dest = `${process.env.HOME}/${filePath}`;
    let cmd = `rm ${dest}`;
    console.log(`executing: ${cmd}`);
    await exec(cmd);
    cmd = `ln -s ${src} ${dest}`;
    console.log(`executing: ${cmd}`);
    await exec(cmd);
  }
})();
