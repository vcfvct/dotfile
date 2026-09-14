. "$PSScriptRoot\common.ps1"
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal]::new($identity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Run only WslPlatform in an elevated PowerShell, or request an approved team provisioning task.'
}
$restart = $false
foreach ($name in 'VirtualMachinePlatform', 'Microsoft-Windows-Subsystem-Linux') {
    $feature = Get-WindowsOptionalFeature -Online -FeatureName $name
    if ($feature.State -ne 'Enabled') {
        $result = Enable-WindowsOptionalFeature -Online -FeatureName $name -All -NoRestart
        $restart = $restart -or $result.RestartNeeded
    }
}
if ($restart) {
    throw 'WSL features enabled; REBOOT REQUIRED. Save work, reboot manually, rerun WslPlatform, then run Wsl under your normal account.'
}
Invoke-Native wsl.exe @('--install', '--no-distribution', '--web-download')
Write-Host 'WSL platform command completed. If Windows reports a pending reboot, reboot before running the Wsl phase.'
