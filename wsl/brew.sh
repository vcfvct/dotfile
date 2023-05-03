#!/usr/bin/env bash
# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" -y

(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# install packages
brew install fish -f
brew install tmux -f
brew install unzip -f
brew install bat -f
brew install rg -f
brew install fzf -f
brew install exa -f
brew install neovim -f

## vimPlug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# brew install azure-cli -y
# brew install --cask ngrok -y
# brew install dotnet -y
# brew install --cask dotnet -y
