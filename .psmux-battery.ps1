#!/usr/bin/env pwsh

# Print one psmux-formatted Windows battery segment. This script intentionally
# does not call psmux: status expansion captures its stdout asynchronously.
$ErrorActionPreference = 'SilentlyContinue'

try {
    $batteries = @(Get-CimInstance -ClassName Win32_Battery -ErrorAction Stop)
} catch {
    Write-Output '#[fg=default]BAT:?#[default]'
    exit 0
}

if ($batteries.Count -eq 0) {
    Write-Output '#[fg=default]AC#[default]'
    exit 0
}

$chargeLevels = @(
    $batteries |
        ForEach-Object { $_.EstimatedChargeRemaining } |
        Where-Object { $null -ne $_ -and $_ -ge 0 -and $_ -le 100 }
)
if ($chargeLevels.Count -eq 0) {
    Write-Output '#[fg=default]BAT:?#[default]'
    exit 0
}

$averageCharge = ($chargeLevels | Measure-Object -Average).Average
if ($null -eq $averageCharge) {
    Write-Output '#[fg=default]BAT:?#[default]'
    exit 0
}

$percentage = [math]::Round([double]$averageCharge)
$statuses = @($batteries | ForEach-Object { [int]$_.BatteryStatus })

# Win32_Battery frequently reports 2 while connected to AC, even during active
# charging. The root/wmi BatteryStatus class exposes the live power-line and
# charging flags, so prefer it and retain the Win32 values as a fallback.
try {
    $powerStates = @(Get-CimInstance -Namespace root/wmi -ClassName BatteryStatus -ErrorAction Stop)
} catch {
    $powerStates = @()
}

if ($powerStates | Where-Object { $_.Charging }) {
    $statusIcon = '+'
} elseif ($powerStates | Where-Object { $_.PowerOnline }) {
    $statusIcon = '='
} elseif ($statuses -contains 2 -or
    ($statuses | Where-Object { $_ -ge 6 -and $_ -le 9 })) {
    $statusIcon = '+'
} elseif ($statuses -contains 3) {
    $statusIcon = '='
} else {
    $statusIcon = '-'
}

$color = if ($percentage -gt 50) {
    'green'
} elseif ($percentage -gt 20) {
    'yellow'
} else {
    'red'
}

Write-Output "#[fg=$color]$statusIcon $percentage%#[default]"
