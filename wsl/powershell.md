# Powershell setup

## oh-my-posh
* [oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh)  provides similar stuff with oh-my-zsh.
  if `cannot be loaded because the execution of scripts is disabled on this system.` in powershell, we need to set execution policy by `Set-ExecutionPolicy RemoteSigned`
* use `notepad $PROFILE`  or `nvim $PROFILE` to edit options like importing modules and other customizations. Typially the location is `C:\Users\YourUserName\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`
  * if `$PROFILE` does not exist, use `new-item -type file -path $profile -force` to create.
  * do `. $PROFILE` after change to reload the setting.
  * example config:
  ```
  oh-my-posh init pwsh --config ~/.jandedobbeleer.omp.json | Invoke-Expression
  Set-PSReadLineOption -PredictionSource History
  Set-PSReadlineOption -EditMode vi
  Import-Module ZLocation
  ```

## PSReadLine
* [PSReadLine](https://devblogs.microsoft.com/powershell/announcing-psreadline-2-1-with-predictive-intellisense/?WT.mc_id=-blog-scottha) provides auto completion.

## Z
* [ZLocation](https://github.com/vors/ZLocation) for smart jump.

## neovim
* install [chocolatey](https://community.chocolatey.org/courses/installation/installing?method=install-from-powershell-v3). (admin)
* install [neovim](https://community.chocolatey.org/packages/neovim)
  * the `:echo stdpath(‘config’)` shows config path which is typially `~/AppData/Local/nvim`. if not exist, create this directory. create the `init.vim` config file here.
  * the `coc.vim` config can also be placed here and referenced in the `init.vim` by: `source ~/AppData/Local/nvim/coc.vim `
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
    ))
  ```
