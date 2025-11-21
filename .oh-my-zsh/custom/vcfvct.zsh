# git log and pipe to fzf
function fzf_git_log() {
  local selections=$(
    git ll --color=always "$@" |
      fzf --ansi --no-sort --height 100% \
          --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                     xargs -I@ sh -c 'git show --color=always @'"
    )
  if [[ -n $selections ]]; then
    local commits=$(echo "$selections" | cut -d' ' -f2 | tr '\n' ' ')
    git show $commits
  fi
}

# fuzzy find file and edit. `fzf_find_edit`
function ffe() {
  local file=$(
    fzf --no-multi --select-1 --exit-0 \
      --preview 'batcat --color=always --line-range :500 {}'
  )
  if [[ -n $file ]]; then
    $EDITOR "$file"
  fi
}
# bindkey -s '^p' 'ffe^M' 

# weather query, example: wttr germantown-md ja
function wttr(){
  local location=${1:-"mclean-va"}
  local language=${2:-"en"}
  curl -H "Accept-Language: $language" "wttr.in/$location?F"
}


__fzf_use_tmux__() {
  [ -n "$TMUX_PANE" ] && [ "${FZF_TMUX:-0}" != 0 ] && [ ${LINES:-40} -gt 15 ]
}

__fzfcmd() {
  __fzf_use_tmux__ &&
    echo "fzf-tmux -d${FZF_TMUX_HEIGHT:-40%}" || echo "fzf"
}

## file open
__vcfvct-fo() (
  setopt localoptions pipefail no_aliases 2> /dev/null
  local file=$(eval "${FZF_DEFAULT_COMMAND}" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS --preview 'batcat --color=always --line-range :500 {}'" $(__fzfcmd) -m "$@" | while read item; do
    echo -n "${(q)item}"
  done)
  local ret=$?
  if [[ -n $file ]]; then
    $EDITOR $file
  fi
  return $ret
)

__vcfvct-fo-widget(){
  __vcfvct-fo
  local ret=$?
  zle reset-prompt
  return $ret
}

zle -N __vcfvct-fo-widget
bindkey ^p __vcfvct-fo-widget

# CTRL-R - Paste the selected command from history into the command line
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rl 1 |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}
zle     -N   fzf-history-widget
bindkey '^R' fzf-history-widget

### Fix slowness of pastes with zsh-syntax-highlighting.zsh
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
### Fix slowness of pastes
