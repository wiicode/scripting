param ([string]$parameter0='',[string]$parameter1='',[string]$parameter2='')
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
#$global:currentfile = $MyInvocation.MyCommand.Name #you can use Path to get the full path.



$global:url = "https://url/s/vkii6qfigo9f1u5/TeamViewer_Host_32bit.msi?dl=1"
$global:installdir = "TeamViewer2021"
$global:installer = "TeamViewer_Host_32bit.msi"
$global:installerlo = "TeamViewer_Host_32bit.msi.txt"
$global:type = $parameter0
$global:configid = $parameter1
$global:token = $parameter2
<#
MODIFIED LOGGER
#>
$global:logfile = "C:\ops\temp\work\$installdir\TeamViewer_Host_32bit.msi.powershell.txt" #this is where we keep our stuff.
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
Write-Host "DEBUG: Downloading"

$output_dir = "c:\ops\temp\work\$installdir\"
$output = "$output_dir\$installer"
$start_time = Get-Date

New-Item -ItemType directory -Path $output_dir -Force
Invoke-WebRequest -Uri $url -OutFile $output
Write-Output "DEBUG: Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"


#install
$arglist1 = "/i c:\ops\temp\work\$installdir\$installer /qn CUSTOMCONFIGID=$configid APITOKEN=$token ASSIGNMENTOPTIONS=`"--grant-easy-access --reassign`" /L*v c:\ops\temp\work\$installdir\$installerlo"
Write-Host "DEBUG: Argument List is:  $arglist1"
Start-Process msiexec.exe -ArgumentList $arglist1 -Verb runAs -Wait

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