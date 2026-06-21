param(
    [string]$EvalsPath,
    [string]$SkillsDir,
    [string]$OutMarkdown,
    [string]$OutCsv,
    [string]$OutPromptPackDir
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Root = Split-Path -Parent $ScriptDir

if ([string]::IsNullOrWhiteSpace($EvalsPath)) {
    $EvalsPath = Join-Path $Root "docs\trigger-evals.json"
}
if ([string]::IsNullOrWhiteSpace($SkillsDir)) {
    $SkillsDir = Join-Path $Root "library\skills"
}
if ([string]::IsNullOrWhiteSpace($OutMarkdown)) {
    $OutMarkdown = Join-Path $Root "docs\REAL_PLATFORM_VALIDATION_MATRIX.md"
}
if ([string]::IsNullOrWhiteSpace($OutCsv)) {
    $OutCsv = Join-Path $Root "docs\platform-validation-prompts.csv"
}
if ([string]::IsNullOrWhiteSpace($OutPromptPackDir)) {
    $OutPromptPackDir = Join-Path $Root "docs\platform-prompt-packs"
}

if (-not (Test-Path $EvalsPath)) {
    throw "Cannot find evals file: $EvalsPath"
}
if (-not (Test-Path $SkillsDir)) {
    throw "Cannot find skills directory: $SkillsDir"
}

New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutMarkdown) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutCsv) | Out-Null
New-Item -ItemType Directory -Force -Path $OutPromptPackDir | Out-Null

function Get-ArrayValue {
    param($Value)

    if ($null -eq $Value) {
        return @()
    }

    return @($Value | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) })
}

function Get-TargetStatus {
    param(
        [string]$Name,
        [string]$Path,
        [string[]]$ExpectedSkills
    )

    if (-not (Test-Path $Path)) {
        return [PSCustomObject]@{
            platform = $Name
            path = $Path
            exists = $false
            skill_count = 0
            missing_count = $ExpectedSkills.Count
            status = "not-connected"
        }
    }

    $present = @(Get-ChildItem -LiteralPath $Path -Directory -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name)
    $missing = @($ExpectedSkills | Where-Object { $_ -notin $present })
    $status = $(if ($missing.Count -eq 0) { "connected" } else { "partial" })

    [PSCustomObject]@{
        platform = $Name
        path = $Path
        exists = $true
        skill_count = $present.Count
        missing_count = $missing.Count
        status = $status
    }
}

$evalData = Get-Content -LiteralPath $EvalsPath -Raw -Encoding UTF8 | ConvertFrom-Json
$cases = @()
if ($evalData.PSObject.Properties.Name -contains "cases") {
    $cases = @($evalData.cases)
} else {
    $cases = @($evalData)
}

$skillNames = @(Get-ChildItem -LiteralPath $SkillsDir -Directory | Where-Object {
    Test-Path (Join-Path $_.FullName "SKILL.md")
} | Select-Object -ExpandProperty Name | Sort-Object)

$targetStatuses = @(
    Get-TargetStatus -Name "Claude Code default" -Path (Join-Path $env:USERPROFILE ".claude\skills") -ExpectedSkills $skillNames
    Get-TargetStatus -Name "Codex default" -Path (Join-Path $env:USERPROFILE ".codex\skills") -ExpectedSkills $skillNames
    Get-TargetStatus -Name "Generic agents default" -Path (Join-Path $env:USERPROFILE ".agents\skills") -ExpectedSkills $skillNames
)

$existingById = @{}
if (Test-Path $OutCsv) {
    foreach ($existingRow in @(Import-Csv -LiteralPath $OutCsv)) {
        if (-not [string]::IsNullOrWhiteSpace($existingRow.id)) {
            $existingById[$existingRow.id] = $existingRow
        }
    }
}

$rows = foreach ($case in $cases) {
    $existing = $null
    if ($existingById.ContainsKey([string]$case.id)) {
        $existing = $existingById[[string]$case.id]
    }

    [PSCustomObject]@{
        id = [string]$case.id
        expected_skill = [string]$case.expected_skill
        prompt = [string]$case.prompt
        blocked_skills = (Get-ArrayValue -Value $case.blocked_skills) -join "; "
        allowed_related_skills = (Get-ArrayValue -Value $case.allowed_related_skills) -join "; "
        claude_code_result = $(if ($null -ne $existing) { [string]$existing.claude_code_result } else { "" })
        codex_result = $(if ($null -ne $existing) { [string]$existing.codex_result } else { "" })
        trae_solo_result = $(if ($null -ne $existing) { [string]$existing.trae_solo_result } else { "" })
        generic_agents_result = $(if ($null -ne $existing) { [string]$existing.generic_agents_result } else { "" })
        notes = $(if ($null -ne $existing) { [string]$existing.notes } else { "" })
    }
}

$rows | Export-Csv -LiteralPath $OutCsv -NoTypeInformation -Encoding UTF8

$promptPackPlatforms = @(
    [PSCustomObject]@{
        name = "Claude Code"
        file = "claude-code-prompts.md"
        result_column = "claude_code_result"
        setup = 'Use the default local skills directory `%USERPROFILE%\.claude\skills`.'
    }
    [PSCustomObject]@{
        name = "Codex"
        file = "codex-prompts.md"
        result_column = "codex_result"
        setup = 'Use the default local skills directory `%USERPROFILE%\.codex\skills`.'
    }
    [PSCustomObject]@{
        name = "Trae IDE / SOLO"
        file = "trae-solo-prompts.md"
        result_column = "trae_solo_result"
        setup = 'Point the app at `library/skills` if supported, otherwise provide `docs/skills-manifest.json`.'
    }
    [PSCustomObject]@{
        name = "Generic agents"
        file = "generic-agents-prompts.md"
        result_column = "generic_agents_result"
        setup = 'Start by giving the agent `docs/skills-manifest.json`, then ask it to read the selected `SKILL.md`.'
    }
)

foreach ($platform in $promptPackPlatforms) {
    $pack = New-Object System.Collections.Generic.List[string]
    $pack.Add("# $($platform.name) Skill Validation Prompts")
    $pack.Add("")
    $pack.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
    $pack.Add("")
    $pack.Add("Setup: $($platform.setup)")
    $pack.Add("")
    $pack.Add(('Record results in `docs/platform-validation-prompts.csv`, column `{0}`.' -f $platform.result_column))
    $pack.Add("")
    $pack.Add("Use a fresh or neutral session when possible. Mark pass only when the expected skill is selected or clearly applied.")
    $pack.Add("")
    foreach ($row in $rows) {
        $pack.Add("## $($row.id)")
        $pack.Add("")
        $pack.Add(('- Expected skill: `{0}`' -f $row.expected_skill))
        if (-not [string]::IsNullOrWhiteSpace($row.allowed_related_skills)) {
            $pack.Add("- Allowed nearby skills: $($row.allowed_related_skills)")
        }
        if (-not [string]::IsNullOrWhiteSpace($row.blocked_skills)) {
            $pack.Add("- Should not win: $($row.blocked_skills)")
        }
        $pack.Add("")
        $pack.Add("Prompt:")
        $pack.Add("")
        $pack.Add('```text')
        $pack.Add($row.prompt)
        $pack.Add('```')
        $pack.Add("")
        $pack.Add("Result to record:")
        $pack.Add("")
    }
    Set-Content -LiteralPath (Join-Path $OutPromptPackDir $platform.file) -Value $pack -Encoding UTF8
}

$md = New-Object System.Collections.Generic.List[string]
$md.Add("# Real Platform Validation Matrix")
$md.Add("")
$md.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
$md.Add("")
$md.Add("This matrix is for real app verification. Local proxy routing tests are useful, but they do not prove a vendor app's internal skill router.")
$md.Add("")
$md.Add("## Evidence Levels")
$md.Add("")
$md.Add("| Evidence | Meaning |")
$md.Add("| --- | --- |")
$md.Add("| Local connected | Skills exist in the platform's default local directory. |")
$md.Add('| Proxy top-1 pass | `tools/Test-SkillRouting.py` selected the expected skill. |')
$md.Add("| Real app pass | The named app actually selected or applied the expected skill for the prompt. |")
$md.Add("")
$md.Add("## Local Connection Status")
$md.Add("")
$md.Add("| Platform target | Path | Status | Skill count | Missing shared skills |")
$md.Add("| --- | --- | --- | ---: | ---: |")
foreach ($target in $targetStatuses) {
    $md.Add(('| {0} | `{1}` | {2} | {3} | {4} |' -f $target.platform, $target.path, $target.status, $target.skill_count, $target.missing_count))
}
$md.Add("")
$md.Add('Trae IDE/SOLO, Doubao, Marvis, GLM, and other apps do not have a universal default skills path. Use `docs/skills-manifest.json` if they cannot scan `library/skills` directly.')
$md.Add("")
$md.Add('Per-platform prompt packs are in `docs/platform-prompt-packs/`.')
$md.Add("")
$md.Add("## How To Run Real Platform Checks")
$md.Add("")
$md.Add('1. Connect or point the app at `library/skills`, or give it `docs/skills-manifest.json`.')
$md.Add("2. Use each prompt below in a fresh or neutral session.")
$md.Add("3. Record the skill the app selected or visibly applied.")
$md.Add("4. Mark pass only when the expected skill is selected or its instructions are clearly applied.")
$md.Add("5. If a related skill appears but expected skill still wins, note it; if related skill replaces expected skill, mark fail.")
$md.Add("")
$md.Add("## Platform Result Summary")
$md.Add("")
$md.Add("| Platform | Local connected | Real routing tested | Pass count | Fail count | Notes |")
$md.Add("| --- | --- | --- | ---: | ---: | --- |")
$md.Add('| Claude Code | pending manual confirmation | no | 0 | 0 | Use `.claude/skills` default path. |')
$md.Add('| Codex | pending manual confirmation | no | 0 | 0 | Use `.codex/skills` default path. |')
$md.Add('| Trae IDE / SOLO | app-specific | no | 0 | 0 | Point app to `library/skills` or import manifest. |')
$md.Add('| Generic agents: Doubao / Marvis / GLM | app-specific | no | 0 | 0 | Start with `docs/skills-manifest.json`. |')
$md.Add("")
$md.Add("## Prompt Checklist")
$md.Add("")
$md.Add("| Case | Expected skill | Claude Code | Codex | Trae/SOLO | Generic agents | Prompt |")
$md.Add("| --- | --- | --- | --- | --- | --- | --- |")
foreach ($row in $rows) {
    $prompt = (($row.prompt -replace "\|", "\|") -replace "`r?`n", " ").Trim()
    $md.Add("| $($row.id) | $($row.expected_skill) | [ ] | [ ] | [ ] | [ ] | $prompt |")
}

Set-Content -LiteralPath $OutMarkdown -Value $md -Encoding UTF8

Write-Host "Platform validation matrix written to: $OutMarkdown"
Write-Host "Platform validation CSV written to: $OutCsv"
Write-Host "Platform prompt packs written to: $OutPromptPackDir"
Write-Host "Eval prompts exported: $(@($rows).Count)"
