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

function Get-WslNames {
    $output = & wsl.exe --list --quiet
    if ($LASTEXITCODE -ne 0) { throw 'Cannot list WSL distributions. Complete WslPlatform first.' }
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
