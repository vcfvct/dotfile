#Requires -Version 7.2
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot
$repo = Split-Path $root
$failures = @()
$files = @(Get-ChildItem $root -Filter '*.ps1' -Recurse) +
    @(Get-Item (Join-Path $repo 'wsl\powershell_profile.ps1'))
foreach ($file in $files) {
    $tokens = $null
    $errors = $null
    [Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$errors) | Out-Null
    $failures += @($errors)
}
if ($failures.Count) { throw ($failures | Out-String) }
. "$root\scripts\common.ps1"
$settings = Get-Content "$root\settings.json" -Raw | ConvertFrom-Json
if ($settings.homebrewInstallerRevision -notmatch '^[a-f0-9]{40}$') { throw 'Installer revision is not pinned.' }
if ($settings.windowsPackages.Count -ne @($settings.windowsPackages | Select-Object -Unique).Count) {
    throw 'Duplicate Windows package IDs.'
}
Invoke-Native node @('--check', (Join-Path $repo 'symbolLink.js'))
$bash = Join-Path $env:ProgramFiles 'Git\usr\bin\bash.exe'
if (-not (Test-Path $bash)) { throw 'Git for Windows bash is required for non-WSL shell syntax validation.' }
foreach ($file in Get-ChildItem "$root\scripts" -Filter '*.sh') {
    Invoke-Native $bash @('-n', $file.FullName)
    if ([IO.File]::ReadAllText($file.FullName).Contains("`r")) { throw "CRLF in Linux script: $file" }
}
$temporary = Join-Path ([IO.Path]::GetTempPath()) "dotfile-devbox-ps-test-$([guid]::NewGuid())"
[IO.Directory]::CreateDirectory($temporary) | Out-Null
try {
    $path = Join-Path $temporary 'profile.ps1'
    [IO.File]::WriteAllText($path, 'original')
    Write-ManagedFile $path 'managed'
    $backup = @(Get-ChildItem $temporary -Filter '*.devbox-backup-*')
    if ($backup.Count -ne 1 -or [IO.File]::ReadAllText($backup[0].FullName) -ne 'original') {
        throw 'Managed file backup failed.'
    }
    Write-ManagedFile $path 'managed'
    if (@(Get-ChildItem $temporary).Count -ne 2) { throw 'Managed file rerun is not a no-op.' }
    $caught = $false
    try { Invoke-Native pwsh @('-NoProfile', '-Command', 'exit 7') } catch {
        if ($_.Exception.Message -notmatch 'exit code 7') { throw }
        $caught = $true
    }
    if (-not $caught) { throw 'Native failure was not propagated.' }
    function wsl.exe {
        $global:LASTEXITCODE = 0
        if ($args -contains '--verbose') {
            '* Ubuntu-24.04       Stopped 2'
            '  Ubuntu-22.04       Stopped 1'
        } else {
            "Ubuntu-24.04`0"
            "Ubuntu-22.04`0"
        }
    }
    if (@(Get-WslNames).Count -ne 2) { throw 'WSL name parsing failed.' }
    Assert-Wsl2 Ubuntu-24.04
    $caught = $false
    try { Assert-Wsl2 Ubuntu-22.04 } catch { $caught = $true }
    if (-not $caught) { throw 'WSL1 was accepted.' }
    $caught = $false
    try { Assert-Wsl2 Ubuntu } catch { $caught = $true }
    if (-not $caught) { throw 'Partial distro name was accepted.' }
} finally {
    Remove-Item Function:\wsl.exe -ErrorAction SilentlyContinue
    # Delete only files created by this test, then its empty directory.
    Get-ChildItem -LiteralPath $temporary -File | Remove-Item -Force
    Remove-Item -LiteralPath $temporary
}
Write-Host 'PowerShell/Bash syntax, settings, backup/resume, native errors, and WSL parsing passed.'
