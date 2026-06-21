$ErrorActionPreference = 'Stop'

$scriptPath = Join-Path $PSScriptRoot 'tools\Export-PlatformValidationPack.ps1'
& $scriptPath @args
if ($LASTEXITCODE -ne $null -and $LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
