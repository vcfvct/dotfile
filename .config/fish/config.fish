#set -xU JAVA_HOME (/usr/libexec/java_home)
#set -xU M2_HOME /usr/local/maven3
#set -xU PYTHON3_HOME ~/Library/Python/3.7

set PATH $PYTHON3_HOME/bin $M2_HOME/bin $ANDROID_HOME/tools $ANDROID_HOME/platform-tools $PATH 
set -g theme_display_git_master_branch yes

abbr top "htop"
abbr vi "nvim"
abbr cat "bat"
abbr gpl "git pull"
abbr gps "git push"
# usage: yaml2js < test.yaml > out.json
alias yaml2js="python3 -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)'"

fish_vi_key_bindings
# fish completion to repalce 'right' arrow key for whole line and ctrl-w to complete word.
bind -M insert \ce forward-char
bind -M insert \cw forward-word

