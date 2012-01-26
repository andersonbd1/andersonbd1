

function addpath([string] $newPath) {
	$env:PATH += ";$newPath"
}

function shorten-path([string] $path) {
	$loc = $path.Replace($HOME, '~')
	# remove prefix for UNC paths
	$loc = $loc -replace '^[^:]+::', ''
	# make path shorter like tabs in Vim,
	# handle paths starting with \\ and . correctly
	return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2')
}

function prompt {
# our theme
	$cdelim = [ConsoleColor]::DarkCyan
	$chost = [ConsoleColor]::Green
	$cloc = [ConsoleColor]::Cyan

	write-host "$([char]0x0A7) " -n -f $cloc
	write-host ([net.dns]::GetHostName()) -n -f $chost
	write-host ' {' -n -f $cdelim
	write-host (shorten-path (pwd).Path) -n -f $cloc
	write-host '} $' -n -f $cdelim
	return ' '
}


function start-devbox {
    vmwindow -file "C:\Users\u0018893\Virtual Machines\WestlawClientW7SPK1.vmcx"
}

function update-env {	
	$currentLocation = Get-Location
	$batlocation = $(Get-ChildItem -path \\eg-nas-a02\pub3011\SCM\Builds\WLClient\Development\Client | 
				where {$_.psIsContainer -eq $true} |
				sort -property Name -descending |
				select -first 1).FullName
    Start-Process "$psHome\powershell.exe" -ArgumentList '-command "Stop-Service W3SVC"'  -verb runAs -Wait             
	Write-Host "Running tsetup from $batlocation`n"    
    Set-Location $batLocation
    Start-Process ".\TSetup.exe" -ArgumentList "developerInstall.inf", "C:\" -verb runAs -Wait 
    Set-Location $currentLocation	
}
				

function update-wl{ 
	update "$/Superior/Westlaw_Client/Development/West.Westlaw.Web" "D:\data"
	update "$/Superior/Westlaw_Stylesheets" "D:\xsl"
	
}

function update([string] $tfsMap, [string]$path) {	
	$currentLoc = Get-Location
	Set-Location $path
	TF.exe get $tfsMap /recursive
	Set-Location $currentLoc
}

function update-dev {
    update-env
	update-wl	
}

# Setup the PATH environment variable.
addpath("$env:windir\system32")
addpath("$env:windir")
addpath("$env:windir\system")
addpath("C:\Program Files (x86)\Vim\vim73")
addpath("C:\Windows\Microsoft.NET\Framework\v2.0.50727")
addpath("C:\Windows\Microsoft.NET\Framework\v3.5")
addpath("C:\Windows\Microsoft.NET\Framework\v4.0.30319")
addpath("C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE")
addpath("C:\Program Files (x86)\Java\jre6\bin")
addpath("C:\users\rjwadi\bin")
addpath("C:\Program Files (x86)\KeePass Password Safe 2")
addpath("C:\Program Files\TrueCrypt")
addpath("C:\Program Files (x86)\Microsoft F#\v4.0");
addpath("C:\Program Files (x86)\IIS Express");
addpath("C:\Users\u0018893\bin");

Set-alias perf systempropertiesperformance.exe
Import-Module PSCX
Set-alias msb4 "C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild.exe"