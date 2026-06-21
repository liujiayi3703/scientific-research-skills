$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Root = Split-Path -Parent $ScriptDir
$SkillsDir = Join-Path $Root "library\skills"
$DocsDir = Join-Path $Root "docs"
$ReportPath = Join-Path $DocsDir "TRIGGER_AUDIT.md"
$CsvPath = Join-Path $DocsDir "trigger-audit.csv"

if (-not (Test-Path $SkillsDir)) {
    throw "Cannot find skills directory: $SkillsDir"
}

New-Item -ItemType Directory -Force -Path $DocsDir | Out-Null

function Get-FrontmatterField {
    param(
        [string]$SkillPath,
        [string]$Field
    )

    $lines = Get-Content -LiteralPath $SkillPath -Encoding UTF8 -TotalCount 120
    $parts = New-Object System.Collections.Generic.List[string]
    $captureFolded = $false

    foreach ($line in $lines) {
        if ($line -eq "---" -and $parts.Count -gt 0) {
            break
        }

        if ($captureFolded) {
            if ($line -match "^[A-Za-z0-9_-]+:\s*") {
                break
            }
            $trimmed = $line.Trim()
            if ($trimmed) {
                $parts.Add($trimmed)
            }
            continue
        }

        if ($line -match "^$([regex]::Escape($Field)):\s*(.*)$") {
            $value = $Matches[1].Trim()
            if ([string]::IsNullOrWhiteSpace($value) -or $value -eq ">" -or $value -eq "|") {
                $captureFolded = $true
            } else {
                $parts.Add($value.Trim('"').Trim("'"))
                break
            }
        }
    }

    return (($parts -join " ") -replace "\s+", " ").Trim()
}

function Test-GarbledText {
    param([string]$Text)

    $markerCodes = @(
        0xFFFD,
        0x95B3,
        0x95B4,
        0x95B8,
        0x95BB,
        0x9239,
        0x922B,
        0x943E,
        0x9451,
        0x9365,
        0x7F01,
        0x94B1,
        0x951B
    )

    foreach ($code in $markerCodes) {
        if ($Text.IndexOf([char]$code) -ge 0) {
            return $true
        }
    }
    return $false
}

function Get-TriggerIssues {
    param(
        [string]$SkillName,
        [string]$Description
    )

    $issues = New-Object System.Collections.Generic.List[string]

    if ([string]::IsNullOrWhiteSpace($Description)) {
        $issues.Add("missing-description")
        return $issues
    }

    if ($Description.Length -gt 900) {
        $issues.Add("too-long-critical")
    } elseif ($Description.Length -gt 500) {
        $issues.Add("too-long")
    }

    if ($Description -notmatch "^(Use when|Use this|Engage this|Create|Applies|Build|Guide|Watch|Execute|Prime|Search|Turn|Put|PUA|P10|P9|P7|SB Leader)") {
        $issues.Add("weak-opening")
    }

    if (Test-GarbledText -Text $Description) {
        $issues.Add("mojibake-or-garbled-text")
    }

    if ($Description -match "\bI\b|\bmy\b|\bme\b" -and $Description -notmatch "AI/ML|image|timeline") {
        $issues.Add("first-person-risk")
    }

    if ($Description -match "workflow|steps|then|first .* then|read .* then route|full runtime|dispatches") {
        $issues.Add("process-summary-risk")
    }

    if ($Description -match "Claude|Anthropic|claude-" -and $SkillName -notmatch "claude|brand|how-it-works|knowledge-agent|mem-search|academic-research-suite|research-idea-and-battle") {
        $issues.Add("provider-specific-wording")
    }

    if ($Description.Length -lt 70) {
        $issues.Add("too-short")
    }

    return $issues
}

$rows = foreach ($dir in (Get-ChildItem -LiteralPath $SkillsDir -Directory | Sort-Object Name)) {
    $skillPath = Join-Path $dir.FullName "SKILL.md"
    if (-not (Test-Path $skillPath)) {
        continue
    }

    $frontName = Get-FrontmatterField -SkillPath $skillPath -Field "name"
    $description = Get-FrontmatterField -SkillPath $skillPath -Field "description"
    $issues = @(Get-TriggerIssues -SkillName $dir.Name -Description $description)

    [PSCustomObject]@{
        Folder = $dir.Name
        FrontmatterName = $frontName
        DescriptionLength = $description.Length
        IssueCount = $issues.Count
        Issues = ($issues -join "; ")
        Description = $description
    }
}

$rows | Export-Csv -LiteralPath $CsvPath -NoTypeInformation -Encoding UTF8

$issueGroups = @($rows | Where-Object { $_.IssueCount -gt 0 } | Sort-Object IssueCount, DescriptionLength -Descending)
$clean = @($rows | Where-Object { $_.IssueCount -eq 0 })

$content = New-Object System.Collections.Generic.List[string]
$content.Add("# Skill Trigger Audit")
$content.Add("")
$content.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
$content.Add("")
$content.Add("## Summary")
$content.Add("")
$content.Add("- Total standard skills: $($rows.Count)")
$content.Add("- Clean descriptions: $($clean.Count)")
$content.Add("- Descriptions needing review: $($issueGroups.Count)")
$content.Add('- Raw CSV: docs/trigger-audit.csv')
$content.Add("")
$content.Add("## What The Checks Mean")
$content.Add("")
$content.Add('- mojibake-or-garbled-text: Chinese or punctuation appears corrupted, which can hurt matching.')
$content.Add('- too-long: description is over 500 characters; it may dilute trigger signals.')
$content.Add('- too-long-critical: description is over 900 characters and should be shortened soon.')
$content.Add('- process-summary-risk: description may summarize workflow instead of only trigger conditions.')
$content.Add('- provider-specific-wording: wording mentions a provider in a skill that should probably be app-neutral.')
$content.Add('- weak-opening: description does not start with a clear trigger phrase.')
$content.Add('- too-short: description may not include enough trigger keywords.')
$content.Add("")
$content.Add("## Priority Fixes")
$content.Add("")
if ($issueGroups.Count -eq 0) {
    $content.Add("No trigger description issues found.")
} else {
    $content.Add("| Skill | Length | Issues |")
    $content.Add("| --- | ---: | --- |")
    foreach ($row in ($issueGroups | Select-Object -First 30)) {
        $content.Add(('| {0} | {1} | {2} |' -f $row.Folder, $row.DescriptionLength, $row.Issues))
    }
}
$content.Add("")
$content.Add("## Clean Descriptions")
$content.Add("")
foreach ($folder in ($clean.Folder | Sort-Object)) {
    $content.Add(('- {0}' -f $folder))
}
$content.Add("")
$content.Add("## Recommended Next Pass")
$content.Add("")
$content.Add('1. Fix mojibake-or-garbled-text first because corrupted text directly damages trigger matching.')
$content.Add('2. Shorten too-long-critical descriptions to clear trigger conditions.')
$content.Add("3. Resolve overlaps among similarly named workflow skills only after the text is readable.")
$content.Add('4. Re-run tools/Audit-SkillTriggers.ps1, then tools/Audit-Skills.ps1.')

Set-Content -LiteralPath $ReportPath -Value $content -Encoding UTF8

Write-Host "Trigger audit written to: $ReportPath"
Write-Host "Raw CSV written to: $CsvPath"
Write-Host "Total skills: $($rows.Count)"
Write-Host "Needs review: $($issueGroups.Count)"
