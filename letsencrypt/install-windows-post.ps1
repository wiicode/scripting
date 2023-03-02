#restarts Apache2.4 Service but accepts array and controls stop and start independently allowing for ordered restarts.

$PSVersionTable.PSVersion
$ErrorActionPreference = "Continue"
$global:currentfile = $MyInvocation.MyCommand.Name #you can use Path to get the full path.
$global:logfile = "c:\ops\logs\restart_apache.txt" #this is where we keep our stuff.
Start-Transcript -Path $logfile
Write-Host "-.. . -... ..- --.DEBUG Callsign: ALPHA"
Write-Host "-.. . -... ..- --.DEBUG Logfile:" $logfile

$global:loopcount = 0
$global:ServiceName = 'Apache2.4'  #we use this to determine what to do

$s2 = "Apache2.4"


# ARRAY ################################
$servicesliststop = @("$s2")
$servicesliststart = @("$s2")

########################################
#  FUNCTIONS BEGIN BELOW THIS AREA
########################################


function service-start($ServiceName)
{
    #usage service-start "$Service"

$arrService = Get-Service -Name $ServiceName

    while ($arrService.Status -ne 'Running')
    {

        Start-Service $ServiceName
        write-host $arrService.status
        write-host 'Service starting'
        Start-Sleep -seconds 60
        $arrService.Refresh()
        if ($arrService.Status -eq 'Running')
        {
            Write-Host 'Service is now Running'
        }

    }

}

function service-stop($ServiceName, $delay)
{
    #usage service-stop "$Service"

$arrService = Get-Service -Name $ServiceName

    while ($arrService.Status -ne 'Stopped')
    {

        Stop-Service $ServiceName
        write-host $arrService.status
        write-host 'Service stopping'
        Start-Sleep -seconds $delay
        $arrService.Refresh()
        if ($arrService.Status -eq 'Stopped')
        {
            Write-Host 'Service is now Stopped'
        }

    }

}


function timer
{
    #we're waiting for 2 minutes and also logging it for sanity.
    $timeout = new-timespan -Minutes 1
    $sw = [diagnostics.stopwatch]::StartNew()
    $arrService = Get-Service -Name $ServiceName
    while ($sw.elapsed -lt $timeout){
        if (test-path $logfile){
            $loopcount++
            write-host "Loop number $loopcount"
            return
            }
        start-sleep -seconds 5
    }

    write-host "Timed out, now this is where the reall work begins."
}

#####
#
#
# MAIN BODY
#
#
#####

timer



#Stop everything that is not stopped already
foreach ($srv in $servicesliststop) {

    if ($srv.Status -ne 'Stopped')
        {
            Write-Host "DEBUG: $srv needs stopping"
            Write-Host "DEBUG: $srv sending stop command"
            service-stop "$srv" "60"
            Write-Host "DEBUG: $srv stop costep completed"
        }

    Else
        {

            Write-Host "DEBUG: nothing to do"

         }

#end of loop
 }

#Start everything that is not running already
foreach ($srv in $servicesliststart) {

    if ($srv.Status -ne 'Running')
        {
            Write-Host "DEBUG: $srv needs stopping"
            service-start "$srv" "60"
        }

    Else
        {

            Write-Host "DEBUG: nothing to do"

         }

#end of loop
 }