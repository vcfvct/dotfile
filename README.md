## My configuration 
* VIM
  * for fzf.vim, `ctrl+g` is mapped to `:GFiles` to search with .gitignore applied.
  * for `vim surround`, select the text in visual mode, and then press `S`(uppercase), then input the quote or parenthesis or `<anyHtmlTag>` etc.

* GIT
* Fish shell
  * with [fisherman fzf](https://github.com/fisherman/fzf) can be set using `ag/rg` to respect `.gitignore` in the result by: 
    * `set -U FZF_FIND_FILE_COMMAND "ag -l --hidden --ignore .git"`  **OR**  `set -U FZF_FIND_FILE_COMMAND 'rg --files --hidden --smartcase --glob --height=15 "!.git/*"'`
    * use `ctrl-o` to open file directly in vim/nvim. `ctrl-r` to search cmd history.
      * To use `ctrl-p` to open file, need to edit the key-bindings inside `~/.config/fish/functions/fish_user_key_bindings.fish`, change `\co` to `\cp`.

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


