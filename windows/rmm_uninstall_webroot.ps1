<#
ABOUT THIS SCRIPT:
Purpose and author. Add relevant dates and JIRA entries if able.
#>

<#
SECURITY STATEMENT:
List any concerns over this script.
#>

<#
Auditing block. It should be part of every script.
#>
$PSVersionTable.PSVersion
$ErrorActionPreference = "Continue"
$global:currentfile = $MyInvocation.MyCommand.Name #you can use Path to get the full path.
$global:logfile = "c:\ops\logs\$currentfile.txt" #this is where we keep our stuff.
Start-Transcript -Path $logfile
Write-Host "-.. . -... ..- --.DEBUG Callsign: ALPHA"
Write-Host "-.. . -... ..- --.DEBUG Logfile:" $logfile


$global:url = "https://url/s/wwcb8onh148auvp/wsasme.msi?dl=1"
$global:installdir = "webroot"
$global:installer = "wsasme.msi"
$global:installerlog = "wsasme.msi.log"
$global:attribstring = "c:\ops\temp\work\$installdir\$installer"
#SCROLL BELOW FOR THE MSIEXEC

<#
MAIN BODY
#>
Write-Host " "
Write-Host "-.. . -... ..- --.DEBUG: Main Body."
Write-Host " ---------------------               --------------------- "
Write-Host " --------------------- SECTION START --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " "
Write-Host "DEBUG: Downloading"

$output_dir = "c:\ops\temp\work\$installdir\"
$output = "$output_dir\$installer"
$start_time = Get-Date

New-Item -ItemType directory -Path $output_dir -Force
Invoke-WebRequest -Uri $url -OutFile $output
Write-Output "DEBUG: Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"


#install
Write-Host "DEBUG: Begnning Uninstall"
Start-Process msiexec.exe -ArgumentList /uninstall,c:\ops\temp\work\$installdir\$installer,/qn,/L*v,c:\ops\temp\work\$installdir\$installerlog -Verb runAs -Wait
Write-Host "DEBUG: Ending Uninstall"

Write-Host " "
Write-Host " ---------------------               --------------------- "
Write-Host " --------------------- SECTION   END --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " "


<#
Auditing block, end. It should be part of every script.
#>
Write-Host "-.. . -... ..- --.DEBUG : Arrived at the end!"
Stop-Transcript
exit 0