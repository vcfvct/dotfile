## My configuration

- VIM

  - for fzf.vim, `ctrl+g` is mapped to `:GFiles` to search with .gitignore applied.
    - The [executable path](https://github.com/junegunn/fzf#as-vim-plugin) should be mapped correctly in Plug or with `set rtp+=xxxx` to append to the `runtimepath`.
  - for `vim surround`, select the text in visual mode, and then press `S`(uppercase), then input the quote or parenthesis or `<anyHtmlTag>` etc.
  - in command line mode, `ctrl-b` and `ctro-e` to navigate to beginning/end.

- GIT
  - for `git config --global user.email xxx`, can _NOT_ surround email address with `""` like how user name is set.
- Fish shell
  - more on `.config/fish/config.fish`

~~NERDTree is awesome~~
Actually find `coc-explorer` is much faster than NERDTree.

`Fish VI mode`が大好きです

### tmux and psmux

The tmux configuration is split by responsibility so the same repository works
with tmux on Linux/macOS/WSL and with native [psmux](https://github.com/psmux/psmux)
on Windows:

| File | Purpose |
| --- | --- |
| `.tmux.common.conf` | Portable tmux commands and key bindings shared by both programs |
| `.tmux.conf` | Unix entry point, terminal integration, and the oh-my-tmux shell engine |
| `.tmux.conf.local` | Unix oh-my-tmux theme variables and Unix clipboard integration |
| `.psmux.conf` | Windows entry point, native theme options, PowerShell, and psmux plugins |

Do not put shell commands, platform-specific clipboard tools, terminal capability
overrides, or plugins in `.tmux.common.conf`. A shared setting should be changed
there rather than duplicated in both entry points.

`symbolLink.js` selects the entry points automatically:

- All platforms receive `~/.tmux.common.conf`.
- Linux, macOS, and WSL receive `~/.tmux.conf` and `~/.tmux.conf.local`.
- Native Windows receives `~/.psmux.conf`.

Run the Node linker from the repository root after cloning:

```sh
node symbolLink.js
```

On Unix, `./sLinks.sh` is an equivalent Bash alternative. Its file lists are
kept synchronized with the Unix branch of `symbolLink.js`. The legacy
`.coc.vim` link is intentionally disabled in both scripts.

Psmux searches for `.psmux.conf` before `.tmux.conf`, so Windows does not execute
the Unix configuration. Restart the relevant server after changing links or
startup-only settings:

```sh
# Unix/WSL/macOS
tmux kill-server

# Windows PowerShell
psmux kill-server
```

#### Why `.tmux.conf` contains many commented lines

The long commented section after the `# -- 8< --` marker is executable code from
[oh-my-tmux](https://github.com/gpakosz/.tmux), not dead comments. tmux ignores
it, while this command removes each line's `# ` prefix and passes the result to
`sh`:

```tmux
run 'cut -c3- ~/.tmux.conf | sh -s _apply_configuration'
```

That shell program reads `.tmux.conf.local` and generates the Unix theme,
status bar, battery and uptime values, prefix/root/session indicators, clipboard
bindings, and helper commands. Keep the commented section while using the
current Unix oh-my-tmux theme. Psmux does not need it because `.psmux.conf` uses
native style options and PowerShell plugins.

#### Windows battery plugin

The Windows status line expects `#{@battery_display}` from the official
`psmux-battery` plugin. Install the psmux plugin manager once:

```powershell
git clone https://github.com/psmux/psmux-plugins.git "$env:TEMP\psmux-plugins"
Copy-Item "$env:TEMP\psmux-plugins\ppm" "$env:USERPROFILE\.psmux\plugins\ppm" -Recurse
Remove-Item "$env:TEMP\psmux-plugins" -Recurse -Force
```

Start psmux and press `Ctrl+A`, then capital `I`, to install the plugins declared
in `.psmux.conf`. Reload with `psmux source-file ~/.psmux.conf` or restart the
server. The status line still works without the plugin; only its battery segment
is omitted.

### macOS specific

#### macos finder open in new tab

System Preferences > Dock > Prefer tabs when opening documents and select Always.

#### font subpixle antialiasing

MacOS Mojave disables subpixel antialiasing, also known as font smoothing, by default.

> defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO

### git detla

In `.gitconfig`, [delta](https://github.com/dandavison/delta) is used for pager and diff. For wsl/chromeos-linux, go to the release page download corresponding `.deb` and install with `sudo dpkg -i xxx.deb`.

~~### coc nvim~~

- For coc plugin, use the official recommended way `:CocInstall` instead of vim plug to manage so that it could get auto update. Example:
  > :CocInstall coc-json coc-tsserver coc-eslint coc-pairs coc-git
- use `ctrl-o` to go back after `gd or gi`.
- use `:CocConfig` or edit `~/.config/nvim/coc-settings.json` directly to add [ts server options](https://github.com/neoclide/coc-tsserver#configuration-options) just like inside vscode. for example:
  - `"typescript.preferences.importModuleSpecifier": "relative",`
  - `"typescript.format.insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces":true`
  - for [project specific settings](https://github.com/neoclide/coc.nvim/wiki/Using-the-configuration-file#configuration-file-resolve), use `./.vim/coc-settings.json` file. one useful setting here we could do is for setting `python.pythonPath` to local `venv`'s python so that the LSP could kick-in.
- on MacOS, `Terminal->Preferences->Keyboard` set `Use Option as Meta Key`. then map <A-f> to `:Format<cr>`.
  - For iTerm2, need to make it `ESC` in `profiles->keys`, and then add specific mapping to the list
