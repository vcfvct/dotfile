param($Settings, [string]$Repo, [switch]$SkipNeovimSync)
. "$PSScriptRoot\common.ps1"
$distro = $Settings.distro
$newDistro = $distro -notin @(Get-WslNames)
if ($newDistro) {
    Invoke-Native wsl.exe @('--install', '-d', $distro, '--no-launch', '--web-download')
}
Assert-Wsl2 $distro
$user = $Settings.linuxUser
if (-not $user -and $newDistro) { $user = 'developer' }
if (-not $user) {
    $output = & wsl.exe -d $distro --exec id -un
    if ($LASTEXITCODE -ne 0) { throw 'Cannot resolve the Linux user. Finish Ubuntu initialization and rerun.' }
    $user = ($output -join '').Trim()
    if ($user -eq 'root') { $user = 'developer' }
}
if ($user -notmatch '^[a-z_][a-z0-9_-]{0,31}$' -or $user -eq 'root') {
    throw "Refusing invalid or root Linux user: $user"
}
$linuxScripts = Get-LinuxPath $distro (Join-Path $Repo 'devbox\scripts')
$revision = (& git -C $Repo rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0 -or $revision -notmatch '^[a-f0-9]{40}$') { throw 'Cannot determine the dotfiles revision.' }
Invoke-Native wsl.exe @(
    '-d', $distro, '-u', 'root', '--exec', 'bash',
    "$linuxScripts/ubuntu-root.sh", 'prepare', $user
)
# Bootstrap from the local checkout; Linux dotfiles are independently cloned at the committed revision.
Invoke-Native wsl.exe @(
    '-d', $distro, '-u', $user, '--exec', 'bash',
    "$linuxScripts/ubuntu-bootstrap.sh", $Settings.repository, $revision,
    $Settings.homebrewInstallerRevision, $(if ($SkipNeovimSync) { 'skip' } else { 'sync' })
)
Invoke-Native wsl.exe @(
    '-d', $distro, '-u', 'root', '--exec', 'bash',
    "$linuxScripts/ubuntu-root.sh", 'finish', $user
)
Write-Host "Configured $distro for $user. Close its shells and run 'wsl --terminate $distro' when safe to activate the default user."
Write-Host "For a newly created account, set its password interactively: wsl -d $distro -u root -- passwd $user"
