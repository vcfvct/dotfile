. "$PSScriptRoot\common.ps1"
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal]::new($identity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Run only WslPlatform in an elevated PowerShell, or request an approved team provisioning task.'
}
# The PowerShell Dism cmdlets can fail with "Class not registered" on Windows ARM64.
# Use the inbox DISM executable instead, without relying on its PowerShell provider.
$restart = $false
foreach ($name in 'VirtualMachinePlatform', 'Microsoft-Windows-Subsystem-Linux') {
    $info = & dism.exe /Online /Get-FeatureInfo "/FeatureName:$name" /English 2>&1
    $code = $LASTEXITCODE
    $text = $info | Out-String
    if ($code -ne 0) { throw "Cannot query Windows feature $name (DISM exit ${code}):`n$text" }
    if ($text -match '(?m)^\s*State\s*:\s*Enabled\s*$') { continue }
    if ($text -match '(?m)^\s*State\s*:\s*Enable Pending\s*$') {
        throw "Windows feature $name is pending a reboot. Reboot manually and rerun WslPlatform."
    }
    if ($text -notmatch '(?m)^\s*State\s*:\s*Disabled\s*$') {
        throw "Unrecognized Windows feature state for ${name}:`n$text"
    }
    $result = & dism.exe /Online /Enable-Feature "/FeatureName:$name" /All /NoRestart /English 2>&1
    $code = $LASTEXITCODE
    if ($code -notin 0, 3010) { throw "Cannot enable Windows feature $name (DISM exit ${code}):`n$($result | Out-String)" }
    $restart = $true
}
if ($restart) {
    throw 'WSL features enabled; REBOOT REQUIRED. Save work, reboot manually, rerun WslPlatform, then run Wsl under your normal account.'
}

$wslOutput = & wsl.exe --list --verbose 2>&1
$wslExitCode = $LASTEXITCODE
$wslText = ($wslOutput | Out-String) -replace "`0", ''
if ($wslExitCode -eq 0) {
    Write-Host $wslText.TrimEnd()
} elseif ($wslText -match 'no\s+installed\s+distributions') {
    Write-Host 'WSL has no installed distributions yet; the Wsl phase will install one.'
} else {
    throw "wsl.exe --list --verbose failed with exit code ${wslExitCode}:`n$wslText"
}
Write-Host 'WSL platform command completed. If Windows reports a pending reboot, reboot before running the Wsl phase.'
