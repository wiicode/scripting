<#
ABOUT THIS SCRIPT:
It's sole job is to start another script, C:\ops\scipts\server_specific\corp_servers\cloud_upgrades\corp_cloud_upgrade_plugins.ps1
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

#this is required to run with elevated privliges.
Write-Host "-.. . -... ..- --.DEBUG Next command is the Start-Process."
Start-Process powershell.exe -ArgumentList '-ExecutionPolicy Unrestricted -File C:\ops\scipts\server_specific\corp_servers\cloud_upgrades\corp_cloud_upgrade_plugins.ps1' -verb RunAs -Wait
Start-Process powershell.exe -ArgumentList '-ExecutionPolicy Unrestricted -File C:\ops\scipts\server_specific\corp_servers\cloud_upgrades\corp_cloud_upgrade_designer_server.ps1' -verb RunAs -Wait
Write-Host "-.. . -... ..- --.DEBUG Previous command was the Start-Process."

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