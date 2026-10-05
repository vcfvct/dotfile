Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

function Invoke-Native {
    param(
        [Parameter(Mandatory)][string]$File,
        [string[]]$Arguments = @()
    )
    & $File @Arguments | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw "$File failed with exit code $LASTEXITCODE."
    }
}

function Update-ProcessPath {
    $env:PATH = @(
        [Environment]::GetEnvironmentVariable('PATH', 'Machine')
        [Environment]::GetEnvironmentVariable('PATH', 'User')
        $env:PATH
    ) -join ';'
}

function Show-WslStatus {
    if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
        Write-Warning 'WSL is unavailable. Complete WslPlatform before running the Wsl phase.'
        return
    }
    $output = & wsl.exe --list --verbose 2>&1
    $exitCode = $LASTEXITCODE
    $text = ($output | Out-String) -replace "`0", ''
    if ($exitCode -eq 0) {
        Write-Host $text.TrimEnd()
    } elseif ($text -match 'no\s+installed\s+distributions|WSL_E_DEFAULT_DISTRO_NOT_FOUND') {
        Write-Host 'WSL has no installed distributions yet; the Wsl phase will install one.'
    } else {
        Write-Warning "WSL status check failed with exit code ${exitCode}. Complete WslPlatform before running the Wsl phase.`n$text"
    }
}

function Assert-WindowsPackagesPresent {
    param($Settings)
    # Check usable commands rather than WinGet's per-user inventory: image/team
    # provisioned packages may not appear in a user's WinGet install history.
    $commands = @{
        'Git.Git' = 'git.exe'
        'Microsoft.PowerShell' = 'pwsh.exe'
        'Neovim.Neovim' = 'nvim.exe'
        'marlocarlo.psmux' = 'psmux.exe'
        'JanDeDobbeleer.OhMyPosh' = 'oh-my-posh.exe'
        'OpenJS.NodeJS.LTS' = 'node.exe'
        'junegunn.fzf' = 'fzf.exe'
        'BurntSushi.ripgrep.MSVC' = 'rg.exe'
        'sharkdp.fd' = 'fd.exe'
        'zig.zig' = 'zig.exe'
        'dandavison.delta' = 'delta.exe'
        'astral-sh.uv' = 'uv.exe'
        'jqlang.jq' = 'jq.exe'
        'ajeetdsouza.zoxide' = 'zoxide.exe'
    }
    $missing = @()
    foreach ($id in $Settings.windowsPackages) {
        if ($id -eq 'DEVCOM.JetBrainsMonoNerdFont') {
            $fontPaths = @(
                (Join-Path $env:WINDIR 'Fonts')
                (Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts')
            )
            if (-not ($fontPaths | Where-Object {
                (Test-Path -LiteralPath $_ -PathType Container) -and
                    (Get-ChildItem -LiteralPath $_ -Filter 'JetBrainsMono*Nerd*.ttf' -File | Select-Object -First 1)
            })) { $missing += "$id (JetBrains Mono Nerd Font)" }
            continue
        }
        if (-not $commands.ContainsKey($id)) {
            throw "No preprovisioned package check for $id. Add a command/file check before using this package in user customizations."
        }
        if (-not (Get-Command $commands[$id] -ErrorAction SilentlyContinue)) {
            $missing += "$id ($($commands[$id]))"
        }
    }
    if ($missing.Count) {
        throw "Missing preprovisioned Windows packages: $($missing -join ', '). Install them in the Dev Box image or an approved team customization, then rerun the user customization. No WinGet installs were attempted."
    }
}

function Get-WslNames {
    $output = & wsl.exe --list --quiet 2>&1
    $exitCode = $LASTEXITCODE
    $text = ($output | Out-String) -replace "`0", ''
    if ($exitCode -ne 0) {
        if ($text -match 'no\s+installed\s+distributions|WSL_E_DEFAULT_DISTRO_NOT_FOUND') { return }
        throw "Cannot list WSL distributions. Complete WslPlatform first. Exit code ${exitCode}:`n$text"
    }
    @($output | ForEach-Object { ($_ -replace "`0", '').Trim() } | Where-Object { $_ })
}

function Assert-Wsl2 {
    param([string]$Distro)
    $rows = & wsl.exe --list --verbose
    if ($LASTEXITCODE -ne 0) { throw 'Cannot read WSL versions.' }
    $pattern = '^\s*\*?\s*' + [regex]::Escape($Distro) + '\s+.+?\s+2\s*$'
    if (-not ($rows | Where-Object { ($_ -replace "`0", '') -match $pattern })) {
        throw "$Distro is not WSL2. Convert it explicitly with: wsl --set-version $Distro 2"
    }
}

function Write-ManagedFile {
    param([string]$Path, [string]$Content)
    if (Test-Path -LiteralPath $Path) {
        if ([IO.File]::ReadAllText($Path) -eq $Content) { return }
        $backup = "$Path.devbox-backup-$([guid]::NewGuid())"
        Move-Item -LiteralPath $Path -Destination $backup
        Write-Host "Backup: $backup"
    }
    [IO.Directory]::CreateDirectory((Split-Path $Path)) | Out-Null
    [IO.File]::WriteAllText($Path, $Content)
}

function Get-LinuxPath {
    param([string]$Distro, [string]$Path)
    $result = & wsl.exe -d $Distro -u root --exec wslpath -a -u $Path
    if ($LASTEXITCODE -ne 0) { throw "Cannot translate Windows path: $Path" }
    ($result -join "`n").Trim()
}

function Assert-NeovimVersion {
    $output = & nvim.exe --version
    if ($LASTEXITCODE -ne 0 -or $output[0] -notmatch '^NVIM v(\d+\.\d+\.\d+)') {
        throw 'Cannot determine Neovim version.'
    }
    if ([version]$Matches[1] -lt [version]'0.11.0') {
        throw 'This AstroNvim configuration needs Neovim 0.11+. Upgrade the existing package explicitly.'
    }
}
