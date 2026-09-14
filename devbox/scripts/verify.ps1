param($Settings, [string]$Repo)
. "$PSScriptRoot\common.ps1"
Update-ProcessPath
Assert-NeovimVersion
foreach ($command in 'git', 'pwsh', 'nvim', 'psmux', 'fnm', 'fzf', 'rg', 'fd', 'zig', 'delta', 'oh-my-posh', 'uv', 'jq') {
    Get-Command $command -ErrorAction Stop | Select-Object Name, Source | Format-Table
}
foreach ($module in $Settings.powershellModules) {
    if (-not (Get-Module -ListAvailable $module)) { throw "Missing PowerShell module: $module" }
}
$nvim = Get-Item -LiteralPath (Join-Path $env:LOCALAPPDATA 'nvim')
if (-not $nvim.LinkTarget -or [IO.Path]::GetFullPath($nvim.LinkTarget) -ne (Join-Path $Repo '.config\nvim')) {
    throw 'Windows Neovim does not point at this checkout.'
}
foreach ($file in '.psmux.conf', '.psmux-battery.ps1', '.tmux.common.conf') {
    if ((Get-FileHash (Join-Path $Repo $file)).Hash -ne
        (Get-FileHash (Join-Path $env:USERPROFILE $file)).Hash) { throw "Configuration mismatch: $file" }
}
if (-not (Test-Path $PROFILE.CurrentUserCurrentHost)) { throw 'PowerShell profile loader is missing.' }
$fnmEnvironment = & fnm.exe env --shell powershell
if ($LASTEXITCODE -ne 0) { throw 'Cannot initialize Node for verification.' }
$fnmEnvironment | Out-String | Invoke-Expression
Invoke-Native fnm.exe @('use', $Settings.nodeVersion)
Push-Location $Repo
$previousHome = $env:HOME
try {
    $env:HOME = $env:USERPROFILE
    Invoke-Native node.exe @('.\symbolLink.js', '--devbox', '--verify')
} finally {
    $env:HOME = $previousHome
    Pop-Location
}
Invoke-Native psmux.exe @('-V')
Invoke-Native nvim.exe @('--version')
Assert-Wsl2 $Settings.distro
$user = $Settings.linuxUser
if (-not $user) {
    $user = (& wsl.exe -d $Settings.distro --exec id -un | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) { throw 'Cannot read the Linux default user.' }
    if ($user -eq 'root') { $user = 'developer' }
}
$script = Get-LinuxPath $Settings.distro (Join-Path $PSScriptRoot 'ubuntu-verify.sh')
$linuxHome = (& wsl.exe -d $Settings.distro -u $user --exec printenv HOME | Out-String).Trim()
if ($LASTEXITCODE -ne 0) { throw 'Cannot read the Linux home directory.' }
Invoke-Native wsl.exe @('-d', $Settings.distro, '-u', $user, '--exec', 'bash', $script, "$linuxHome/source/repos/dotfile")
$account = & wsl.exe -d $Settings.distro -u $user --exec getent passwd $user
if ($LASTEXITCODE -ne 0 -or ($account -join '').Trim().Split(':')[-1] -ne '/home/linuxbrew/.linuxbrew/bin/fish') {
    throw 'The Linux account does not use Linuxbrew fish as its default shell.'
}
