$invocationPath = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
. (Join-Path $invocationPath "Globals.ps1")
Invoke-Expression ((Join-Path $invocationPath "Wim.ps1") + (GetBootWimArguments))