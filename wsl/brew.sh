#!/usr/bin/env bash
# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" -y

# install packages
brew install fish -y
brew install tmux -y
brew install unzip -y
brew install bat -y
brew install rg -y
brew install fzf -y
brew install exa -y
brew install neovim -y

## vimPlug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# brew install azure-cli -y
# brew install --cask ngrok -y
# brew install dotnet -y
# brew install --cask dotnet -y
