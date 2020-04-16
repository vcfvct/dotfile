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

rm ~/.oh-my-zsh/custom/fzf_integration.zsh
ln -s ${repoPath}/.oh-my-zsh/custom/fzf_integration.zsh ~/.oh-my-zsh/custom/fzf_integration.zsh

rm ~/.vim/autoload/lightline/colorscheme/onedark.vim
ln -s ${repoPath}/.vim/autoload/lightline/colorscheme/onedark.vim ~/.vim/autoload/lightline/colorscheme/onedark.vim

rm ~/.config/alacritty/alacritty.yml
ln -s ${repoPath}/.config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml

rm ~/.config/nvim/init.vim
ln -s ${repoPath}/.config/nvim/init.vim ~/.config/nvim/init.vim

rm ~/.config/nvim/coc-settings.json
ln -s ${repoPath}/.config/nvim/coc-settings.json ~/.config/nvim/coc-settings.json

rm ~/.config/ripgrep/rc
ln -s ${repoPath}/.config/ripgrep/rc ~/.config/ripgrep/rc

