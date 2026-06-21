param(
    [string]$CsvPath,
    [string]$OutJson,
    [string]$OutMarkdown,
    [switch]$RequireComplete
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Root = Split-Path -Parent $ScriptDir
$DocsDir = Join-Path $Root "docs"

if ([string]::IsNullOrWhiteSpace($CsvPath)) {
    $CsvPath = Join-Path $DocsDir "platform-validation-prompts.csv"
}
if ([string]::IsNullOrWhiteSpace($OutJson)) {
    $OutJson = Join-Path $DocsDir "platform-validation-results.json"
}
if ([string]::IsNullOrWhiteSpace($OutMarkdown)) {
    $OutMarkdown = Join-Path $DocsDir "REAL_PLATFORM_VALIDATION_SUMMARY.md"
}

if (-not (Test-Path $CsvPath)) {
    throw "Cannot find platform validation CSV: $CsvPath"
}

New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutJson) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutMarkdown) | Out-Null

$platforms = @(
    [PSCustomObject]@{ key = "claude_code"; label = "Claude Code"; column = "claude_code_result" }
    [PSCustomObject]@{ key = "codex"; label = "Codex"; column = "codex_result" }
    [PSCustomObject]@{ key = "trae_solo"; label = "Trae IDE / SOLO"; column = "trae_solo_result" }
    [PSCustomObject]@{ key = "generic_agents"; label = "Generic agents"; column = "generic_agents_result" }
)

function Normalize-Result {
    param(
        [string]$Raw,
        [string]$ExpectedSkill,
        [string]$AllowedRelated
    )

    $value = ([string]$Raw).Trim()
    if ([string]::IsNullOrWhiteSpace($value)) {
        return [PSCustomObject][ordered]@{
            status = "untested"
            evidence = ""
            selected_skill = ""
        }
    }

    $lower = $value.ToLowerInvariant()
    $expectedLower = $ExpectedSkill.ToLowerInvariant()
    $allowed = @()
    if (-not [string]::IsNullOrWhiteSpace($AllowedRelated)) {
        $allowed = @($AllowedRelated -split ";" | ForEach-Object { $_.Trim().ToLowerInvariant() } | Where-Object { $_ })
    }

    if ($lower -in @("pass", "passed", "ok", "yes", "y", "true", "1")) {
        return [PSCustomObject][ordered]@{
            status = "pass"
            evidence = $value
            selected_skill = $ExpectedSkill
        }
    }

    if ($lower -in @("skip", "skipped", "n/a", "na", "not applicable")) {
        return [PSCustomObject][ordered]@{
            status = "skipped"
            evidence = $value
            selected_skill = ""
        }
    }

    if ($lower -in @("fail", "failed", "no", "n", "false", "0")) {
        return [PSCustomObject][ordered]@{
            status = "fail"
            evidence = $value
            selected_skill = ""
        }
    }

    if ($lower -eq $expectedLower -or $lower.Contains($expectedLower)) {
        return [PSCustomObject][ordered]@{
            status = "pass"
            evidence = $value
            selected_skill = $ExpectedSkill
        }
    }

    foreach ($related in $allowed) {
        if ($lower -eq $related -or $lower.Contains($related)) {
            return [PSCustomObject][ordered]@{
                status = "fail-related"
                evidence = $value
                selected_skill = $related
            }
        }
    }

    return [PSCustomObject][ordered]@{
        status = "fail"
        evidence = $value
        selected_skill = $value
    }
}

$rows = @(Import-Csv -LiteralPath $CsvPath)
$caseResults = New-Object System.Collections.Generic.List[object]
$platformSummary = @{}

foreach ($platform in $platforms) {
    $platformSummary[$platform.key] = [ordered]@{
        label = $platform.label
        total = $rows.Count
        pass = 0
        fail = 0
        fail_related = 0
        skipped = 0
        untested = 0
        complete = $false
        perfect = $false
    }
}

foreach ($row in $rows) {
    $perPlatform = [ordered]@{}
    foreach ($platform in $platforms) {
        $raw = [string]$row.($platform.column)
        $normalized = Normalize-Result -Raw $raw -ExpectedSkill ([string]$row.expected_skill) -AllowedRelated ([string]$row.allowed_related_skills)
        $summary = $platformSummary[$platform.key]
        switch ($normalized.status) {
            "pass" { $summary.pass++ }
            "fail" { $summary.fail++ }
            "fail-related" { $summary.fail_related++ }
            "skipped" { $summary.skipped++ }
            default { $summary.untested++ }
        }

        $perPlatform[$platform.key] = [PSCustomObject]@{
            status = $normalized.status
            evidence = $normalized.evidence
            selected_skill = $normalized.selected_skill
        }
    }

    $caseResults.Add([PSCustomObject]@{
        id = [string]$row.id
        expected_skill = [string]$row.expected_skill
        prompt = [string]$row.prompt
        allowed_related_skills = [string]$row.allowed_related_skills
        notes = [string]$row.notes
        platforms = [PSCustomObject]$perPlatform
    })
}

foreach ($platform in $platforms) {
    $summary = $platformSummary[$platform.key]
    $summary.complete = ($summary.untested -eq 0 -and $summary.skipped -eq 0)
    $summary.perfect = ($summary.pass -eq $summary.total -and $summary.fail -eq 0 -and $summary.fail_related -eq 0 -and $summary.skipped -eq 0 -and $summary.untested -eq 0)
}

$allPlatformsPerfect = $true
foreach ($platform in $platforms) {
    if (-not $platformSummary[$platform.key].perfect) {
        $allPlatformsPerfect = $false
    }
}

$report = [PSCustomObject][ordered]@{
    schema_version = 1
    generated_at = (Get-Date).ToString("s")
    csv_path = (Resolve-Path -LiteralPath $CsvPath).Path
    total_cases = $rows.Count
    all_platforms_perfect = $allPlatformsPerfect
    require_complete = [bool]$RequireComplete
    platform_summary = [PSCustomObject]$platformSummary
    cases = @($caseResults.ToArray())
}

$report | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $OutJson -Encoding UTF8

$md = New-Object System.Collections.Generic.List[string]
$md.Add("# Real Platform Validation Summary")
$md.Add("")
$md.Add("Generated: $($report.generated_at)")
$md.Add("")
$md.Add('This report summarizes real app validation results recorded in `docs/platform-validation-prompts.csv`.')
$md.Add("")
$md.Add("## Summary")
$md.Add("")
$md.Add("| Platform | Total | Pass | Fail | Related Fail | Skipped | Untested | Perfect |")
$md.Add("| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |")
foreach ($platform in $platforms) {
    $summary = $platformSummary[$platform.key]
    $md.Add("| $($summary.label) | $($summary.total) | $($summary.pass) | $($summary.fail) | $($summary.fail_related) | $($summary.skipped) | $($summary.untested) | $(if ($summary.perfect) { 'yes' } else { 'no' }) |")
}
$md.Add("")
$md.Add("## How To Record Results")
$md.Add("")
$md.Add("- Leave a result cell blank when untested.")
$md.Add('- Enter the selected skill name, such as `xlsx`, when the app selected or clearly applied that skill.')
$md.Add('- Enter `pass` only when the platform does not expose a skill name but clearly applied the expected skill.')
$md.Add("- Enter the wrong selected skill name to record a fail.")
$md.Add('- Enter `skip` only when a platform cannot run that case.')
$md.Add("")
$md.Add("## Failures And Untested Cases")
$md.Add("")
$problemCount = 0
foreach ($case in $caseResults) {
    foreach ($platform in $platforms) {
        $result = $case.platforms.($platform.key)
        if ($result.status -ne "pass" -and $result.status -ne "skipped") {
            $problemCount++
            $evidence = if ([string]::IsNullOrWhiteSpace($result.evidence)) { "" } else { " evidence: $($result.evidence)" }
            $md.Add(('- `{0}` / {1}: {2}; expected `{3}`.{4}' -f $case.id, $platform.label, $result.status, $case.expected_skill, $evidence))
        }
    }
}
if ($problemCount -eq 0) {
    $md.Add("No failures or untested cases recorded.")
}

Set-Content -LiteralPath $OutMarkdown -Value $md -Encoding UTF8

Write-Host "Platform validation JSON written to: $OutJson"
Write-Host "Platform validation summary written to: $OutMarkdown"
foreach ($platform in $platforms) {
    $summary = $platformSummary[$platform.key]
    Write-Host "$($summary.label): pass=$($summary.pass) fail=$($summary.fail) related_fail=$($summary.fail_related) skipped=$($summary.skipped) untested=$($summary.untested)"
}

if ($RequireComplete -and -not $allPlatformsPerfect) {
    Write-Host "Platform validation is not complete/perfect for every platform."
    exit 1
}

exit 0
