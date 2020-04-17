#set -xU JAVA_HOME (/usr/libexec/java_home)
#set -xU M2_HOME /usr/local/maven3
#set -xU PYTHON3_HOME ~/Library/Python/3.7
#set -xU GIT_USER $USER
#set -Ux FZF_DEFAULT_OPTS '--height 75% --multi --reverse --bind ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-f:page-down,ctrl-b:page-up,ctrl-e:preview-page-up,ctrl-y:preview-page-down'

set PATH $PYTHON3_HOME/bin $M2_HOME/bin $ANDROID_HOME/tools $ANDROID_HOME/platform-tools $PATH 
set -g theme_display_git_master_branch yes

abbr ll "ls -lrth"
abbr top "htop"
abbr vi "nvim"
abbr cat "bat"
abbr gpl "git pull"
abbr gps "git push"
abbr ef "nvim ~/.config/fish/config.fish"
abbr ev "nvim ~/.vimrc"
abbr envim "nvim ~/.config/nvim/init.vim"
# usage: yaml2js < test.yaml > out.json
alias yaml2js="python3 -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)'"

fish_vi_key_bindings
# ctrl+f/e to complete all/word
bind -M insert \cf forward-char
bind -M insert \ce forward-word
bind -M insert \cj history-search-forward
bind -M insert \ck history-search-backward

