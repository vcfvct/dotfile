#!/usr/bin/env bash

sudo apt update -y
sudo apt install zip -y

## fish
sudo apt-add-repository ppa:fish-shell/release-4 -y
sudo apt update -y
sudo apt install fish -y

## neovim
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update -y
sudo apt install neovim -y

## tmux/fzf/rg/bat/eza
sudo apt install fzf -y
sudo apt install ripgrep -y
sudo apt install bat -y
sudo apt install eza -y

# tools like make
sudo apt install build-essential -y

# need by nodejs
sudo apt-get install libatomic1
