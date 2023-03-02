<#
ABOUT THIS SCRIPT:
Written by Karl. Set's up WIN-ACME on target system.
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
$timestamp = get-date -Format yyyyMMdd
$global:logfile = "c:\ops\logs\$currentfile-$timestamp.txt" #this is where we keep our stuff.
Start-Transcript -Path $logfile
Write-Host "-.. . -... ..- --.DEBUG Callsign: ALPHA"
Write-Host "-.. . -... ..- --.DEBUG Logfile:" $logfile

<#
GLOBALS
#>
$global:winacme = "win-acme.v2.1.6.773.x64.pluggable"
$global:winacmesource = "c:\ops\scipts\letsencrypt\win\production"
$global:winacmedest = "c:\ops\$winacme"
$global:xampp = "c:\xampp"

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


   If (Test-Path $xampp)
        {
             Write-Host "Nothing to do, WIN-ACME is already present:" $winacmedest
        }

    else
        {
            Add-Type -AssemblyName PresentationFramework
            Write-Host "WARNING:  XAMPP is out of date.  Message box may be hiding behind this window.  Your installation will abort after you OK the message."
            [System.Windows.MessageBox]::Show('XAMPP Stack is out of date.  Upgrade the stack before running this installer.','XAMPP Installation Out of Date','Ok','Error')
            Stop-Transcript
            exit 0
        }


  Write-Host "Starting installation from:" $winacmesource

    If (Test-Path $winacmedest)
        {
             Write-Host "Nothing to do, WIN-ACME is already present:" $winacmedest
        }

    else
        {
            New-Item -ItemType directory -Path c:\SSL\le 
            Microsoft.PowerShell.Archive\Expand-Archive -Path $winacmesource\$winacme.zip -DestinationPath "$winacmedest" -Force
            Copy-Item  $winacmesource\$winacme\* -Destination $winacmedest -Recurse -Force
            Start-Process -FilePath "$winacmedest\wacs.exe"

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