$ErrorActionPreference = 'Stop'

$scriptPath = Join-Path $PSScriptRoot 'tools\Connect-Skills.ps1'
& $scriptPath -Targets All @args
if ($LASTEXITCODE -ne $null -and $LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
