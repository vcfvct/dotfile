# Powershell setup

## oh-my-posh
* [oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh)  provides similar stuff with oh-my-zsh.
  if `cannot be loaded because the execution of scripts is disabled on this system.` in powershell, we need to set execution policy by `Set-ExecutionPolicy RemoteSigned`
* use `nodepad $PROFILE` to edit options like importing modules and other customizations.
  * if `$PROFILE` does not exist, use `new-item -type file -path $profile -force` to create.
  * do `. $PROFILE` after change to reload the setting.

## PSReadLine
* [PSReadLine](https://devblogs.microsoft.com/powershell/announcing-psreadline-2-1-with-predictive-intellisense/?WT.mc_id=-blog-scottha) provides auto completion.

## Z
* [ZLocation](https://github.com/vors/ZLocation) for smart jump.
