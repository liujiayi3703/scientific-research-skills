param(
    [int]$Repeat = 1,
    [string]$Python = "python",
    [switch]$StopOnFirstFailure,
    [switch]$SkipDefaultTargetCheck,
    [switch]$RequireRealPlatformComplete
)

$ErrorActionPreference = "Stop"

if ($Repeat -lt 1) {
    throw "Repeat must be at least 1."
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Root = Split-Path -Parent $ScriptDir
$SkillsDir = Join-Path $Root "library\skills"
$DocsDir = Join-Path $Root "docs"
$GateJson = Join-Path $DocsDir "quality-gate-report.json"
$GateMarkdown = Join-Path $DocsDir "QUALITY_GATE_REPORT.md"

$AuditSkills = Join-Path $ScriptDir "Audit-Skills.ps1"
$AuditTriggers = Join-Path $ScriptDir "Audit-SkillTriggers.ps1"
$RoutingTest = Join-Path $ScriptDir "Test-SkillRouting.py"
$ManifestExport = Join-Path $ScriptDir "Export-SkillManifest.ps1"
$ValidationExport = Join-Path $ScriptDir "Export-PlatformValidationPack.ps1"
$ValidationSummary = Join-Path $ScriptDir "Summarize-PlatformValidation.ps1"

New-Item -ItemType Directory -Force -Path $DocsDir | Out-Null

function Invoke-GateCommand {
    param(
        [string]$Name,
        [scriptblock]$Command
    )

    $started = Get-Date
    $output = New-Object System.Collections.Generic.List[string]
    $exitCode = 0

    try {
        $captured = & $Command 2>&1
        foreach ($line in @($captured)) {
            $output.Add([string]$line)
        }
        if ($LASTEXITCODE -is [int] -and $LASTEXITCODE -ne 0) {
            $exitCode = $LASTEXITCODE
        }
    } catch {
        $exitCode = 1
        $output.Add([string]$_)
    }

    $ended = Get-Date
    [PSCustomObject]@{
        name = $Name
        passed = ($exitCode -eq 0)
        exit_code = $exitCode
        duration_seconds = [math]::Round(($ended - $started).TotalSeconds, 3)
        output_tail = @($output | Select-Object -Last 20)
    }
}

function Read-JsonFile {
    param([string]$Path)
    return Get-Content -LiteralPath $Path -Raw -Encoding UTF8 | ConvertFrom-Json
}

function Get-ArrayValue {
    param($Value)

    if ($null -eq $Value) {
        return @()
    }

    return @($Value)
}

function Test-DefaultTargets {
    param([string[]]$ExpectedSkills)

    $targets = @(
        [PSCustomObject]@{ platform = "Claude Code default"; path = (Join-Path $env:USERPROFILE ".claude\skills") }
        [PSCustomObject]@{ platform = "Codex default"; path = (Join-Path $env:USERPROFILE ".codex\skills") }
        [PSCustomObject]@{ platform = "Generic agents default"; path = (Join-Path $env:USERPROFILE ".agents\skills") }
    )

    foreach ($target in $targets) {
        if (-not (Test-Path $target.path)) {
            [PSCustomObject]@{
                platform = $target.platform
                path = $target.path
                passed = $false
                skill_count = 0
                missing_count = $ExpectedSkills.Count
                missing = $ExpectedSkills
            }
            continue
        }

        $present = @(Get-ChildItem -LiteralPath $target.path -Directory | Select-Object -ExpandProperty Name)
        $missing = @($ExpectedSkills | Where-Object { $_ -notin $present })
        [PSCustomObject]@{
            platform = $target.platform
            path = $target.path
            passed = ($missing.Count -eq 0)
            skill_count = $present.Count
            missing_count = $missing.Count
            missing = $missing
        }
    }
}

function Test-GateArtifacts {
    param(
        [bool]$CheckDefaultTargets,
        [bool]$RequireRealPlatformComplete
    )

    $skillNames = @(Get-ChildItem -LiteralPath $SkillsDir -Directory | Where-Object {
        Test-Path (Join-Path $_.FullName "SKILL.md")
    } | Select-Object -ExpandProperty Name | Sort-Object)

    $allDirs = @(Get-ChildItem -LiteralPath $SkillsDir -Directory | Select-Object -ExpandProperty Name | Sort-Object)
    $nonstandard = @($allDirs | Where-Object { $_ -notin $skillNames })

    $evalsPath = Join-Path $DocsDir "trigger-evals.json"
    $triggerAuditPath = Join-Path $DocsDir "trigger-audit.csv"
    $routingResultsPath = Join-Path $DocsDir "trigger-test-results.json"
    $manifestPath = Join-Path $DocsDir "skills-manifest.json"
    $platformPromptsPath = Join-Path $DocsDir "platform-validation-prompts.csv"
    $platformResultsPath = Join-Path $DocsDir "platform-validation-results.json"

    $evalData = Read-JsonFile -Path $evalsPath
    $cases = @(Get-ArrayValue -Value $evalData.cases)
    $coveredSkills = @($cases | Select-Object -ExpandProperty expected_skill -Unique | Sort-Object)
    $missingEvalCoverage = @($skillNames | Where-Object { $_ -notin $coveredSkills })

    $triggerRows = @(Import-Csv -LiteralPath $triggerAuditPath)
    $triggerIssues = @($triggerRows | Where-Object { [int]$_.IssueCount -gt 0 })

    $routing = Read-JsonFile -Path $routingResultsPath
    $routingFailures = New-Object System.Collections.Generic.List[string]
    foreach ($profileName in $routing.summary.PSObject.Properties.Name) {
        $stats = $routing.summary.$profileName
        if ([int]$stats.total -ne $cases.Count) {
            $routingFailures.Add("$profileName total $($stats.total) != eval count $($cases.Count)")
        }
        if ([int]$stats.top1 -ne [int]$stats.total) {
            $routingFailures.Add("$profileName top1 $($stats.top1) != total $($stats.total)")
        }
        if ([int]$stats.top3 -ne [int]$stats.total) {
            $routingFailures.Add("$profileName top3 $($stats.top3) != total $($stats.total)")
        }
        if ([int]$stats.blocked_top3 -ne 0) {
            $routingFailures.Add("$profileName blocked_top3 is $($stats.blocked_top3)")
        }
    }

    $manifest = Read-JsonFile -Path $manifestPath
    $manifestSkills = @(Get-ArrayValue -Value $manifest.skills)
    $manifestMissingEvals = @($manifestSkills | Where-Object { [int]$_.eval_case_count -lt 1 } | Select-Object -ExpandProperty id)
    $manifestFailures = New-Object System.Collections.Generic.List[string]
    if ([int]$manifest.skill_count -ne $skillNames.Count) {
        $manifestFailures.Add("manifest skill_count $($manifest.skill_count) != standard skill count $($skillNames.Count)")
    }
    if ($manifestSkills.Count -ne $skillNames.Count) {
        $manifestFailures.Add("manifest skills length $($manifestSkills.Count) != standard skill count $($skillNames.Count)")
    }
    if ($manifestMissingEvals.Count -gt 0) {
        $manifestFailures.Add("manifest skills missing eval cases: $($manifestMissingEvals -join ', ')")
    }

    $platformPromptRows = @(Import-Csv -LiteralPath $platformPromptsPath)
    $platformPromptFailures = New-Object System.Collections.Generic.List[string]
    if ($platformPromptRows.Count -ne $cases.Count) {
        $platformPromptFailures.Add("platform prompt rows $($platformPromptRows.Count) != eval count $($cases.Count)")
    }

    $platformResults = Read-JsonFile -Path $platformResultsPath
    $platformResultFailures = New-Object System.Collections.Generic.List[string]
    if ([int]$platformResults.total_cases -ne $cases.Count) {
        $platformResultFailures.Add("platform validation result cases $($platformResults.total_cases) != eval count $($cases.Count)")
    }
    if ($RequireRealPlatformComplete -and -not [bool]$platformResults.all_platforms_perfect) {
        $platformResultFailures.Add("real platform validation is not 100% perfect across all tracked platforms")
    }

    $targetChecks = @()
    if ($CheckDefaultTargets) {
        $targetChecks = @(Test-DefaultTargets -ExpectedSkills $skillNames)
    }
    $targetFailures = @($targetChecks | Where-Object { -not $_.passed })

    $checks = @(
        [PSCustomObject]@{ name = "standard-skills-present"; passed = ($skillNames.Count -gt 0); detail = "$($skillNames.Count) standard skills" }
        [PSCustomObject]@{ name = "no-nonstandard-skill-folders"; passed = ($nonstandard.Count -eq 0); detail = "$($nonstandard.Count) nonstandard folders" }
        [PSCustomObject]@{ name = "eval-coverage"; passed = ($missingEvalCoverage.Count -eq 0); detail = "$($cases.Count) cases, missing coverage: $($missingEvalCoverage.Count)" }
        [PSCustomObject]@{ name = "trigger-audit-clean"; passed = ($triggerIssues.Count -eq 0); detail = "$($triggerIssues.Count) descriptions need review" }
        [PSCustomObject]@{ name = "routing-top1-100-and-no-blocked"; passed = ($routingFailures.Count -eq 0); detail = $(if ($routingFailures.Count -eq 0) { "all profiles pass" } else { $routingFailures -join "; " }) }
        [PSCustomObject]@{ name = "manifest-consistent"; passed = ($manifestFailures.Count -eq 0); detail = $(if ($manifestFailures.Count -eq 0) { "$($manifestSkills.Count) manifest skills" } else { $manifestFailures -join "; " }) }
        [PSCustomObject]@{ name = "platform-prompts-consistent"; passed = ($platformPromptFailures.Count -eq 0); detail = $(if ($platformPromptFailures.Count -eq 0) { "$($platformPromptRows.Count) platform prompts" } else { $platformPromptFailures -join "; " }) }
        [PSCustomObject]@{ name = "platform-results-summarized"; passed = ($platformResultFailures.Count -eq 0); detail = $(if ($platformResultFailures.Count -eq 0) { "$($platformResults.total_cases) platform result rows summarized; all platforms perfect: $($platformResults.all_platforms_perfect)" } else { $platformResultFailures -join "; " }) }
    )

    if ($CheckDefaultTargets) {
        $checks += [PSCustomObject]@{
            name = "default-targets-contain-shared-skills"
            passed = ($targetFailures.Count -eq 0)
            detail = $(if ($targetFailures.Count -eq 0) { "Claude/Codex/Agents default targets contain all shared skills" } else { "$($targetFailures.Count) default targets missing skills" })
        }
    }

    [PSCustomObject]@{
        skill_count = $skillNames.Count
        eval_count = $cases.Count
        checks = $checks
        target_checks = $targetChecks
        passed = (@($checks | Where-Object { -not $_.passed }).Count -eq 0)
    }
}

$iterations = New-Object System.Collections.Generic.List[object]
$overallPassed = $true

for ($i = 1; $i -le $Repeat; $i++) {
    Write-Host "Quality gate iteration $i of $Repeat"

    $commands = @(
        Invoke-GateCommand -Name "Audit-Skills" -Command { & $AuditSkills }
        Invoke-GateCommand -Name "Audit-SkillTriggers" -Command { & $AuditTriggers }
        Invoke-GateCommand -Name "Test-SkillRouting" -Command { & $Python $RoutingTest --evals (Join-Path $DocsDir "trigger-evals.json") --skills $SkillsDir --out-dir $DocsDir }
        Invoke-GateCommand -Name "Export-SkillManifest" -Command { & $ManifestExport }
        Invoke-GateCommand -Name "Export-PlatformValidationPack" -Command { & $ValidationExport }
        Invoke-GateCommand -Name "Summarize-PlatformValidation" -Command {
            if ($RequireRealPlatformComplete) {
                & $ValidationSummary -RequireComplete
            } else {
                & $ValidationSummary
            }
        }
    )

    $commandFailed = @($commands | Where-Object { -not $_.passed }).Count -gt 0
    $artifactCheck = $null
    if (-not $commandFailed) {
        $artifactCheck = Test-GateArtifacts -CheckDefaultTargets:(-not $SkipDefaultTargetCheck) -RequireRealPlatformComplete:$RequireRealPlatformComplete
    } else {
        $artifactCheck = [PSCustomObject]@{
            skill_count = 0
            eval_count = 0
            checks = @([PSCustomObject]@{ name = "commands"; passed = $false; detail = "One or more commands failed." })
            target_checks = @()
            passed = $false
        }
    }

    $iterationPassed = (-not $commandFailed) -and $artifactCheck.passed
    if (-not $iterationPassed) {
        $overallPassed = $false
    }

    $iterations.Add([PSCustomObject]@{
        iteration = $i
        passed = $iterationPassed
        commands = $commands
        artifact_check = $artifactCheck
    })

    if ($StopOnFirstFailure -and -not $iterationPassed) {
        break
    }
}

$iterationArray = @($iterations.ToArray())

$report = [PSCustomObject][ordered]@{
    schema_version = 1
    generated_at = (Get-Date).ToString("s")
    source_root = $Root
    repeat_requested = $Repeat
    repeat_completed = $iterationArray.Count
    passed = $overallPassed
    require_real_platform_complete = [bool]$RequireRealPlatformComplete
    note = "This gate proves local structure, trigger descriptions, proxy routing, manifest consistency, and default local target coverage. It does not prove real app internal routing; use REAL_PLATFORM_VALIDATION_MATRIX.md for that."
    iterations = $iterationArray
}

$report | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $GateJson -Encoding UTF8

$md = New-Object System.Collections.Generic.List[string]
$md.Add("# Skill Quality Gate Report")
$md.Add("")
$md.Add("Generated: $($report.generated_at)")
$md.Add("")
$md.Add("- Overall result: $(if ($overallPassed) { 'PASS' } else { 'FAIL' })")
$md.Add("- Iterations requested: $Repeat")
$md.Add("- Iterations completed: $($iterations.Count)")
$md.Add("- Require real platform complete: $([bool]$RequireRealPlatformComplete)")
$md.Add(('- Source root: `{0}`' -f $Root))
$md.Add("")
$md.Add("This gate verifies local structure, trigger descriptions, proxy routing, manifest consistency, and default local target coverage. It does not prove real app internal routing.")
$md.Add("")
foreach ($iteration in $iterations) {
    $md.Add("## Iteration $($iteration.iteration): $(if ($iteration.passed) { 'PASS' } else { 'FAIL' })")
    $md.Add("")
    $md.Add("### Commands")
    $md.Add("")
    $md.Add("| Command | Result | Seconds |")
    $md.Add("| --- | --- | ---: |")
    foreach ($command in $iteration.commands) {
        $md.Add("| $($command.name) | $(if ($command.passed) { 'PASS' } else { 'FAIL' }) | $($command.duration_seconds) |")
    }
    $md.Add("")
    $md.Add("### Artifact Checks")
    $md.Add("")
    $md.Add("| Check | Result | Detail |")
    $md.Add("| --- | --- | --- |")
    foreach ($check in $iteration.artifact_check.checks) {
        $detail = ([string]$check.detail) -replace "\|", "\|"
        $md.Add("| $($check.name) | $(if ($check.passed) { 'PASS' } else { 'FAIL' }) | $detail |")
    }
    if ($iteration.artifact_check.target_checks.Count -gt 0) {
        $md.Add("")
        $md.Add("### Default Target Checks")
        $md.Add("")
        $md.Add("| Target | Result | Skill count | Missing | Path |")
        $md.Add("| --- | --- | ---: | ---: | --- |")
        foreach ($target in $iteration.artifact_check.target_checks) {
            $md.Add(('| {0} | {1} | {2} | {3} | `{4}` |' -f $target.platform, $(if ($target.passed) { 'PASS' } else { 'FAIL' }), $target.skill_count, $target.missing_count, $target.path))
        }
    }
    $md.Add("")
}

$md.Add("## Files")
$md.Add("")
$md.Add('- JSON: `docs/quality-gate-report.json`')
$md.Add('- Markdown: `docs/QUALITY_GATE_REPORT.md`')
$md.Add('- Real platform matrix: `docs/REAL_PLATFORM_VALIDATION_MATRIX.md`')

Set-Content -LiteralPath $GateMarkdown -Value $md -Encoding UTF8

Write-Host ""
Write-Host "Quality gate report written to: $GateMarkdown"
Write-Host "Quality gate JSON written to: $GateJson"

if ($overallPassed) {
    Write-Host "Skill quality gate passed."
    exit 0
}

Write-Host "Skill quality gate failed. See docs/QUALITY_GATE_REPORT.md"
exit 1
