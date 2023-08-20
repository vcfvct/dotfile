## My configuration 
* VIM
  * for fzf.vim, `ctrl+g` is mapped to `:GFiles` to search with .gitignore applied.
     * The [executable path](https://github.com/junegunn/fzf#as-vim-plugin) should be mapped correctly in Plug or with `set rtp+=xxxx` to append to the `runtimepath`.
  * for `vim surround`, select the text in visual mode, and then press `S`(uppercase), then input the quote or parenthesis or `<anyHtmlTag>` etc.
  * in command line mode, `ctrl-b` and `ctro-e` to navigate to beginning/end.

* GIT
  * for `git config --global user.email xxx`, can *NOT* surround email address with `""` like how user name is set.
* Fish shell
  * more on `.config/fish/config.fish`

~~NERDTree is awesome~~
Actually find `coc-explorer` is much faster than NERDTree.

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
  * for [project specific settings](https://github.com/neoclide/coc.nvim/wiki/Using-the-configuration-file#configuration-file-resolve), use `./.vim/coc-settings.json` file. one useful setting here we could do is for setting `python.pythonPath` to local `venv`'s python so that the LSP could kick-in.
* on MacOS, `Terminal->Preferences->Keyboard` set `Use Option as Meta Key`. then map <A-f> to `:Format<cr>`.
  * For iTerm2, need to make it `ESC` in `profiles->keys`, and then add specific mapping to the list
