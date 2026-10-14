[CmdletBinding()]
param(
    [string]$SettingsPath,
    [string]$SchemesPath = (Join-Path $PSScriptRoot 'schemes.json')
)

$ErrorActionPreference = 'Stop'

if (-not $SettingsPath) {
    $settingsCandidates = @(
        (Join-Path $env:LOCALAPPDATA 'Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json'),
        (Join-Path $env:LOCALAPPDATA 'Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json'),
        (Join-Path $env:LOCALAPPDATA 'Packages/Microsoft.WindowsTerminalCanary_8wekyb3d8bbwe/LocalState/settings.json'),
        (Join-Path $env:LOCALAPPDATA 'Microsoft/Windows Terminal/settings.json')
    )
    $SettingsPath = $settingsCandidates | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } | Select-Object -First 1
    if (-not $SettingsPath) {
        throw 'Could not find Windows Terminal settings.json. Pass its path with -SettingsPath.'
    }
}

if (-not (Test-Path -LiteralPath $SettingsPath -PathType Leaf)) {
    throw "Settings file not found: $SettingsPath"
}
if (-not (Test-Path -LiteralPath $SchemesPath -PathType Leaf)) {
    throw "Schemes file not found: $SchemesPath"
}

function ConvertFrom-JsoncText {
    param([Parameter(Mandatory)][string]$Text)

    $output = [System.Text.StringBuilder]::new()
    $inString = $false
    $escaped = $false
    $index = 0

    while ($index -lt $Text.Length) {
        $character = $Text[$index]
        $next = if ($index + 1 -lt $Text.Length) { $Text[$index + 1] } else { [char]0 }

        if ($inString) {
            [void]$output.Append($character)
            if ($escaped) {
                $escaped = $false
            } elseif ($character -eq '\') {
                $escaped = $true
            } elseif ($character -eq '"') {
                $inString = $false
            }
            $index++
            continue
        }

        if ($character -eq '"') {
            $inString = $true
            [void]$output.Append($character)
            $index++
            continue
        }

        if ($character -eq '/' -and $next -eq '/') {
            $index += 2
            while ($index -lt $Text.Length -and $Text[$index] -ne "`n" -and $Text[$index] -ne "`r") {
                $index++
            }
            continue
        }

        if ($character -eq '/' -and $next -eq '*') {
            $index += 2
            while ($index + 1 -lt $Text.Length -and -not ($Text[$index] -eq '*' -and $Text[$index + 1] -eq '/')) {
                if ($Text[$index] -eq "`n" -or $Text[$index] -eq "`r") {
                    [void]$output.Append($Text[$index])
                }
                $index++
            }
            $index += 2
            continue
        }

        if ($character -eq ',') {
            $lookahead = $index + 1
            while ($lookahead -lt $Text.Length) {
                if ([char]::IsWhiteSpace($Text[$lookahead])) {
                    $lookahead++
                    continue
                }
                if ($lookahead + 1 -lt $Text.Length -and $Text[$lookahead] -eq '/' -and $Text[$lookahead + 1] -eq '/') {
                    $lookahead += 2
                    while ($lookahead -lt $Text.Length -and $Text[$lookahead] -ne "`n" -and $Text[$lookahead] -ne "`r") { $lookahead++ }
                    continue
                }
                if ($lookahead + 1 -lt $Text.Length -and $Text[$lookahead] -eq '/' -and $Text[$lookahead + 1] -eq '*') {
                    $lookahead += 2
                    while ($lookahead + 1 -lt $Text.Length -and -not ($Text[$lookahead] -eq '*' -and $Text[$lookahead + 1] -eq '/')) { $lookahead++ }
                    $lookahead += 2
                    continue
                }
                break
            }
            if ($lookahead -lt $Text.Length -and ($Text[$lookahead] -eq ']' -or $Text[$lookahead] -eq '}')) {
                $index++
                continue
            }
        }

        [void]$output.Append($character)
        $index++
    }

    return $output.ToString()
}

function Test-JsonCodePosition {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][int]$Position
    )

    $inString = $false
    $escaped = $false
    $lineComment = $false
    $blockComment = $false
    for ($index = 0; $index -lt $Position; $index++) {
        $character = $Text[$index]
        $next = if ($index + 1 -lt $Position) { $Text[$index + 1] } else { [char]0 }
        if ($lineComment) {
            if ($character -eq "`n" -or $character -eq "`r") { $lineComment = $false }
            continue
        }
        if ($blockComment) {
            if ($character -eq '*' -and $next -eq '/') { $blockComment = $false; $index++ }
            continue
        }
        if ($inString) {
            if ($escaped) { $escaped = $false }
            elseif ($character -eq '\') { $escaped = $true }
            elseif ($character -eq '"') { $inString = $false }
            continue
        }
        if ($character -eq '/' -and $next -eq '/') { $lineComment = $true; $index++; continue }
        if ($character -eq '/' -and $next -eq '*') { $blockComment = $true; $index++; continue }
        if ($character -eq '"') { $inString = $true }
    }
    return -not $inString -and -not $lineComment -and -not $blockComment
}

function Find-JsonArrayEnd {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][int]$OpenIndex
    )

    $depth = 0
    $inString = $false
    $escaped = $false
    $lineComment = $false
    $blockComment = $false
    for ($index = $OpenIndex; $index -lt $Text.Length; $index++) {
        $character = $Text[$index]
        $next = if ($index + 1 -lt $Text.Length) { $Text[$index + 1] } else { [char]0 }
        if ($lineComment) {
            if ($character -eq "`n" -or $character -eq "`r") { $lineComment = $false }
            continue
        }
        if ($blockComment) {
            if ($character -eq '*' -and $next -eq '/') { $blockComment = $false; $index++ }
            continue
        }
        if ($inString) {
            if ($escaped) { $escaped = $false }
            elseif ($character -eq '\') { $escaped = $true }
            elseif ($character -eq '"') { $inString = $false }
            continue
        }
        if ($character -eq '/' -and $next -eq '/') { $lineComment = $true; $index++; continue }
        if ($character -eq '/' -and $next -eq '*') { $blockComment = $true; $index++; continue }
        if ($character -eq '"') { $inString = $true; continue }
        if ($character -eq '[') { $depth++ }
        elseif ($character -eq ']') {
            $depth--
            if ($depth -eq 0) { return $index }
        }
    }
    throw 'Could not find the closing bracket for the schemes array.'
}

$themes = @(Get-Content -LiteralPath $SchemesPath -Raw | ConvertFrom-Json)
if ($themes.Count -eq 0) { throw "No schemes found in $SchemesPath" }

$settings = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $SettingsPath))
$propertyPattern = [regex]::new('"schemes"\s*:\s*\[', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
$schemeMatch = $null
foreach ($match in $propertyPattern.Matches($settings)) {
    if (Test-JsonCodePosition -Text $settings -Position $match.Index) {
        $schemeMatch = $match
        break
    }
}
if (-not $schemeMatch) {
    throw 'No "schemes" array was found in settings.json. Add "schemes": [] and run this script again.'
}

$openIndex = $schemeMatch.Index + $schemeMatch.Length - 1
$closeIndex = Find-JsonArrayEnd -Text $settings -OpenIndex $openIndex
$arrayText = $settings.Substring($openIndex, $closeIndex - $openIndex + 1)
$existingJson = ConvertFrom-JsoncText -Text $arrayText
$existingSchemes = @(ConvertFrom-Json -InputObject $existingJson)

$merged = [System.Collections.Generic.List[object]]::new()
$names = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
foreach ($scheme in $existingSchemes) {
    $merged.Add($scheme)
    if ($scheme.name) { [void]$names.Add([string]$scheme.name) }
}
$added = [System.Collections.Generic.List[string]]::new()
foreach ($theme in $themes) {
    if ($names.Add([string]$theme.name)) {
        $merged.Add($theme)
        $added.Add([string]$theme.name)
    }
}

if ($added.Count -eq 0) {
    Write-Host 'All schemes from the repository are already present; no changes made.'
    exit 0
}

$mergedArray = $merged.ToArray()
$newArray = ConvertTo-Json -InputObject $mergedArray -Depth 20
$newline = if ($settings.Contains("`r`n")) { "`r`n" } else { "`n" }
$newArray = $newArray -replace "`r?`n", $newline
$updated = $settings.Substring(0, $openIndex) + $newArray + $settings.Substring($closeIndex + 1)

$resolvedSettingsPath = (Resolve-Path -LiteralPath $SettingsPath).Path
$backupPath = "$resolvedSettingsPath.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
[System.IO.File]::Copy($resolvedSettingsPath, $backupPath)
[System.IO.File]::WriteAllText($resolvedSettingsPath, $updated, [System.Text.UTF8Encoding]::new($false))

Write-Host "Added: $($added -join ', ')"
Write-Host "Backup: $backupPath"
Write-Host "Updated: $resolvedSettingsPath"
