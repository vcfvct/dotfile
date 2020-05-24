## My configuration 
* VIM
  * for fzf.vim, `ctrl+g` is mapped to `:GFiles` to search with .gitignore applied.
     * The [executable path](https://github.com/junegunn/fzf#as-vim-plugin) should be mapped correctly in Plug or with `set rtp+=xxxx` to append to the `runtimepath`.
  * for `vim surround`, select the text in visual mode, and then press `S`(uppercase), then input the quote or parenthesis or `<anyHtmlTag>` etc.

* GIT
  * for `git config --global user.email xxx`, can *NOT* surround email address with `""` like how user name is set.
* Fish shell
  * with [fisherman fzf](https://github.com/fisherman/fzf) can be set using `ag/rg` to respect `.gitignore` in the result by: 
    * `set -U FZF_FIND_FILE_COMMAND "ag -l --hidden --ignore .git"`  **OR**  `set -U FZF_FIND_FILE_COMMAND 'rg --files --hidden --smartcase --glob --height=15 "!.git/*"'`
    * `set -U FZF_OPEN_COMMAND "ag -l --hidden --ignore .git . \$dir 2> /dev/null"` **OR** `set -xU FZF_OPEN_COMMAND 'rg --files --no-ignore-vcs --hidden'`
    * use `ctrl-o` to open file directly in vim/nvim. `ctrl-r` to search cmd history.
      * To use `ctrl-p` to open file, need to edit the key-bindings inside `~/.config/fish/functions/fish_user_key_bindings.fish`, change `\co` to `\cp`.
  * one difference between ag and rg is rg does not respect the global `.gitignore` file if it is already in a git repo, which is not good if what you expect is the combination of local and global ignore.

NERDTree is awesome
  * use `N` `ctrl+w` and `>/<` to expend/subtract the width of file explore. `N` is the column size to move.

`Fish VI mode`が大好きです

### macOS specific
#### macos finder open in new tab
System Preferences > Dock > Prefer tabs when opening documents and select Always.
#### font subpixle antialiasing
MacOS Mojave disables subpixel antialiasing, also known as font smoothing, by default.
>defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO 

### coc nvim
* For coc plugin, use the official recommended way `:CocInstall` instead of vim plug to manage so that it could get auto update. Example:
  > :CocInstall coc-json coc-tsserver coc-eslint coc-pairs coc-git
* use `ctrl-o` to go back after `gd or gi`.
* use `:CocConfig` or edit `~/.config/nvim/coc-settings.json` directly to add [ts server options](https://github.com/neoclide/coc-tsserver#configuration-options) just like inside vscode. for example:
  * `"typescript.preferences.importModuleSpecifier": "relative",`
  * `"typescript.format.insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces":true`
* on MacOS, `Terminal->Preferences->Keyboard` set `Use Option as Meta Key`. then map <A-f> to `:Format<cr>`.
  * For iTerm2, need to make it `ESC` in `profiles->keys`, and then add specific mapping to the list

### WSL vim clipboard sharing
From [this gist](https://gist.github.com/necojackarc/02c3c81e1525bb5dc3561f378e921541).
#### 1. Set up VcXsrv Windows X Server
Download and install [VcXsrv Windows X Server](https://sourceforge.net/projects/vcxsrv/),
then run XLaunch with the following options:

* Multiple windows (default)
* Start no client (default)
* Extra settings
  * Clipboard (default)
    * Primary Selection (default)
  * Native opengl (default)
  * Disable access control

Basically, you just need to tick all of the extra options. Other than that, every setting is the default.
Click the [Save configuration] button and save the configuration in `C:\Users\<USER NAME>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup` in order to start `VcXsrv` when Windows starts.

#### 2. Connect VxXsrv from Ubuntu on WSL2
Log in to Ubuntu on WSL2 and set the `DISPLAY` environment variable:

```bash
LOCAL_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
export DISPLAY=$LOCAL_IP:0
```

That's it! Enjoy your Vim life on Windows!
