#Requires -Version 7.2
[CmdletBinding()]
param(
    [ValidateSet('Preflight', 'Windows', 'WslPlatform', 'Wsl', 'Verify', 'All')]
    [string]$Phase = 'Preflight',
    [string]$SettingsPath = (Join-Path $PSScriptRoot 'settings.json'),
    [string]$Distro,
    [string]$LinuxUser,
    [switch]$SkipNeovimSync
)

. "$PSScriptRoot\scripts\common.ps1"
$settings = Get-Content -LiteralPath $SettingsPath -Raw | ConvertFrom-Json
if ($Distro) { $settings.distro = $Distro }
if ($LinuxUser) { $settings.linuxUser = $LinuxUser }
if ($settings.distro -notmatch '^Ubuntu(?:-[0-9]{2}\.[0-9]{2})?$') {
    throw 'Select an Ubuntu distribution name, for example Ubuntu-24.04.'
}
if ($settings.linuxUser -and $settings.linuxUser -notmatch '^[a-z_][a-z0-9_-]{0,31}$') {
    throw 'linuxUser must be a valid Linux account name.'
}
$repo = Split-Path $PSScriptRoot
if ($Phase -eq 'Preflight') {
    Write-Host "Checkout: $repo"
    Write-Host "Target distro: $($settings.distro); no packages or profiles will be changed."
    Get-Command git, pwsh, winget, wsl, node, nvim, psmux -ErrorAction SilentlyContinue |
        Select-Object Name, Source | Format-Table
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    Write-Host "Elevated: $($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))"
    $pendingReboot = (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending') -or
        (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired')
    Write-Host "Windows servicing reboot pending: $pendingReboot"
    Invoke-Native wsl.exe @('--list', '--verbose')
    Invoke-Native git @('-C', $repo, 'status', '--short')
    Write-Host 'Check approved tasks with VS Code: Dev Box: List Available Tasks For This Dev Box.'
    return
}
if ($Phase -eq 'WslPlatform') {
    & "$PSScriptRoot\scripts\wsl-platform.ps1"
    return
}
if ([Security.Principal.WindowsIdentity]::GetCurrent().IsSystem) {
    throw 'Run personal setup under your Windows account, not LocalSystem.'
}
$logDirectory = Join-Path $env:LOCALAPPDATA 'dotfile-devbox\logs'
[IO.Directory]::CreateDirectory($logDirectory) | Out-Null
$log = Join-Path $logDirectory "$((Get-Date).ToString('yyyyMMdd-HHmmss'))-$Phase.log"
Start-Transcript -Path $log | Out-Null
try {
    if ($Phase -in 'Windows', 'All') {
        & "$PSScriptRoot\scripts\windows.ps1" -Settings $settings -Repo $repo -SkipNeovimSync:$SkipNeovimSync
    }
    if ($Phase -in 'Wsl', 'All') {
        & "$PSScriptRoot\scripts\wsl-user.ps1" -Settings $settings -Repo $repo -SkipNeovimSync:$SkipNeovimSync
    }
    if ($Phase -in 'Verify', 'All') {
        & "$PSScriptRoot\scripts\verify.ps1" -Settings $settings -Repo $repo
    }
} finally {
    Stop-Transcript | Out-Null
}
