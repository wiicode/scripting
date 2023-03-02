<#
ABOUT THIS SCRIPT:
Written by Karl. Set's up WIN-ACME on target system.
#>

<#
SECURITY STATEMENT:
List any concerns over this script.
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
$global:url = "https://url/s//win-acme.v2.1.6.773.x64.pluggable.zip?dl=1"
$global:winacmedir = "win-acme.v2.1.6.773.x64.pluggable"
$global:winacme = "win-acme.v2.1.6.773.x64.pluggable.zip"
$global:winacmesource = "c:\ops\winacme"
$global:winacmedest = "c:\ops\winacme"
$global:winacmezippath = "c:\ops\winacme\$winacme"


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

function download
{
  Write-Host "DEBUG: Downloading..."
  $start_time = Get-Date

  New-Item -ItemType directory -Path $winacmesource -Force
  Invoke-WebRequest -Uri $url -OutFile $winacmezippath
  Write-Output "DEBUG: Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

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



  Write-Host "Starting installation from:" $winacmesource

    If (Test-Path $winacmedest)
        {
             Write-Host "Nothing to do, WIN-ACME is already present:" $winacmedest
            Start-Process -FilePath "$winacmedest\$winacmedir\wacs.exe"
        }

    else
        {
            download
            New-Item -ItemType directory -Path c:\SSL\le
            Microsoft.PowerShell.Archive\Expand-Archive -Path $winacmezippath -DestinationPath "$winacmedest" -Force
            Start-Process -FilePath "$winacmedest\$winacmedir\wacs.exe"

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
#exit 0