# Portable Dev Box setup

Windows: WinGet, PowerShell 7, Neovim, psmux, Oh My Posh, Node.js (existing installation or WinGet LTS),
fzf, ripgrep, delta, uv, jq, a Nerd Font, and the modules used by
`wsl\powershell_profile.ps1`.

Ubuntu: **Homebrew/Linuxbrew** provides all developer tools in `Brewfile`,
including fish, Fisher, Neovim, tmux, Git, Node, and the tools used by the
dotfiles. No developer-tool PPAs are added. `apt-get` is used only for missing
Homebrew OS prerequisites: build-essential, procps, curl, file, git,
ca-certificates, and sudo. Git from apt bootstraps Homebrew; brewed Git is
preferred afterwards. The supported prefix is `/home/linuxbrew/.linuxbrew`.

## Run on an existing Windows Dev Box

Clone this repository and run in **PowerShell 7 under your own Windows account**.
The scripts use their checkout location; no Windows username is hardcoded.

```powershell
cd "$HOME\source\repos\dotfile"
pwsh -NoProfile -File .\devbox\bootstrap.ps1 -Phase Preflight
pwsh -NoProfile -File .\devbox\bootstrap.ps1 -Phase Windows
pwsh -NoProfile -File .\devbox\bootstrap.ps1 -Phase Wsl
pwsh -NoProfile -File .\devbox\bootstrap.ps1 -Phase Verify
```

`-Phase All` runs Windows, Wsl, and Verify in order. With no phase, the default
is read-only Preflight. `-SkipNeovimSync` defers plugin installation but not
tool installation or dotfile setup. `Verify` checks installed commands and
configuration targets; interactive profile/prompt and multiplexer behavior
still need checking in a real terminal.

Edit `devbox\settings.json` or supply `-SettingsPath` to keep machine-specific
choices outside the repository. Default Ubuntu is **Ubuntu-26.04**; existing
Ubuntu-22.04, Rancher Desktop, and other distributions are not upgraded,
deleted, or stopped. To intentionally configure an existing Ubuntu instead:

```powershell
pwsh -NoProfile -File .\devbox\bootstrap.ps1 -Phase Wsl -Distro Ubuntu-22.04
pwsh -NoProfile -File .\devbox\bootstrap.ps1 -Phase Verify -Distro Ubuntu-22.04
```

For an existing distribution, the current default non-root user is reused.
For a new/root-default distribution, the default is `developer`.
Override it with `-LinuxUser name` or `linuxUser` in settings. Newly created
accounts have a locked password and membership in `sudo`, **not passwordless
sudo**. Set the password interactively when ready:

```powershell
wsl -d Ubuntu-24.04 -u root -- passwd developer
```

After finishing, close Ubuntu sessions and terminate **only that distribution**
when safe so `/etc/wsl.conf` takes effect:

```powershell
wsl --terminate Ubuntu-24.04
wsl -d Ubuntu-24.04
```

The Windows default WSL distribution is deliberately not changed. The existing
PowerShell `ll` helper calls `wsl eza` without a distribution name; if you want
it to use this Ubuntu, explicitly choose `wsl --set-default Ubuntu-24.04`.
Select **JetBrainsMono Nerd Font** in your terminal's font settings.

## WSL platform / reboot boundary

WSL2 requires virtualization support (nested virtualization on the Dev Box VM)
and Windows optional features. These can require administrator involvement.
If WSL is unavailable, run this phase **in an elevated PowerShell**, or have
your administrator provision equivalent platform prerequisites:

```powershell
pwsh -NoProfile -File .\devbox\bootstrap.ps1 -Phase WslPlatform
```

If it reports REBOOT REQUIRED, save work and reboot manually. Rerun WslPlatform
after reboot, then run Wsl/All under your normal Windows account.
The bootstrap never reboots, shuts down WSL, changes an existing distro's WSL
version, or schedules a hidden continuation. A WSL1 target fails with a message
explaining the explicit conversion command. Resume by rerunning the failed
phase; idempotent checks inspect actual state rather than trusting marker files.
Do not run personal phases as LocalSystem or another administrator account.

## Dev Box YAML

The repository-root `workload.yaml` uses the Microsoft catalog `~/powershell`
user task **after first sign-in**. It expects the Microsoft-configured image to
supply Git and PowerShell 7, clones the checkout if absent, and runs read-only
`Preflight`. If either prerequisite is missing, it stops with a clear error
rather than attempting an unattended install. It never enables WSL or runs the
mutating bootstrap phases. Confirm the task is available with the VS Code Dev
Box extension's **List Available Tasks For This Dev Box** and validate the YAML
in the Dev Box portal. The YAML clones `master` only when the checkout does not
exist; publish these files before using it, or choose a published release tag
for a fixed revision. It never pulls, resets, or overwrites an existing checkout.

After sign-in, review Preflight and run the remaining phases in **Run on an
existing Windows Dev Box** above. If WSL2 needs enabling, use the separate
elevated `WslPlatform` phase and reboot as instructed before running `Wsl`
under your own account. The Windows phase uses `devbox/settings.json` as the
single list of packages to install and can show UAC prompts in your logged-in
session. `--silent` and `--disable-interactivity` do not bypass UAC; if you
lack permission to approve an installer or enable WSL2, ask your administrator.
Review the logs and rerun a failed phase rather than relying on an unattended
customization to approve prompts.

## Safety and repeatability

- `symbolLink.js --devbox` is the safe, narrowed dev-tool manifest. It validates
  sources before changing destinations, backs up conflicting paths beside
  themselves as `*.devbox-backup-<id>`, and fails on errors. It refuses linked
  parent directories instead of modifying another checkout through them.
- Windows directories use junctions; individual files are copies to avoid
  requiring Developer Mode/admin symlink privileges. Rerun Windows after
  changing those source files. Linux uses symlinks. The old linker behavior
  without `--devbox` remains available and is **not** used by this bootstrap.
- Windows Neovim maps to `%LOCALAPPDATA%\nvim`. The PowerShell 7 current-host
  profile is a loader for this checkout's `wsl\powershell_profile.ps1`; an
  existing profile is moved to a backup, not merged or deleted. Windows
  PowerShell 5.1 and other hosts are not configured.
- Linux keeps an independent checkout in `$HOME/source/repos/dotfile`, at the
  Windows checkout's committed HEAD. Uncommitted dotfile changes do not cross
  into Linux. The local safe linker and bootstrap scripts are used even during
  pre-publication testing. An existing Linux checkout with conflicting changes
  is not reset; a different origin is rejected.
- An existing Homebrew installation owned by another Linux account is not
  taken over. The installer runs as the intended user, never root. Root only
  prepares OS prerequisites, creates the user/prefix, and sets shell/WSL user.
- Homebrew's installer is pinned to a commit in settings. WinGet installs
  missing packages without upgrading existing ones. `brew bundle --no-upgrade`
  does likewise. This is repeatable configuration, **not a frozen package
  image**: formulae, missing Windows packages, modules, and new Fisher plugins
  resolve from their configured upstream channels. Neovim sync may update its
  lockfile; use `-SkipNeovimSync` when that is unwanted.
- Fisher reads the repository's legacy `fishfile` explicitly, maps the old
  fish-nvm name to nvm.fish, and installs missing plugins without deleting
  unrelated plugins. Homebrew supplies Fisher itself.
- `/etc/wsl.conf` is backed up before its default-user setting is updated.
  Other parsed settings are preserved, though INI comments/formatting are not.
- On Ubuntu images whose first-run Insights script assumes a Bash login shell,
  the Wsl phase backs up `/usr/lib/wsl/ubuntu-insights.sh` and makes its `su`
  commands use Bash explicitly. This lets first-run setup work with fish as the
  default shell; it does not choose an Insights consent setting. A package
  update may replace the script, in which case rerun the Wsl phase if needed.
- No tokens, passwords, SSH keys, proxy credentials, execution-policy changes,
  broad sudo exceptions, or remote-shell access are installed.

Logs are saved under `%LOCALAPPDATA%\dotfile-devbox\logs`. They can include
local paths and package output; review them before sharing. On failure, read
the transcript, correct the prerequisite, and rerun that phase.

## Validate changes without provisioning

```powershell
node --test .\devbox\tests\linker.test.cjs
pwsh -NoProfile -File .\devbox\tests\validate.ps1
```

The tests use temporary homes and do not install software or change your
profiles. They cover backup preservation, missing-source failure, linked-parent
rejection, broken links, Windows Neovim mapping, and no-op reruns.

References:

- https://docs.brew.sh/Homebrew-on-Linux
- https://docs.brew.sh/Installation
- https://github.com/jorgebucaran/fisher
- https://learn.microsoft.com/azure/dev-box/how-to-configure-user-customizations
- https://learn.microsoft.com/azure/dev-box/concept-what-are-dev-box-customizations
- https://github.com/microsoft/devcenter-catalog
