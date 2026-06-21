param(
    [string]$SkillsDir,
    [string]$EvalsPath,
    [string]$OutJson,
    [string]$OutMarkdown
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Root = Split-Path -Parent $ScriptDir

if ([string]::IsNullOrWhiteSpace($SkillsDir)) {
    $SkillsDir = Join-Path $Root "library\skills"
}
if ([string]::IsNullOrWhiteSpace($EvalsPath)) {
    $EvalsPath = Join-Path $Root "docs\trigger-evals.json"
}
if ([string]::IsNullOrWhiteSpace($OutJson)) {
    $OutJson = Join-Path $Root "docs\skills-manifest.json"
}
if ([string]::IsNullOrWhiteSpace($OutMarkdown)) {
    $OutMarkdown = Join-Path $Root "docs\SKILLS_MANIFEST.md"
}

if (-not (Test-Path $SkillsDir)) {
    throw "Cannot find skills directory: $SkillsDir"
}

$DocsDir = Split-Path -Parent $OutJson
New-Item -ItemType Directory -Force -Path $DocsDir | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutMarkdown) | Out-Null

function Get-FrontmatterField {
    param(
        [string]$SkillPath,
        [string]$Field
    )

    $lines = Get-Content -LiteralPath $SkillPath -Encoding UTF8 -TotalCount 160
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
                $parts.Add($trimmed.Trim('"').Trim("'"))
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

function Escape-MarkdownCell {
    param([string]$Text)
    return (($Text -replace "\|", "\|") -replace "`r?`n", " ").Trim()
}

function Get-ArrayValue {
    param($Value)

    if ($null -eq $Value) {
        return @()
    }

    return @($Value | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) })
}

$evalIndex = @{}
if (Test-Path $EvalsPath) {
    $evalData = Get-Content -LiteralPath $EvalsPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $cases = @()
    if ($evalData.PSObject.Properties.Name -contains "cases") {
        $cases = @($evalData.cases)
    } else {
        $cases = @($evalData)
    }

    foreach ($case in $cases) {
        $expected = [string]$case.expected_skill
        if ([string]::IsNullOrWhiteSpace($expected)) {
            continue
        }
        if (-not $evalIndex.ContainsKey($expected)) {
            $evalIndex[$expected] = @()
        }
        $evalIndex[$expected] += [PSCustomObject]@{
            id = [string]$case.id
            prompt = [string]$case.prompt
            blocked_skills = @(Get-ArrayValue -Value $case.blocked_skills)
            allowed_related_skills = @(Get-ArrayValue -Value $case.allowed_related_skills)
        }
    }
}

$skillRows = foreach ($dir in (Get-ChildItem -LiteralPath $SkillsDir -Directory | Sort-Object Name)) {
    $skillPath = Join-Path $dir.FullName "SKILL.md"
    if (-not (Test-Path $skillPath)) {
        continue
    }

    $frontName = Get-FrontmatterField -SkillPath $skillPath -Field "name"
    $description = Get-FrontmatterField -SkillPath $skillPath -Field "description"
    $resourceDirs = @(Get-ChildItem -LiteralPath $dir.FullName -Directory | Select-Object -ExpandProperty Name)
    $evalCases = @()
    if ($evalIndex.ContainsKey($dir.Name)) {
        $evalCases = @($evalIndex[$dir.Name])
    }

    [PSCustomObject]@{
        id = $dir.Name
        name = $(if ([string]::IsNullOrWhiteSpace($frontName)) { $dir.Name } else { $frontName })
        description = $description
        path = $dir.FullName
        skill_md = $skillPath
        resource_dirs = $resourceDirs
        eval_case_count = $evalCases.Count
        eval_cases = $evalCases
    }
}

$manifest = [PSCustomObject]@{
    schema_version = 1
    generated_at = (Get-Date).ToString("s")
    source_root = $Root
    skills_dir = (Resolve-Path -LiteralPath $SkillsDir).Path
    evals_path = $(if (Test-Path $EvalsPath) { (Resolve-Path -LiteralPath $EvalsPath).Path } else { $EvalsPath })
    skill_count = @($skillRows).Count
    recommended_generic_agent_files = @(
        (Join-Path $Root "docs\SKILLS_MANIFEST.md"),
        (Join-Path $Root "docs\skills-manifest.json"),
        (Join-Path $Root "docs\SKILL_INDEX.md"),
        (Join-Path $Root "docs\TRIGGER_TEST_RESULTS.md")
    )
    generic_agent_usage = @(
        "Load skills-manifest.json first to choose candidate skills by id, name, and description.",
        "When a candidate skill is needed, read that skill's SKILL.md completely before applying it.",
        "Use eval_cases as smoke-test prompts after connecting a new app or IDE.",
        "If a platform supports a skills directory, point it to library/skills instead of copying manifest text."
    )
    skills = @($skillRows)
}

$manifest | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $OutJson -Encoding UTF8

$md = New-Object System.Collections.Generic.List[string]
$md.Add("# Skills Manifest")
$md.Add("")
$md.Add("Generated: $($manifest.generated_at)")
$md.Add("")
$md.Add("This file is for apps or agents that cannot directly scan a standard skills directory.")
$md.Add("")
$md.Add("## How Generic Agents Should Use This")
$md.Add("")
$md.Add('1. Read `docs/skills-manifest.json` or this file first.')
$md.Add('2. Select candidate skills by `id`, `name`, and `description`.')
$md.Add('3. Read the selected `SKILL.md` completely before applying the skill.')
$md.Add("4. Use the listed eval cases as smoke tests after connecting a new app.")
$md.Add("")
$md.Add("## Library")
$md.Add("")
$md.Add(('- Source root: `{0}`' -f $Root))
$md.Add(('- Skills directory: `{0}`' -f $manifest.skills_dir))
$md.Add("- Skill count: $($manifest.skill_count)")
$md.Add(('- JSON manifest: `{0}`' -f $OutJson))
$md.Add("")
$md.Add("## Skills")
$md.Add("")
$md.Add("| Skill | Name | Eval Cases | Description |")
$md.Add("| --- | --- | ---: | --- |")
foreach ($skill in $skillRows) {
    $md.Add("| $($skill.id) | $(Escape-MarkdownCell $skill.name) | $($skill.eval_case_count) | $(Escape-MarkdownCell $skill.description) |")
}

$md.Add("")
$md.Add("## Eval Case Map")
$md.Add("")
foreach ($skill in $skillRows) {
    $md.Add("### $($skill.id)")
    $md.Add("")
    $md.Add(('- `SKILL.md`: `{0}`' -f $skill.skill_md))
    if ($skill.resource_dirs.Count -gt 0) {
        $md.Add(('- Resource dirs: {0}' -f ($skill.resource_dirs -join ', ')))
    } else {
        $md.Add("- Resource dirs: none")
    }
    if ($skill.eval_case_count -eq 0) {
        $md.Add("- Eval cases: none")
        $md.Add("")
        continue
    }
    foreach ($case in $skill.eval_cases) {
        $md.Add(('- `{0}`: {1}' -f $case.id, $case.prompt))
    }
    $md.Add("")
}

Set-Content -LiteralPath $OutMarkdown -Value $md -Encoding UTF8

Write-Host "Manifest JSON written to: $OutJson"
Write-Host "Manifest Markdown written to: $OutMarkdown"
Write-Host "Skills exported: $(@($skillRows).Count)"
