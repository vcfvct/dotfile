#!/usr/bin/env bash
set -euo pipefail

repo_path=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

link_path() {
  local relative_path=$1
  local destination_path=${2:-$relative_path}
  local source_path="${repo_path}/${relative_path}"
  local target_path="${HOME}/${destination_path}"

  if [[ ! -e "$source_path" ]]; then
    printf 'Source does not exist, skipping: %s\n' "$source_path" >&2
    return
  fi

  mkdir -p -- "$(dirname -- "$target_path")"
  if [[ -e "$target_path" || -L "$target_path" ]]; then
    rm -rf -- "$target_path"
  fi

  ln -s -- "$source_path" "$target_path"
  printf 'Symbolic link created: %s -> %s\n' "$source_path" "$target_path"
}

# Keep these lists synchronized with the Unix branch of symbolLink.js.
common_files=(
  '.vimrc'
  # '.coc.vim' # Disabled for now.
  '.gitignore'
  '.gitconfig'
  '.eslintrc.js'
  '.tmux.common.conf'
)

unix_files=(
  '.zshrc'
  '.oh-my-zsh/custom/vcfvct.zsh'
  '.tmux.conf'
  '.tmux.conf.local'
)

fish_files=(
  '.config/fish/config.fish'
  '.config/fish/fishfile'
  '.config/fish/functions/gll.fish'
  '.config/fish/functions/wttr.fish'
  '.config/fish/functions/fish_user_key_bindings.fish'
  '.config/fish/functions/fzf_find_edit.fish'
  '.config/fish/functions/fzf_reverse_isearch.fish'
)

config_directories=(
  'alacritty'
  'hyper'
  'kitty'
  'nvim'
  'ripgrep'
  'zathura'
)

for file in "${common_files[@]}" "${unix_files[@]}" "${fish_files[@]}"; do
  link_path "$file"
done

link_path '.gitignore' '.ignore'

for directory in "${config_directories[@]}"; do
  link_path ".config/${directory}"
done

printf '%s\n' '------ All symbolic links created. ------'
