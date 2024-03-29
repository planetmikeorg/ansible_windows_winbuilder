param
(
	[string]$wimFile = $(throw "wimFile is mandatory"),
	[string[]]$features = @(),
	[string]$driversPath,
	[string]$destination = $(throw "destination is mandatory"),
	[bool]$isBoot = $false
)

$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$rootwim = $ScriptDirectory

. (Join-Path $rootwim "Functions.ps1")

if (!(Test-Path $wimFile))
{
	throw "Wim file ${wimFile} does not exist"
}

if (!(Test-Path $destination))
{
	New-Item $destination -ItemType directory
}


if (!([string]::IsNullOrEmpty($driversPath)) -and !(Test-Path $driversPath))
{
	throw "Drivers path ${driversPath} does not exist"
}

$working = Join-Path $rootwim "working"
$bootInjectPath = Join-Path $rootwim "bootInject"
$sourcesPath = Join-Path $working "sources"
$mountPath = Join-Path $working "mnt"
$dismlogPath = Join-Path $working "dism.log"
$adkCabs = @("WinPE-WMI", "WinPE-NetFX", "WinPE-Scripting", "WinPE-PowerShell", "WinPE-StorageWMI", "WinPE-DismCmdlets")

if (!(Test-Path $working))
{
	New-Item $working -ItemType directory
}

if (!(Test-Path $sourcesPath))
{
	New-Item $sourcesPath -ItemType directory
}

if (!(Test-Path $mountPath))
{
	New-Item $mountPath -ItemType directory
}

CleanupMounts $true
CopySourceWim


if ($isBoot)
{	
	MountBootWim
	InjectAdkPackages
	InjectBootFiles
}
else
{
	MountWim
    if (($features -ne $null) -and ($features.Count -gt 0))
    {
	    ActivateWindowsFeatures
    }
}

if (![string]::IsNullOrEmpty($driversPath))
{
	AddDrivers
}

CleanupMounts $false
CopySources