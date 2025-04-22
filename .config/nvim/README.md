# AstroNvim User Configuration Example

A user configuration template for [AstroNvim](https://github.com/AstroNvim/AstroNvim)

## misc

- remapped `f12` to toggle float terminal, ctrl-p for
- use `MasonInstall xxx-lsp` to install language servers.
- neo-tree toggle hidden files -> `H`. Use 'D' to search directory(need to install 'fd' on Windows).
- comment code: `<leader>/` to for current line, otherwise use g -> options.
- for language specific 'failed to load,..., query: invalid structure at position', need to `:TSInstall ThisLanguage`.
- in Telescope live-grep(ctrl-g), after initial search, use `ctrl+space` to future search other keywords to achieve kind of fuzzy searching.

## Windows

1. backup: `Copy-Item -Path "$env:LOCALAPPDATA\nvim" -Destination "$env:LOCALAPPDATA\nvim-backup" -Recurse -Force`
2. remove existing: `rmdir "$env:LOCALAPPDATA\nvim" -Recurse -Force`. `rmdir` command is another alias for the Remove-Item cmdlet.
3. create SymbolicLink: `New-Item -ItemType SymbolicLink -Target "$env:USERPROFILE\source\repos\dotfile\.config\nvim" -Path "$env:LOCALAPPDATA\nvim"` -->

## Ubuntu

```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo tar -C /opt -xzf nvim-linux64.tar.gz
sudo ln -s /opt/nvim-linux64/bin/nvim /usr/bin/nvim
```

### tree-sitter compile

- need a c compiler `c/gcc/clang/zig` :
  - Windows: `choco install zig -y`
  - Ubuntu: `sudo apt-get install build-essential`, which will install `gcc`.

## shortcuts

- use `ctrl+|` to create verticle spilit buffer and `ctrl+\` for horizontal ones. And use `ctrl+up/down/left/right` to adjust width/height.
- `]/[+b` and `]/[+t` to navigate between buffers and tabs.
- inside Telescope, when it is `normal` mode(esc), use `j/k` to up and down, or in `insert` mode, use `ctrl+j/k`. In normal mode, use `?` to show all mappings.
- `]\[+d` to navigate diagnostic. use `<leader>lD` to see all diagnostic.
- `<leader>lr` to rename Symbol. `<leader>lf` to format buffer. `<leader>la` to get code actions.

## Debugging

- for python, install `pyright, debugpy`, `isort and black` are optional. Then use f9 to toggle breakpoint and f5 to start. more bindings see `space+d`. [sample video by Micah Halter](https://www.youtube.com/watch?v=04z9v0xMDkw)

## neovim lua rpel

- use `:lua` to evaluate commands like `:lua print(jit.os)` to see lua runtime values.

## Troubleshooting

- For `query: invalid structure at position 2992 for language lua stack traceback: [C]: in function '_ts_parse_query'`, based on [this github issue reply](https://github.com/LunarVim/LunarVim/issues/3680#issuecomment-1373552082), after running `:echo nvim_get_runtime_file('parser', v:true)`, remove the system `lua.so` under system path( not the one under `nvim-treesitter/parser`).
- For lsp.log in the `state` dir, which grows overtime, on Windows, it is on `~/AppData/Local/nvim-data/`. in linux it is in `~/.local/state/nvim/lsp.log`
- For Mason error `Installation failed for Package(name=stylua) error="Lockfile exists, installation is already running in another process (pid: 80956). Run with :MasonInstall --force to bypass."`, the `force` install may not work, need to clear the corresponding lock files, with `~/.local/share/nvim/mason/staging`(\*nix) or `C:\Users\<YourUsername>\AppData\Local\nvim-data\mason\staging`(Windows)
