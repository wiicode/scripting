<#
ABOUT THIS SCRIPT:
Purpose and author. Add relevant dates and JIRA entries if able.
#>

<#
SECURITY STATEMENT:
List any concerns over this script.
#>

<#
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
Enable Maintenance Mode on this server
#>

<#
MAIN BODY
#>
Write-Host " "
Write-Host "-.. . -... ..- --.DEBUG: Main Body."
Write-Host " ---------------------               --------------------- "
Write-Host " --------------------- SECTION START --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " "

$Username = ""
$Password = ""

$group = "Administrators"

$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
$existing = $adsi.Children | where {$_.SchemaClassName -eq 'user' -and $_.Name -eq $Username }

if ($existing -eq $null) {

    Write-Host "Creating new local user $Username."
    & NET USER $Username $Password /add /y /expires:never

    Write-Host "Adding local user $Username to $group."
    & NET LOCALGROUP $group $Username /add

}
else {
    Write-Host "Setting password for existing local user $Username."
    $existing.SetPassword($Password)
}

Write-Host "Ensuring password for $Username never expires."
& WMIC USERACCOUNT WHERE "Name='$Username'" SET PasswordExpires=FALSE

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