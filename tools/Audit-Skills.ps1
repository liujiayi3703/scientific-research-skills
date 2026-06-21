$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Root = Split-Path -Parent $ScriptDir
$SkillsDir = Join-Path $Root "library\skills"
$DocsDir = Join-Path $Root "docs"
$IndexPath = Join-Path $DocsDir "SKILL_INDEX.md"

if (-not (Test-Path $SkillsDir)) {
    throw "Cannot find skills directory: $SkillsDir"
}

New-Item -ItemType Directory -Force -Path $DocsDir | Out-Null

$skillDirs = Get-ChildItem -LiteralPath $SkillsDir -Directory | Sort-Object Name
function Get-SkillDescription {
    param([string]$SkillPath)

        $lines = Get-Content -LiteralPath $SkillPath -Encoding UTF8 -TotalCount 80
    $descriptionParts = New-Object System.Collections.Generic.List[string]
    $captureFolded = $false

    foreach ($line in $lines) {
        if ($captureFolded) {
            if ($line -match "^[A-Za-z0-9_-]+:\s*") {
                break
            }
            $trimmed = $line.Trim()
            if ($trimmed) {
                $descriptionParts.Add($trimmed)
            }
            continue
        }

        if ($line -match "^description:\s*(.*)$") {
            $value = $Matches[1].Trim()
            if ([string]::IsNullOrWhiteSpace($value) -or $value -eq ">" -or $value -eq "|") {
                $captureFolded = $true
            } else {
                $descriptionParts.Add($value.Trim('"'))
                break
            }
        }
    }

    return (($descriptionParts -join " ") -replace "\s+", " ").Trim()
}

$rows = foreach ($dir in $skillDirs) {
    $skillPath = Join-Path $dir.FullName "SKILL.md"
    $hasSkill = Test-Path $skillPath
    $description = ""

    if ($hasSkill) {
        $description = Get-SkillDescription -SkillPath $skillPath
    }

    [PSCustomObject]@{
        Name = $dir.Name
        HasSkill = $hasSkill
        Description = $description
    }
}

$standard = @($rows | Where-Object HasSkill)
$nonstandard = @($rows | Where-Object { -not $_.HasSkill })

$content = New-Object System.Collections.Generic.List[string]
$content.Add("# Skill Index")
$content.Add("")
$content.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
$content.Add("")
$content.Add("Standard skills: $($standard.Count)")
$content.Add("Non-standard folders in library/skills: $($nonstandard.Count)")
$content.Add("")
$content.Add("## Standard Skills")
$content.Add("")
$content.Add("| Skill | Description |")
$content.Add("| --- | --- |")
foreach ($row in $standard) {
    $desc = $row.Description -replace "\|", "\|"
    $content.Add("| $($row.Name) | $desc |")
}

if ($nonstandard.Count -gt 0) {
    $content.Add("")
    $content.Add("## Needs Attention")
    $content.Add("")
    foreach ($row in $nonstandard) {
        $content.Add("- $($row.Name): missing SKILL.md")
    }
}

Set-Content -LiteralPath $IndexPath -Value $content -Encoding UTF8

Write-Host "Standard skills: $($standard.Count)"
Write-Host "Non-standard folders in library/skills: $($nonstandard.Count)"
Write-Host "Index written to: $IndexPath"
