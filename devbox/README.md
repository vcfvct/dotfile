# Portable Dev Box setup

Windows: WinGet, PowerShell 7, Neovim, psmux, Oh My Posh, fnm/Node,
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
choices outside the repository. Default Ubuntu is **Ubuntu-24.04**; existing
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

The repository-root `workload.yaml` uses the Microsoft catalog tasks
`~/winget` and `~/powershell`. Confirm these tasks are available and permitted
using the VS Code Dev Box extension's **List Available Tasks For This Dev Box**.
Validate the YAML in the Dev Box portal before provisioning. Project policies,
WinGet package elevation, endpoint access, and WSL platform prerequisites
remain prerequisites; user YAML does not bypass them.

**Commit and publish these files before using the YAML on a new machine.**
The YAML initially clones `master`; choose a published release tag for a fixed
bootstrap version (`git clone --branch` accepts branches/tags, not commit SHAs).
For a commit SHA, use clone followed by an explicit detached checkout.
It never pulls, resets, or overwrites an existing checkout. Update an old
checkout explicitly after preserving local changes.

When creating a new Dev Box, choose the repository containing `workload.yaml`,
or upload that YAML locally. User tasks run after first sign-in. They install
Git/PowerShell and invoke the same `-Phase All` entry point. Provision the WSL
platform through the image or an admin-approved team task first. The ordinary
bootstrap remains usable even if your project disables personal customization.

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
