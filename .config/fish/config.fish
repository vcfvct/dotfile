#set -xU JAVA_HOME (/usr/libexec/java_home)
#set -xU M2_HOME /usr/local/maven3
#set -xU PYTHON3_HOME ~/Library/Python/3.7
#set -xU GIT_USER $USER
#set -Ux FZF_DEFAULT_OPTS '--height 75% --multi --reverse --bind ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up'
#set -Ux FZF_DEFAULT_COMMAND 'rg --files  --hidden'
#set -Ux FZF_OPEN_COMMAND 'rg --files  --hidden'
#set -Ux theme_nerd_fonts yes
# set -xU theme_display_git_master_branch yes
#set -xU LSCOLORS Gxfxcxdxbxegedabagacad
#set -xU EDITOR nvim

set PATH $PYTHON3_HOME/bin $M2_HOME/bin $ANDROID_HOME/tools $ANDROID_HOME/platform-tools $HOME/develop/flutter/bin $PATH 

alias ll "ls -lrth"
abbr top "btm -b"
abbr v "nvim"
abbr vi "nvim"
abbr cat "bat"
abbr g "git"
abbr gl "git pull"
abbr gp "git push"
abbr gd "git diff"
abbr gs "git status"
abbr ef "nvim ~/.config/fish/config.fish"
abbr ev "nvim ~/.vimrc"
abbr envim "nvim ~/.config/nvim/init.vim"
# usage: yaml2js < test.yaml > out.json
alias yaml2js="python3 -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)'"

# reset display rotation/refresh-rate as MacOS catalina does not remember it any more.
abbr d2 'displayplacer "id:FEA7FAF5-966C-3643-56FD-BF84FE1C419E res:2560x1440 hz:75 color_depth:8 scaling:off origin:(0,0) degree:0" "id:073D8CB3-B7FF-E5B4-6BF9-C93276FA4742 res:1200x1920 hz:75 color_depth:8 scaling:off origin:(2560,-180) degree:270" > /dev/null 2>&1 &'
abbr d3 'displayplacer "id:FEA7FAF5-966C-3643-56FD-BF84FE1C419E res:2560x1440 hz:75 color_depth:8 scaling:off origin:(0,0) degree:0" "id:8B78D316-B997-F726-D566-55E188294EBF res:1680x1050 color_depth:4 scaling:on origin:(3760,134) degree:0" "id:073D8CB3-B7FF-E5B4-6BF9-C93276FA4742 res:1200x1920 hz:75 color_depth:8 scaling:off origin:(2560,-162) degree:270" > /dev/null 2>&1 &'

fish_vi_key_bindings
# ctrl+f/e to complete all/word
bind -M insert \cf forward-char
bind -M insert \ce forward-word
bind -M insert \cj history-search-forward
bind -M insert \ck history-search-backward

# set clipboard support for WSL
if uname -r | grep 'microsoft' > /dev/null 
  set -l LOCAL_IP (cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
  set -xg DISPLAY $LOCAL_IP:0
end
