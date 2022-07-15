### universal variables only need to set once
#set -xU JAVA_HOME (/usr/libexec/java_home)
#set -xU M2_HOME /usr/local/maven3
#set -xU PYTHON3_HOME ~/Library/Python/3.7
#set -U nvm_default_version v1xxxx
#set -xU GIT_USER $USER
#set -Ux FZF_DEFAULT_OPTS '--height 75% --multi --reverse --bind ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up'
#set -Ux FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!node_modules/*"'
#set -Ux FZF_OPEN_COMMAND 'rg --files  --hidden'
#set -Ux theme_nerd_fonts yes
#set -xU theme_display_git_master_branch yes
#set -xU LSCOLORS Gxfxcxdxbxegedabagacad
#set -xU EDITOR nvim

if type -q exa
  alias ll "exa -l --group --icons --sort=modified"
  alias ls exa
else 
  alias ll "ls -lrth"
end

### abbreviations only need to set once
# abbr top "btm -b"
# abbr v "nvim"
# abbr vi "nvim"
# abbr c "bat"
# abbr g "git"
# abbr gl "git pull"
# abbr gp "git push"
# abbr gd "git d"
# abbr gs "git status"
# abbr ef "nvim ~/.config/fish/config.fish"
# abbr ev "nvim ~/.vimrc"
# abbr envim "nvim ~/.config/nvim/init.vim"

# reset display rotation/refresh-rate as MacOS catalina does not remember it any more.
# abbr d2 'displayplacer "id:F42D3DC2-ED3B-550F-83BD-08F41EEC1D50 res:2560x1440 hz:75 color_depth:8 scaling:off origin:(0,0) degree:0" "id:C6033263-C213-FDDE-4F4A-936214D23CB3 res:1200x1920 hz:74 color_depth:8 scaling:off origin:(2560,-180) degree:270" > /dev/null 2>&1 &'
# abbr d3 'displayplacer "id:F42D3DC2-ED3B-550F-83BD-08F41EEC1D50 res:2560x1440 hz:75 color_depth:8 scaling:off origin:(0,0) degree:0" "id:294F2D9D-51BF-7D89-1ADF-E707A4C9D549 res:1792x1120 hz:59 color_depth:4 scaling:on origin:(3760,83) degree:0" "id:C6033263-C213-FDDE-4F4A-936214D23CB3 res:1200x1920 hz:74 color_depth:8 scaling:off origin:(2560,-162) degree:270" > /dev/null 2>&1 &'

# usage: yaml2js < test.yaml > out.json
alias yaml2js="python3 -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)'"

fish_vi_key_bindings
### ctrl+f/e to complete all/word
bind -M insert \cf forward-char
bind -M insert \ce forward-word
bind -M insert \cj history-search-forward
bind -M insert \ck history-search-backward

### set clipboard support for WSL
if uname -r | grep 'microsoft' > /dev/null
  set -l LOCAL_IP (cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
  set -xg DISPLAY $LOCAL_IP:0
  set -xg BREW_HOME /home/linuxbrew/.linuxbrew
  fish_add_path $BREW_HOME/bin 
  abbr open "explorer.exe"
end

fish_add_path /usr/local/bin ~/.local/bin

### NVM https://github.com/fish-shell/fish-shell/issues/583#issuecomment-13758325
function __check_rvm --on-variable PWD --description 'Do nvm stuff'
  status --is-command-substitution; and return
  if test -f .nvmrc; and test -r .nvmrc;
    nvm use
  else
  end
end
