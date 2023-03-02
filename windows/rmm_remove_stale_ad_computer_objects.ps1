<#
ABOUT THIS SCRIPT:
Removes Computer objects older than value in DaysInactive.
#>

<#
SECURITY STATEMENT:
Could remove important objects, requires domain admin rights.
#>

<#
corp auditing block. It should be part of every script. 
#>
$PSVersionTable.PSVersion
$ErrorActionPreference = "Continue"
$global:currentfile = $MyInvocation.MyCommand.Name #you can use Path to get the full path.
$timestamp = get-date -Format yyyyMMdd
$global:logfile = "c:\ops\logs\$currentfile-$timestamp.txt" #this is where we keep our stuff.
Start-Transcript -Path $logfile
Write-Host "-.. . -... ..- --.DEBUG Callsign: ALPHA"
Write-Host "-.. . -... ..- --.DEBUG Logfile:" $logfile

<#
GLOBALS
#>
$DaysInactive = 365

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
Enable Maintenance Mode on this server
#>
Set-ItemProperty -Path "HKLM:\Software\MMSOFT Design\PC Monitor" -Name "MaintenanceMode" -Value "1"

<#
MAIN BODY
#>
Write-Host " "
Write-Host "-.. . -... ..- --.DEBUG: Main Body."
Write-Host " ---------------------               --------------------- "
Write-Host " --------------------- SECTION START --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " "

$time = (Get-Date).Adddays(-($DaysInactive))
Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -ResultPageSize 2000 -resultSetSize $null -Properties Name, OperatingSystem, SamAccountName, DistinguishedName | remove-adobject -recursive -verbose -confirm:$false

Write-Host " "
Write-Host " ---------------------               --------------------- "
Write-Host " --------------------- SECTION   END --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " "


<#
Disable Maintenance Mode on this server
#>
Set-ItemProperty -Path "HKLM:\Software\MMSOFT Design\PC Monitor" -Name "MaintenanceMode" -Value "0"
<#
auditing block, end. It should be part of every script.
#>
Write-Host "-.. . -... ..- --.DEBUG : Arrived at the end!"
Stop-Transcript
exit 0