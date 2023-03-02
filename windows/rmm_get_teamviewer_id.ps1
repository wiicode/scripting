$PSVersionTable.PSVersion
$ErrorActionPreference = "Continue"
$global:logfile = "c:\ops\logs\teamviewerdetection.txt"
<#
-----
Start Logging
-----
#>
Start-Transcript -path $logfile
Write-Host "-.. . -... ..- --.DEBUG Callsign: ALPHA"
Write-Host "-.. . -... ..- --.DEBUG Logfile:" $logfile


$TeamViewerVersions = @('6','7','8','9','10','11','12','13','14','')

If([IntPtr]::Size -eq 4) {
    $RegPath='HKLM:\SOFTWARE\TeamViewer'
} else {
    $RegPath='HKLM:\SOFTWARE\Wow6432Node\TeamViewer'
}

$ErrorActionPreference= 'silentlycontinue'

foreach ($TeamViewerVersion in $TeamViewerVersions) {
    If ((Get-Item -Path $RegPath$TeamViewerVersion).GetValue('ClientID') -ne $null) {
        $TeamViewerID=(Get-Item -Path $RegPath$TeamViewerVersion).GetValue('ClientID')
    }
}

Write-Host "The Teamviewer ID of $ENV:COMPUTERNAME is '$TeamViewerID'"



<#
-----
Stop Logging
-----
#>
Stop-Transcript
