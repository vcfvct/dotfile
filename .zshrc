# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export JAVA_HOME=$(/usr/libexec/java_home)
export M2_HOME=/usr/local/maven3
export ANDROID_HOME=$HOME/Library/Android/sdk
export PYTHON3_HOME=~/Library/Python/3.7
export PATH=${M2_HOME}/bin:${PYTHON3_HOME}/bin:$HOME/develop/flutter/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# speed startup time
export NVM_LAZY_LOAD=true
export VISUAL=nvim
export EDITOR=$VISUAL
export ZSH_DISABLE_COMPFIX=true
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/rc 
export FZF_DEFAULT_COMMAND='rg --files --hidden'
# From https://bluz71.github.io/2018/11/26/fuzzy-finding-in-bash-with-fzf.html
export FZF_DEFAULT_OPTS='--height 75% --multi --reverse --bind ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-b:preview-page-up,ctrl-f:preview-page-down'

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="agnoster"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(zsh-autosuggestions zsh-syntax-highlighting vi-mode z zsh-nvm colored-man-pages zsh-better-npm-completion)

source $ZSH/oh-my-zsh.sh

# zsh-bd
# . $home/.zsh/plugins/bd/bd.zsh
alias ll="ls -lrth"
alias bd="cd .."
alias ez="vi ~/.zshrc"
alias ev="vi ~/.vimrc"
alias cat="bat"
alias vi=nvim
alias g=git
alias gl="git pull"
alias gp="git push"
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gll="fzf_git_log"
alias powerstat="system_profiler sppowerdatatype | rg 'cycle|condition|wattage'"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

bindkey -v "^e" forward-word
bindkey -v "^b" backward-word
bindkey -v "^f" end-of-line 
bindkey -v "^k" history-beginning-search-backward
bindkey -v "^j" history-beginning-search-forward
# no duplicated commands in history search
setopt HIST_IGNORE_ALL_DUPS
