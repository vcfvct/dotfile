# AstroNvim User Configuration Example

A user configuration template for [AstroNvim](https://github.com/AstroNvim/AstroNvim)

## 🛠️ Installation

#### Make a backup of your current nvim and shared folder

```shell
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

#### Clone AstroNvim

```shell
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
```

#### Make SymbolicLink for user config

```shell
ln -s ~/GIT/dotfile/.config/astro ~/.config/nvim/lua/user
```

## misc

* have to install `gcc/g++` for tree-sitter to compile.
* remapped `f12` to toggle float terminal, ctrl-p for 
* use `MasonInstall xxx-lsp` to install language servers.
* neo-tree toggle hidden files -> `H`.
* comment code: `<leader>/` to for current line, otherwise use g -> options.
* for language specific 'failed to load,..., query: invalid structure at position', need to `:TSInstall ThisLanguage`.

## Windows
1. backup: `Copy-Item -Path "$env:LOCALAPPDATA\nvim" -Destination "$env:LOCALAPPDATA\nvim-backup" -Recurse -Force`
2. remove existing: `rmdir "$env:LOCALAPPDATA\nvim" -Recurse -Force`. `rmdir` command is another alias for the Remove-Item cmdlet.
3. clone repo:
    ```powershell
    git clone --depth 1 https://github.com/AstroNvim/AstroNvim $env:LOCALAPPDATA\nvim
    ```
4. create SymbolicLink: `New-Item -ItemType SymbolicLink -Target "$env:USERPROFILE\source\repos\dotfile\.config\astro" -Path "$env:LOCALAPPDATA\nvim\lua\user"`

### tree-sitter compile
* need a c compiler similar to `gcc` in linux: use `zig` as c compiler `choco install zig -y`

## shortcuts
* use `ctrl+|` to create verticle spilit buffer and `ctrl+\` for horizontal ones. And use `ctrl+up/down/left/right` to adjust width/height.
* `]/[+b` and `]/[+t` to navigate between buffers and tabs. 
* inside Telescope, when it is `normal` mode(esc), use `j/k` to up and down, or in `insert` mode, use `ctrl+j/k`. In normal mode, use `?` to show all mappings.
* `]\[+d` to navigate diagnostic. use `<leader>lD` to see all diagnostic.
* `<leader>lr` to rename Symbol. `<leader>lf` to format buffer. `<leader>la` to get code actions.

## Debugging
* for python, install `pyright, debugpy, isort`, `black` is optional. Then use f9 to toggle breakpoint and f5 to start. more bindings see `space+d`. [sample video by Micah Halter](https://www.youtube.com/watch?v=04z9v0xMDkw)

## neovim lua rpel
* use `:lua` to evaluate commands like `:lua print(jit.os)` to see lua runtime values.

## Troubleshooting
* For `query: invalid structure at position 2992 for language lua stack traceback: [C]: in function '_ts_parse_query'`, based on [this github issue reply](https://github.com/LunarVim/LunarVim/issues/3680#issuecomment-1373552082), after running `:echo nvim_get_runtime_file('parser', v:true)`, remove the system `lua.so` under system path( not the one under `nvim-treesitter/parser`).
