#!/usr/bin/env bash
set -euo pipefail
checkout=${1:?Linux checkout}
scripts=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
[[ $EUID -ne 0 ]]
prefix=/home/linuxbrew/.linuxbrew
eval "$("$prefix/bin/brew" shellenv bash)"
export PATH="$prefix/opt/node@22/bin:$PATH"
for command in brew fish nvim tmux git node fzf rg bat eza delta fd jq python3 uv btm; do
    resolved=$(command -v "$command")
    [[ $resolved == "$prefix/"* ]] || {
        echo "$command is not provided by Linuxbrew: $resolved" >&2; exit 1;
    }
done
cd "$checkout"
node "$scripts/../../symbolLink.js" --devbox --verify
[[ $(readlink -f "$HOME/.config/nvim") == "$checkout/.config/nvim" ]]
[[ $(readlink -f "$HOME/.config/fish/config.fish") == "$checkout/.config/fish/config.fish" ]]
fish -c 'functions -q fisher; and functions -q nvm; and functions -q fish_prompt'
fish --version
nvim --version | head -n 3
tmux -V
echo "Linuxbrew commands and dotfile targets verified."
