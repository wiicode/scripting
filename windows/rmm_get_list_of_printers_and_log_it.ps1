<#
ABOUT THIS SCRIPT:
Purpose and author. Add relevant dates and JIRA entries if able.
#>

<#
SECURITY STATEMENT:
List any concerns over this script.
#>

<#
auditing block. It should be part of every script.
#>
$PSVersionTable.PSVersion
$ErrorActionPreference = "Continue"
$global:currentfile = $MyInvocation.MyCommand.Name #you can use Path to get the full path.
$global:logfile = "c:\ops\logs\$currentfile.txt" #this is where we keep our stuff.
Start-Transcript -Path $logfile
Write-Host "-.. . -... ..- --.DEBUG Callsign: ALPHA"
Write-Host "-.. . -... ..- --.DEBUG Logfile:" $logfile

<#
GLOBALS
#>


<#
FUNCTIONS
#>

    <# function name debug - start #>
    #Write-Host "-.. . -... ..- --.DEBUG function: "
    #write-FunctionName
    <# function name debug# - end #>
Function write-FunctionName
{
    write-host ("The name of this function is: {0} " -f $MyInvocation.MyCommand)
}


<#
MAIN BODY
#>
Write-Host " "
Write-Host "-.. . -... ..- --.DEBUG: Main Body."
Write-Host " ---------------------               --------------------- "
Write-Host " --------------------- SECTION START --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " "

$printers = Get-Printer
$varName = "hostname_public"
$varNameDisplay = (get-item env:$varName).Value
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name Posh-SYSLOG -SkipPublisherCheck -Force

foreach ($printer in $printers) {
    Write-Host "-.. . -... ..- --.DEBUG: $printer"
    Send-SyslogMessage -Server 'logs.papertrailapp.com' -Message "printer found: $printer" -Severity 'Debug' -Facility 'syslog' -UDPPort 11111

}



Write-Host " "
Write-Host " ---------------------               --------------------- "
Write-Host " --------------------- SECTION   END --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " "



<#
auditing block, end. It should be part of every script.
#>
Write-Host "-.. . -... ..- --.DEBUG : Arrived at the end!"
Stop-Transcript
exit 0