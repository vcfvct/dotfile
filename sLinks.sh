repoPath=${HOME}/GIT/dotfile
rm ~/.zshrc
ln -s ${repoPath}/.zshrc ~/.zshrc

rm ~/.vimrc
ln -s ${repoPath}/.vimrc ~/.vimrc

rm ~/.coc.vim
ln -s ${repoPath}/.coc.vim ~/.coc.vim

rm ~/.tmux.conf
ln -s ${repoPath}/.tmux.conf ~/.tmux.conf

rm ~/.tmux.conf.local
ln -s ${repoPath}/.tmux.conf.local ~/.tmux.conf.local

rm ~/.gitconfig
ln -s ${repoPath}/.gitconfig ~/.gitconfig

rm ~/.gitignore
rm ~/.ignore
ln -s ${repoPath}/.gitignore ~/.gitignore
ln -s ${repoPath}/.gitignore ~/.ignore

rm ~/.oh-my-zsh/custom/vcfvct.zsh
ln -s ${repoPath}/.oh-my-zsh/custom/vcfvct.zsh ~/.oh-my-zsh/custom/vcfvct.zsh

rm -rf ~/.vim/autoload/lightline
ln -s ${repoPath}/.vim/autoload/lightline ~/.vim/autoload

rm -rf ~/.config/alacritty
ln -s ${repoPath}/.config/alacritty ~/.config

rm -rf ~/.config/nvim
ln -s ${repoPath}/.config/nvim ~/.config

rm -rf ~/.config/ripgrep
ln -s ${repoPath}/.config/ripgrep ~/.config

