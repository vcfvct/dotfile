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

```powershell
git clone --depth 1 https://github.com/AstroNvim/AstroNvim $env:LOCALAPPDATA\nvim
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
* create SymbolicLink: `New-Item -ItemType SymbolicLink -Target "$env:USERPROFILE\source\repos\dotfile\.config\astro" -Path "$env:LOCALAPPDATA\nvim\lua\user"`
* backup: `Copy-Item -Path "$env:LOCALAPPDATA\nvim" -Destination "$env:LOCALAPPDATA\nvim-backup" -Recurse -Force`
* remove existing: `rmdir "$env:LOCALAPPDATA\nvim" -Recurse -Force`. `rmdir` command is another alias for the Remove-Item cmdlet.

### tree-sitter compile
* use zig as c compiler `choco install zig -y`
