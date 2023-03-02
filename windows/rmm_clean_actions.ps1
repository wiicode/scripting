<#
-----
Goes and dumps contents of every corp-actions folder it finds.
-----
#>

$PSVersionTable.PSVersion
$ErrorActionPreference = "Continue"
$global:logfile = "c:\ops\logs\RMM_actions_cleanup.txt"
$global:corp = "c:\ProgramData\corp"
$global:corp_tomcat_env_test = Test-Path Env:\tomcat_path
Write-Host "-.. . -... ..- --.DEBUG corp_tomcat_env_test: $corp_tomcat_env_test"

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
MAIN CODE
-----
#>


    Write-Host "-.. . -... ..- --.DEBUG : Default deletions"
    Get-ChildItem -Path c:\ProgramData\corp\corp-actions -Recurse | Remove-Item -Recurse
    $folders = get-childitem -path c:\ProgramData\corp\corp-customers\* -recurse -filter *corp-actions*
    foreach ($folder in $folders){Get-ChildItem -Path $folder -Recurse | Remove-Item -Recurse}



Write-Host "-.. . -... ..- --.DEBUG : Arrived at the end!"
Stop-Transcript
exit 0
