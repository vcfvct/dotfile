#!/usr/bin/env bash
set -euo pipefail
trap 'printf "Ubuntu root setup failed at line %s\n" "$LINENO" >&2' ERR
phase=${1:?prepare or finish}
user=${2:?Linux user}
[[ $EUID -eq 0 && $user =~ ^[a-z_][a-z0-9_-]{0,31}$ && $user != root ]]
. /etc/os-release
[[ $ID == ubuntu ]] || { echo "Only Ubuntu is supported." >&2; exit 1; }

if [[ $phase == prepare ]]; then
    # apt is limited to the OS prerequisites for Homebrew, never developer tools.
    prerequisites=(build-essential procps curl file git ca-certificates sudo)
    missing=()
    for package in "${prerequisites[@]}"; do
        if [[ $(dpkg-query -W -f='${Status}' "$package" 2>/dev/null || true) != 'install ok installed' ]]; then
            missing+=("$package")
        fi
    done
    if ((${#missing[@]})); then
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "${missing[@]}"
    fi
    if ! id "$user" >/dev/null 2>&1; then
        useradd --create-home --shell /bin/bash --groups sudo "$user"
        echo "Created $user with a locked password. Set it interactively later; no passwordless sudo was added."
    fi
    prefix=/home/linuxbrew/.linuxbrew
    if [[ -e $prefix ]]; then
        [[ $(stat -c %U "$prefix") == "$user" ]] || {
            echo "$prefix is owned by another account; refusing to take it over." >&2; exit 1;
        }
    else
        install -d -m 0755 /home/linuxbrew
        install -d -m 0755 -o "$user" -g "$(id -gn "$user")" "$prefix"
    fi
elif [[ $phase == finish ]]; then
    fish=/home/linuxbrew/.linuxbrew/bin/fish
    [[ -x $fish ]] || { echo "Linuxbrew fish is missing." >&2; exit 1; }
    grep -Fxq "$fish" /etc/shells || printf '%s\n' "$fish" >> /etc/shells
    [[ $(getent passwd "$user" | cut -d: -f7) == "$fish" ]] || usermod --shell "$fish" "$user"
    # Preserve other WSL settings; update only the default user in its INI section.
    /home/linuxbrew/.linuxbrew/bin/python3 - "$user" <<'PY'
import configparser
import os
import pathlib
import shutil
import sys
import tempfile
import uuid
path = pathlib.Path("/etc/wsl.conf")
config = configparser.ConfigParser(interpolation=None, strict=True)
config.optionxform = str
if path.exists():
    config.read(path)
if not config.has_section("user"):
    config.add_section("user")
if config.get("user", "default", fallback=None) != sys.argv[1]:
    config.set("user", "default", sys.argv[1])
    if path.exists():
        shutil.copy2(path, str(path) + ".devbox-backup-" + uuid.uuid4().hex)
    with tempfile.NamedTemporaryFile(mode="w", dir="/etc", delete=False) as temp:
        config.write(temp)
    os.chmod(temp.name, 0o644)
    os.replace(temp.name, path)
PY
    # Ubuntu's first-run Insights script passes $0/$1 to `su -c` using Bash
    # semantics. Fish does not expose those positional parameters the same way.
    # Keep the user's login shell as fish, but run these OOBE commands in Bash.
    /home/linuxbrew/.linuxbrew/bin/python3 - <<'PY'
import pathlib
import shutil
import uuid

path = pathlib.Path('/usr/lib/wsl/ubuntu-insights.sh')
if path.exists():
    original = path.read_bytes()
    old = b'su "$user" -c'
    new = b'su -s /bin/bash "$user" -c'
    if old in original:
        backup = pathlib.Path(str(path) + '.devbox-backup-' + uuid.uuid4().hex)
        shutil.copy2(path, backup)
        path.write_bytes(original.replace(old, new))
        print(f'Backup: {backup}')
PY
else
    echo "Unknown phase: $phase" >&2
    exit 1
fi
