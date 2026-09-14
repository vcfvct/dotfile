#!/usr/bin/env bash
set -euo pipefail
trap 'printf "Ubuntu user setup failed at line %s\n" "$LINENO" >&2' ERR
repository=${1:?repository URL}
revision=${2:?40-character commit}
installer_revision=${3:?Homebrew installer commit}
sync_mode=${4:-sync}
[[ $EUID -ne 0 ]] || { echo "Run this script as the Linux user, not root." >&2; exit 1; }
[[ $revision =~ ^[a-f0-9]{40}$ && $installer_revision =~ ^[a-f0-9]{40}$ ]]
[[ $repository == https://github.com/* ]] || { echo "Expected an HTTPS GitHub repository." >&2; exit 1; }
scripts=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
export USER
USER=$(id -un)
export HOME
HOME=$(getent passwd "$USER" | cut -d: -f6)
cd "$HOME"
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
prefix=/home/linuxbrew/.linuxbrew
if [[ ! -x $prefix/bin/brew ]]; then
    installer=$(mktemp)
    trap 'rm -f -- "$installer"' EXIT
    curl --fail --show-error --location --retry 3 \
        "https://raw.githubusercontent.com/Homebrew/install/$installer_revision/install.sh" -o "$installer"
    NONINTERACTIVE=1 bash "$installer"
    rm -f -- "$installer"
    trap - EXIT
fi
eval "$("$prefix/bin/brew" shellenv bash)"
brew bundle --file="$scripts/../Brewfile" --no-upgrade
export PATH="$prefix/opt/node@22/bin:$PATH"

checkout="$HOME/source/repos/dotfile"
if [[ ! -e $checkout ]]; then
    mkdir -p "$(dirname "$checkout")"
    git clone "$repository" "$checkout"
fi
[[ $(git -C "$checkout" rev-parse --show-toplevel) == "$checkout" ]] || {
    echo "Destination is not the expected repository: $checkout" >&2; exit 1;
}
origin=$(git -C "$checkout" remote get-url origin)
origin=${origin/git@github.com:/https:\/\/github.com\/}
[[ ${origin%.git} == "${repository%.git}" ]] || {
    echo "Existing checkout has a different origin: $origin" >&2; exit 1;
}
current=$(git -C "$checkout" rev-parse HEAD)
if [[ $current != "$revision" ]]; then
    [[ -z $(git -C "$checkout" status --porcelain) ]] || {
        echo "Linux checkout has local changes; refusing to change revision." >&2; exit 1;
    }
    git -C "$checkout" fetch origin "$revision"
    git -C "$checkout" checkout --detach "$revision"
fi
cd "$checkout"
# Use this bootstrap's safe linker, even before these changes are published.
node "$scripts/../../symbolLink.js" --devbox

mkdir -p "$HOME/.config/fish/conf.d"
write_managed_file() {
    local target=$1 temp
    temp=$(mktemp "$(dirname "$target")/.devbox-write.XXXXXX")
    cat > "$temp"
    if [[ -f $target ]] && cmp -s "$target" "$temp"; then
        rm -f -- "$temp"
        return
    fi
    if [[ -e $target || -L $target ]]; then
        mv -- "$target" "$target.devbox-backup-$(date +%s%N)"
    fi
    chmod 0644 "$temp"
    mv -- "$temp" "$target"
}
write_managed_file "$HOME/.config/fish/conf.d/devbox-brew.fish" <<'FISH'
if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)
    fish_add_path --path --prepend /home/linuxbrew/.linuxbrew/opt/node@22/bin
end
FISH
shellenv='eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"'
for file in "$HOME/.profile" "$HOME/.bashrc"; do
    if ! grep -Fqx "$shellenv" "$file" 2>/dev/null; then
        {
            if [[ -f $file ]]; then cat "$file"; fi
            printf '\n%s\n' "$shellenv"
        } | write_managed_file "$file"
    fi
done
# Fisher 4 uses fish_plugins, not the legacy fishfile. Install only missing entries.
fish "$scripts/fish-plugins.fish" "$checkout/.config/fish/fishfile"
if [[ $sync_mode == sync ]]; then
    nvim --headless '+Lazy! sync' +qa
elif [[ $sync_mode != skip ]]; then
    echo "Unknown Neovim sync mode: $sync_mode" >&2; exit 1
fi
bash "$scripts/ubuntu-verify.sh" "$checkout"
