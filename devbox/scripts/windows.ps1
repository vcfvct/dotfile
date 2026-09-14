param($Settings, [string]$Repo, [switch]$SkipNeovimSync)
. "$PSScriptRoot\common.ps1"

if (-not (Get-Command winget.exe -ErrorAction SilentlyContinue)) {
    throw 'WinGet is required. Ask your administrator to provision App Installer.'
}
foreach ($id in $Settings.windowsPackages) {
    # Do not upgrade existing packages on every resume.
    & winget.exe list --id $id --exact --source winget --accept-source-agreements --disable-interactivity | Out-Host
    $code = $LASTEXITCODE
    if ($code -eq 0) { continue }
    if ($code -ne -1978335212) { throw "WinGet detection failed for $id (exit $code)." }
    Invoke-Native winget.exe @(
        'install', '--id', $id, '--exact', '--source', 'winget',
        '--silent', '--accept-package-agreements', '--accept-source-agreements',
        '--disable-interactivity'
    )
}
Update-ProcessPath
Assert-NeovimVersion
Invoke-Native fnm.exe @('install', $Settings.nodeVersion)
Invoke-Native fnm.exe @('default', $Settings.nodeVersion)
$fnmEnvironment = & fnm.exe env --shell powershell
if ($LASTEXITCODE -ne 0) { throw 'Cannot initialize fnm.' }
$fnmEnvironment | Out-String | Invoke-Expression
Invoke-Native fnm.exe @('use', $Settings.nodeVersion)

foreach ($module in $Settings.powershellModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Install-Module -Name $module -Scope CurrentUser -Repository PSGallery -Force -AllowClobber -ErrorAction Stop
    }
}
Push-Location $Repo
$previousHome = $env:HOME
try {
    $env:HOME = $env:USERPROFILE
    Invoke-Native node.exe @('.\symbolLink.js', '--devbox')
} finally {
    $env:HOME = $previousHome
    Pop-Location
}
$profileSource = (Join-Path $Repo 'wsl\powershell_profile.ps1').Replace("'", "''")
$loader = @"
# Managed by dotfile/devbox. Existing profiles are backed up next to this file.
`$dotfileProfile = '$profileSource'
if (-not (Test-Path -LiteralPath `$dotfileProfile)) {
    throw "Dotfiles profile missing: `$dotfileProfile"
}
. `$dotfileProfile
"@
Write-ManagedFile -Path $PROFILE.CurrentUserCurrentHost -Content $loader

$policy = Get-ExecutionPolicy
if ($policy -in 'Restricted', 'AllSigned') {
    throw "Profile configured, but execution policy is $policy. Ask your admin about approved script signing/policy; it was not changed."
}
if (-not $SkipNeovimSync) {
    Invoke-Native nvim.exe @('--headless', '+Lazy! sync', '+qa')
}
Write-Host 'Select JetBrainsMono Nerd Font in your terminal. Restart PowerShell to load the profile.'
