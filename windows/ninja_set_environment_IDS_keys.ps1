param ([string]$parameter0='',[string]$parameter1='')
<#
ABOUT THIS SCRIPT:
This script works with "researialize_ids.readiness.ps1" and "reserialize_ids.ps1" to help manage re-activations.
It uses parameter0 for the name of the variable and parameter1 for the value.
We have it in NINJRA 3x for simplicity.
script.ps1 idskey 1155-0000
script.ps1 idsversion 2020
script.ps1 adobe_id karl@corp.com

#>

<#
SECURITY STATEMENT:
Exposes InDesign keys.
#>

<#
Auditing block. It should be part of every script.
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
FUNCTIONS
#>
Function papertrail{

    Write-Host "DEBUG: Running function for Writing EVENTLOG ID 9987"
    $varName = "hostname_public"
    $varNameDisplay = (get-item env:$varName).Value
    $ipV4 = Test-Connection -ComputerName (hostname) -Count 1  | Select -ExpandProperty IPV4Address
    $ipV4message = $ipV4.IPAddressToString
    if ([System.Diagnostics.EventLog]::SourceExists("PaperTrail") -eq $False) {
        New-EventLog -LogName Application -Source "PaperTrail"
        Write-EventLog -LogName "Application" -Source "PaperTrail" -EntryType Error -EventID 9987 -Message "ninjarmm: This is $varNameDisplay.  My private IP is $ipV4message.  I just set ENV:$parameter0 to $parameter1." -RawData 10,20
    }
    Else
    {
        Write-EventLog -LogName "Application" -Source "PaperTrail" -EntryType Error -EventID 9987 -Message "ninjarmm: This is $varNameDisplay.  My private IP is $ipV4message.  I just set ENV:$parameter0 to $parameter1." -RawData 10,20
    }

}

Function setparameter{

    Write-host "DEBUG: Setting the value $parameter0 to $parameter1."

    [Environment]::SetEnvironmentVariable($parameter0, $parameter1, "Machine")

    Write-Host "DEBUG: Done setting parameters."


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



    Write-Host "DEBUG: Setting variables"
    Write-host "DEBUG: Received param0 $parameter0 and param1 $parameter1."
    setparameter
    papertrail




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