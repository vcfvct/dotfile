# for Windows server with choco install, manually add path.
# $env:Path += ";C:\Tools\neovim\nvim-win64\bin\;C:\ProgramData\chocolatey\bin\;C:\Program Files\GIT\bin;C:\Program Files\nodejs"

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\powerlevel10k_rainbow.omp.json" | Invoke-Expression

Set-PSReadLineOption -PredictionSource History

# pwsh vi mode
Set-PSReadlineOption -EditMode vi
function OnViModeChange {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "`e[1 q"
    } else {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "`e[5 q"
    }
}
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

# set nvim as default editor for visual mode.
Set-Item Env:EDITOR nvim

# use `ctrl+[` to exit from Edit mode to Command mode
Set-PSReadLineKeyHandler -Chord 'Ctrl+Oem4' -Function ViCommandMode

Import-Module ZLocation
Import-Module -Name Terminal-Icons
Import-Module PSFzf
# Override PSReadLine's history search
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+p' `
	-PSReadlineChordReverseHistory 'Ctrl+r'
# Override default tab completion
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
# open file with neovim/notepad
Function ov { Get-ChildItem . -Recurse -Attributes !Directory | Invoke-Fzf | % { nvim $_ } }
Function on { Get-ChildItem . -Recurse -Attributes !Directory | Invoke-Fzf | % { notepad $_ } }

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
	Import-Module "$ChocolateyProfile"
}

Set-Alias -Name open -Value ii
Set-Alias -Name which -Value get-command
Set-Alias -Name vi -Value nvim
Set-Alias -Name touch -Value new-item
Set-Alias -Name grep -Value findstr

# `ll` with eza in wsl in available
Function ll {
	$target = ''
	if ($args[0]) {
		$target = $args[0] -replace "`\\", "`/"
	}
	wsl eza -al --group --icons --sort=modified $target
}
Function ev { nvim $env:LOCALAPPDATA\nvim\init.vim }
Function gs { git status }
Function gd { git diff }
# remove PowerShell default alias
Remove-Item -Path alias:gl -Force
function gl { git pull }
Remove-Item -Path alias:gp -Force
function gp { git push }

# ctrl+f to accept suggestion
Set-PSReadLineKeyHandler -Chord "Ctrl+f" -ScriptBlock {
	[Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion()
	[Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
# ctrl+e to move forward word
Set-PSReadLineKeyHandler -chord 'Ctrl+e' -Function ForwardWord
