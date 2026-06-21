$ErrorActionPreference = 'Stop'

$scriptPath = Join-Path $PSScriptRoot 'tools\Invoke-SkillQualityGate.ps1'
& $scriptPath -RequireRealPlatformComplete @args
if ($LASTEXITCODE -ne $null -and $LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
