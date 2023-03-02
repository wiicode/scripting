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


$global:url = "https://url/s//ATAcct573629.msi?dl=1"
$global:installdir = "AT"
$global:installer = "ATAcct573629.msi"
$global:installerlo = "ATAcct573629.msi.txt"


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
Write-Host "DEBUG: Argument List is:  $attriblist"
Start-Process msiexec.exe -ArgumentList /uninstall,c:\ops\temp\work\$installdir\ATAcct520460.msi,/qn,/L*v,c:\ops\temp\work\$installdir\ATAcct520460.msi.txt -Verb runAs -Wait
Start-Process msiexec.exe -ArgumentList /i,c:\ops\temp\work\$installdir\$installer,/qn,/L*v,c:\ops\temp\work\$installdir\$installerlo -Verb runAs -Wait


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