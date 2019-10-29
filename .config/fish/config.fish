#set -xU JAVA_HOME (/usr/libexec/java_home)
#set -xU M2_HOME /usr/local/maven3
#set -xU PYTHON3_HOME ~/Library/Python/3.7

set PATH $PYTHON3_HOME/bin $M2_HOME/bin $ANDROID_HOME/tools $ANDROID_HOME/platform-tools $PATH 
set -g theme_display_git_master_branch yes


abbr top "htop"
abbr vi "nvim"
abbr cat "bat"
# usage: yaml2js < test.yaml > out.json
alias yaml2js="python3 -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)'"

### set current session default node/npm version to lastest installed(silently for stdout).
### -> comment this for now in favor of 'fnm'.
# nvm alias default node >/dev/null

fish_vi_key_bindings
