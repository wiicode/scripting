<#
ABOUT THIS SCRIPT:
Karl; installs corp Server site of Malwarebytes.
#>

<#
SECURITY STATEMENT:
Remove WebRoot first.
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


$global:url = "https://url/s//MBAM-corp-Servers-Setup.MBEndpointAgent.Full.msi"
$global:installer = "MBAM-corp-Servers-Setup.MBEndpointAgent.Full.msi"

<#
MAIN BODY
#>
Write-Host " "
Write-Host "-.. . -... ..- --.DEBUG: Main Body."
Write-Host " ---------------------               --------------------- "
Write-Host " --------------------- SECTION START --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " "
Write-Host "DEBUG: Downloading $installer"

$output_dir = "c:\ops\temp\work\"
$output = "$output_dir\$installer"
$start_time = Get-Date

New-Item -ItemType directory -Path $output_dir -Force
Invoke-WebRequest -Uri $url -OutFile $output
Write-Output "DEBUG: Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"


#install 
$string1 = "/i c:\ops\temp\work\$installer /QN"
#$string2 = ""
#$string3 = ""
$argument = $string1
Start-Process msiexec.exe -ArgumentList "$argument" -Verb runAs -Wait
Write-Host "MSIEXEC ran the following arguments:  1) $string1, 2) $string2, 3) $string3"

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