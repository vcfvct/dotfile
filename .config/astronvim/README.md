# astro.vim

* have to install `gcc/g++` for tree-sitter to compile.
* remapped `f12` to toggle float terminal.
* use `MasonInstall xxx-lsp` to install language servers.
* neo-tree toggle hidden files -> `H`.
* comment code: `<leader>/` to for current line, otherwise use g -> options.
* for language specific 'failed to load,..., query: invalid structure at position', need to `:TSInstall ThisLanguage`.

## Windows
* create SymbolicLink: `New-Item -ItemType SymbolicLink -Target "$env:USERPROFILE\source\repos\dotfile\.config\astronvim" -Path "$env:LOCALAPPDATA\nvim"`
* backup: `Copy-Item -Path "$env:LOCALAPPDATA\nvim" -Destination "$env:LOCALAPPDATA\nvim-backup" -Recurse -Force`
* remove existing: `rmdir "$env:LOCALAPPDATA\nvim" -Recurse -Force`. `rmdir` command is another alias for the Remove-Item cmdlet.
