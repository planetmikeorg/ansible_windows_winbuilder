$invocationPath = Split-Path -Path $MyInvocation.MyCommand.Path -Parent

Invoke-Expression (Join-Path $invocationPath "Build-Boot.ps1")
Invoke-Expression (Join-Path $invocationPath "Build-WIM.ps1")