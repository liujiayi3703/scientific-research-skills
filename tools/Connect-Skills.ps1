param(
    [ValidateSet("Auto", "Link", "Copy")]
    [string]$Mode = "Auto",

    [ValidateSet("Claude", "Codex", "Agents", "Both", "All")]
    [string[]]$Targets = @("Both"),

    [string[]]$CustomTargetDirs = @(),

    [switch]$Force,

    [switch]$SkipManifestExport
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Root = Split-Path -Parent $ScriptDir
$SharedSkills = Join-Path $Root "library\skills"

if (-not (Test-Path $SharedSkills)) {
    throw "Cannot find shared skills directory: $SharedSkills"
}

function Get-TargetDirectories {
    param(
        [string[]]$TargetNames,
        [string[]]$CustomDirs
    )

    $expanded = @()
    foreach ($target in $TargetNames) {
        if ($target -eq "Both") {
            $expanded += "Codex"
            $expanded += "Agents"
        } elseif ($target -eq "All") {
            $expanded += "Claude"
            $expanded += "Codex"
            $expanded += "Agents"
        } else {
            $expanded += $target
        }
    }

    $targetDirs = $expanded | Select-Object -Unique | ForEach-Object {
        switch ($_) {
            "Claude" { Join-Path $env:USERPROFILE ".claude\skills" }
            "Codex" { Join-Path $env:USERPROFILE ".codex\skills" }
            "Agents" { Join-Path $env:USERPROFILE ".agents\skills" }
        }
    }

    foreach ($customDir in $CustomDirs) {
        if ([string]::IsNullOrWhiteSpace($customDir)) {
            continue
        }
        if ([System.IO.Path]::IsPathRooted($customDir)) {
            $targetDirs += $customDir
        } else {
            $targetDirs += (Join-Path (Get-Location) $customDir)
        }
    }

    $targetDirs | Select-Object -Unique
}

function Connect-OneSkill {
    param(
        [string]$Source,
        [string]$DestinationRoot,
        [string]$ConnectMode,
        [switch]$ForceReplace
    )

    $name = Split-Path -Leaf $Source
    $destination = Join-Path $DestinationRoot $name

    if (Test-Path $destination) {
        if (-not $ForceReplace) {
            Write-Host "Skip existing: $destination"
            return
        }
        Remove-Item -LiteralPath $destination -Recurse -Force
    }

    if ($ConnectMode -eq "Copy") {
        Copy-Item -LiteralPath $Source -Destination $destination -Recurse -Force
        Write-Host "Copied: $name -> $DestinationRoot"
        return
    }

    try {
        New-Item -ItemType Junction -Path $destination -Target $Source | Out-Null
        Write-Host "Linked: $name -> $DestinationRoot"
    } catch {
        if ($ConnectMode -eq "Link") {
            throw
        }
        Copy-Item -LiteralPath $Source -Destination $destination -Recurse -Force
        Write-Host "Link failed, copied instead: $name -> $DestinationRoot"
    }
}

function Ensure-AgentNote {
    param([string]$BaseDir)

    $notePath = Join-Path $BaseDir "AGENTS.md"
    $content = @"
# Shared Skills Access

This machine is connected to the shared skills library:

$SharedSkills

When skills are needed, inspect this directory or the local skills directory first.
For apps that cannot scan a skills directory, read this manifest first:
$Root\docs\skills-manifest.json

Run the shared library audit script after changing skills:

$Root\tools\Audit-Skills.ps1
"@

    if (-not (Test-Path $notePath)) {
        Set-Content -LiteralPath $notePath -Value $content -Encoding UTF8
    }
}

$skillDirs = Get-ChildItem -LiteralPath $SharedSkills -Directory | Where-Object {
    Test-Path (Join-Path $_.FullName "SKILL.md")
}

if ($skillDirs.Count -eq 0) {
    throw "No standard skills found in $SharedSkills"
}

$targetDirs = Get-TargetDirectories -TargetNames $Targets -CustomDirs $CustomTargetDirs
foreach ($targetDir in $targetDirs) {
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    Ensure-AgentNote -BaseDir (Split-Path -Parent $targetDir)

    foreach ($skill in $skillDirs) {
        Connect-OneSkill -Source $skill.FullName -DestinationRoot $targetDir -ConnectMode $Mode -ForceReplace:$Force
    }
}

Write-Host ""
Write-Host "Connected $($skillDirs.Count) skills from:"
Write-Host $SharedSkills

$manifestScript = Join-Path $ScriptDir "Export-SkillManifest.ps1"
if (-not $SkipManifestExport -and (Test-Path $manifestScript)) {
    Write-Host ""
    & $manifestScript
}
