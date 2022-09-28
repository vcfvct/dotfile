# Powershell setup

## oh-my-posh
* [oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh)  provides similar stuff with oh-my-zsh.
  if `cannot be loaded because the execution of scripts is disabled on this system.` in powershell, we need to set execution policy by `Set-ExecutionPolicy RemoteSigned`
* use `notepad $PROFILE`  or `nvim $PROFILE` to edit options like importing modules and other customizations. Typially the location is `C:\Users\YourUserName\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`
  * if `$PROFILE` does not exist, use `new-item -type file -path $profile -force` to create.
  * do `. $PROFILE` after change to reload the setting.
  * example config:

  ```powershell
  oh-my-posh init pwsh --config ~/.jandedobbeleer.omp.json | Invoke-Expression
  Set-PSReadLineOption -PredictionSource History
  Set-PSReadlineOption -EditMode vi
  # use `ctrl+[` to exit from Edit mode to Command mode
  Set-PSReadLineKeyHandler -Chord 'Ctrl+Oem4' -Function ViCommandMode
  Import-Module ZLocation
  Import-Module -Name Terminal-Icons

  # FZF
  Import-Module PSFzf
  # Override PSReadLine's history search
  Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' `
                  -PSReadlineChordReverseHistory 'Ctrl+r'
  # Override default tab completion
  Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
  # open file with neovim
  Function ov { Get-ChildItem . -Recurse -Attributes !Directory | Invoke-Fzf | % { nvim $_ } }

  Set-Alias -Name vi -Value nvim
  Set-Alias -Name open -Value ii 
  Set-Alias -Name which -Value get-command
  Set-Alias -Name touch -Value new-item
  Function ll { 
    $target = ''
    if($args[0]){
      $target = $args[0] -replace "`\\","`/"
    }
    wsl exa -l --group --icons --sort=modified $target 
  }
  Function ev { nvim $env:LOCALAPPDATA\nvim\init.vim }
  Function gs { git status }
  Function gd { git diff }
  Function gl { git pull }
  Function gp { git push }

  # auto completion key bindings
  Set-PSReadLineOption -HistorySearchCursorMovesToEnd
  Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
  Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
  Set-PSReadLineKeyHandler -chord 'Ctrl+e' -Function ForwardWord
  Set-PSReadLineKeyHandler -Chord "Ctrl+f" -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion()
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
  }
  ```

## PSReadLine
* [PSReadLine](https://devblogs.microsoft.com/powershell/announcing-psreadline-2-1-with-predictive-intellisense/?WT.mc_id=-blog-scottha) provides auto completion.

## Z
* [ZLocation](https://github.com/vors/ZLocation) for smart jump.

## Terminal Icon
* install module: `Install-Module -Name Terminal-Icons -Repository PSGallery`
* add to $PROFILE: `Import-Module -Name Terminal-Icons`

## Fzf integration using PSfzf
* installation: 1. `choco install fzf`, 2. `Install-Module PSFzf`.
* config as above example config. [source](https://www.damirscorner.com/blog/posts/20211119-PowerShellModulesForABetterCommandLine.html)

## neovim
* install [chocolatey](https://community.chocolatey.org/courses/installation/installing?method=install-from-powershell-v3). (admin)
* install [neovim](https://community.chocolatey.org/packages/neovim)
  * the `:echo stdpath(‘config’)` shows config path which is typially `~/AppData/Local/nvim/`. if not exist, create this directory. 
    * create the `init.vim` config file here if not exist. put vim config stuff in.
    * the `coc.vim` config can also be placed here and referenced in the `init.vim` by: `source ~/AppData/Local/nvim/coc.vim `
    * the `coc-settings.json` can also be placed here so that coc would load it by default/convention.
* install fzf: `choco install fzf`.
* install [vim-plug](https://dev.to/ritikadas/using-neovim-as-an-effortless-way-to-edit-code-installation-and-setup-guide-for-windows-10-5dhc).
  ```
    md ~\AppData\Local\nvim\autoload

    $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    (New-Object Net.WebClient).DownloadFile(
      $uri,
      $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
        "~\AppData\Local\nvim\autoload\plug.vim"
      )
    )
  ```
* for `floatterm` to use latest powershell: `let g:floaterm_shell="pwsh.exe -NoLogo"`

## commands
* `ii .` -> `open .` 
* `gdr` -> `df -h`
* `get-command` -> `which`

## environment variable
* env var is typically defined with `$env:`, like `$env:LOCALAPPDATA` points to `$HOME\AppData\Local\`.
* to define a tmp env var before executing the command, similar to linux, do `$env:FOO='Bar'; python .\myPythonScript`
* to show all env vars, use Get-ChildItem, `gci env:`, or `ls env:`, or `dir env:`
