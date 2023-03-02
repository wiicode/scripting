<#
-----
This script can run on any Windows server, and will return values for TPSS.log when it finds them.
-----
#>

$PSVersionTable.PSVersion
$ErrorActionPreference = "Continue"
$global:logfile = "c:\ops\logs\RMM_TPSS_log_audit.txt"
$global:corp = "c:\ProgramData\corp"

<#
-----
Start Logging
-----
#>
Start-Transcript -Path $logfile
Write-Host "-.. . -... ..- --.DEBUG Callsign: ALPHA"
Write-Host "-.. . -... ..- --.DEBUG Logfile:" $logfile


<#
-----
Start cleanup of corp common items in corp Workgroup.
-----
#>

function tpssHarvest
{

  $tpssLog = "$corp\TPSS.log"
  Write-Host " ---------------------               --------------------- "
  Write-Host " "
  Write-Host "-t-> TPSS.log Statistics :"
  Get-Content $tpssLog | Measure-Object -Line
  $fs_size = "{0:N2} MB" -f ((Get-ChildItem $tpssLog | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
  Write-Host "-t-> TPSS.log size is :" $fs_size

  Write-Host " "
  Write-Host " ---------------------               --------------------- "


}# FUNCTION END


function checkTPSS
{
  Write-Host "-.. . -... ..- --.DEBUG : corp Sequence start"
        If (Test-Path $corp)
          {
            #Tomcat detect.
            Write-Host "-.. . -... ..- --.DEBUG : Collecting size info."
            tpssHarvest
          }



          Else
            {
            Write-Host "-.. . -... ..- --.DEBUG : TPSS.log not found."
            #do nothing

            }





} #End Function

<#
-----
MAIN CODE
-----
#>


#Call Functions
checkTPSS



Write-Host "-.. . -... ..- --.DEBUG : Arrived at the end!"
Stop-Transcript
exit 0
