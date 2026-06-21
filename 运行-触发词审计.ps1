$ErrorActionPreference = 'Stop'

$scriptPath = Join-Path $PSScriptRoot 'tools\Audit-SkillTriggers.ps1'
& $scriptPath @args
if ($LASTEXITCODE -ne $null -and $LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
