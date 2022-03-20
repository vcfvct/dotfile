#!/usr/bin/env bash

sudo apt update -y
sudo apt install zip

## fish 3.x
sudo apt-add-repository ppa:fish-shell/release-3 -y
sudo apt update
sudo apt install fish -y

## neovim
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install neovim -y

## vimPlug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

## tmux
sudo apt install tmux

## fzf
# sample: https://github.com/junegunn/fzf/releases/download/0.29.0/fzf-0.29.0-linux_amd64.tar.gz
fzf_url=`curl -s https://api.github.com/repos/junegunn/fzf/releases/latest | grep -wo "https.*linux_amd64.tar.gz"`
fzf_tar=fzf.tar.gz
curl -L $fzf_url --output $fzf_tar
tar -xzf $fzf_tar
sudo mv fzf /usr/bin/
rm $fzf_tar

## rg
# sample: https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
rg_url=`curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | grep -wo "https.*amd64.deb"`
rg_deb=rg.deb
curl -L $rg_url --output $rg_deb
sudo dpkg -i $rg_deb
rm $rg_deb

## bat
# sample: https://github.com/sharkdp/bat/releases/download/v0.20.0/bat_0.20.0_amd64.deb
bat_url=`curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | grep -wo "https.*bat_.*amd64.deb"`
bat_deb=bat.deb
curl -L $bat_url --output $bat_deb
sudo dpkg -i $bat_deb
rm $bat_deb

## exa
# https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip
exa_url=`curl -s https://api.github.com/repos/ogham/exa/releases/latest | grep -wo "https.*linux-x86_64-v.*.zip"`
exa_zip=exa.zip
curl -L $exa_url --output $exa_zip
unzip $exa_zip -d exa/
sudo mv exa/bin/exa /usr/bin/
sudo mv exa/man/* /usr/share/man/man1/
sudo mv exa/completions/exa.fish /usr/share/fish/vendor_completions.d/
rm $exa_zip
rm -rf exa

