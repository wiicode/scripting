<#
ABOUT THIS SCRIPT:
Purpose and author. Add relevant dates and JIRA entries if able.
#>

<#
SECURITY STATEMENT:
List any concerns over this script.
#>

<#
corp auditing block. It should be part of every script. 
#>
$PSVersionTable.PSVersion
$ErrorActionPreference = "Continue"
$global:currentfile = $MyInvocation.MyCommand.Name #you can use Path to get the full path.
$global:logfile = "c:\ops\logs\$currentfile.txt" #this is where we keep our stuff.
Start-Transcript -Path $logfile
Write-Host "-.. . -... ..- --.DEBUG Callsign: ALPHA"
Write-Host "-.. . -... ..- --.DEBUG Logfile:" $logfile

<#
MAIN BODY
#>
Write-Host " "
Write-Host "-.. . -... ..- --.DEBUG: Main Body."
Write-Host " ---------------------               --------------------- "
Write-Host " --------------------- SECTION START --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " "



Write-Host " "
Write-Host " ---------------------               --------------------- "
Write-Host " --------------------- SECTION   END --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " "


<#
corp auditing block, end. It should be part of every script. 
#>
Write-Host "-.. . -... ..- --.DEBUG : Arrived at the end!"
Stop-Transcript
exit 0