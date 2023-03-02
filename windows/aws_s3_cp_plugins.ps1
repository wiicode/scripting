<#
Manipulates corp Server Plugins. Originally constructed a simple BAT file, 
it is being expanded to serve more purposes. Typically called by a 
Scheduled Task, RMM, Event Log entry, or manually.
#>

<#
corp auditing block. It should be part of every script. 
#>
$PSVersionTable.PSVersion
$ErrorActionPreference = "Continue"
$global:currentfile = $MyInvocation.MyCommand.Name
$global:logfile = "c:\ops\logs\$currentfile.txt"
Start-Transcript -Path $logfile
Write-Host "-.. . -... ..- --.DEBUG Callsign: ALPHA"
Write-Host "-.. . -... ..- --.DEBUG Logfile:" $logfile

<#
MAIN BODY
#>
$varNameDisplay = (get-item env:hostname_public).Value
$varNameDisplayCleaned = $varNameDisplay -creplace '\\', ''

If ($varNameDisplayCleaned -eq "ftp.corp.com")
    {
        Write-Host "-.. . -... ..- --.DEBUG : ftp.corp.com"
        <# 
        These are from the admin server, fully ready for public consumption.
        #> 
        aws s3 sync s3://warfiles/all-latest-plugins "m:\corpwarfiles\latest" --profile corpplugins --delete

        <#
        REM These are from the admin server, fully for internal consumption only.
        #> 
        aws s3 sync s3://warfiles "m:\corpwarfiles\archive" --profile corpplugins --delete --exclude "all-latest-plugins/*"
        aws s3 sync s3://warfiles-prerelease/ "m:\corpwarfiles Prerelease" --profile corpplugins --delete

    }

elseif ($varNameDisplayCleaned -eq "staging.corp.net")
    {
        Write-Host "-.. . -... ..- --.DEBUG : staging.corp.net"
        New-Item -ItemType directory -Path c:\ops\temp\corp_plugins\latest -Force
        New-Item -ItemType directory -Path c:\ops\temp\corp_plugins\archive -Force
        New-Item -ItemType directory -Path c:\ops\temp\corp_plugins\prerelease -Force
        New-Item -ItemType directory -Path c:\ops\temp\corp_plugins\qabuilds -Force
        <#
        These are from the admin server, fully ready for public consumption.
        #>
        aws s3 sync s3://warfiles/all-latest-plugins "c:\ops\temp\corp_plugins\latest" --profile corpplugins --delete

        <#
        REM These are from the admin server, fully for internal consumption only.
        #>
        aws s3 sync s3://warfiles "c:\ops\temp\corp_plugins\archive" --profile corpplugins --delete --exclude "all-latest-plugins/*"
        aws s3 sync s3://warfiles-prerelease "c:\ops\temp\corp_plugins\prerelease" --profile corpplugins --delete
        aws s3 sync s3://warfiles "c:\ops\temp\corp_plugins\qabuilds" --profile corpplugins --delete

    }

    elseif ($varNameDisplayCleaned -eq "sandbox.corp.net") 
    {
        Write-Host "-.. . -... ..- --.DEBUG : sandbox.corp.net"
        New-Item -ItemType directory -Path c:\ops\temp\corp_plugins\latest -Force
        <#
        These are from the admin server, fully ready for public consumption.
        #> 
        aws s3 sync s3://warfiles/all-latest-plugins "c:\ops\temp\corp_plugins\latest" --profile corpplugins --delete
    
    }   

    elseif ($varNameDisplayCleaned -eq "cloud.corp.net") 
    {
        Write-Host "-.. . -... ..- --.DEBUG : cloud.corp.net"
        New-Item -ItemType directory -Path c:\ops\temp\corp_plugins\latest -Force
        <#
        These are from the admin server, fully ready for public consumption.
        #>
        aws s3 sync s3://warfiles/all-latest-plugins "c:\ops\temp\corp_plugins\latest" --profile corpplugins --delete
    
    }   
       

elseif ($varNameDisplayCleaned -eq "v8.corp.com")
    {
        Write-Host "-.. . -... ..- --.DEBUG : v8.corp.com"
        New-Item -ItemType directory -Path c:\ops\temp\corp_plugins\latest -Force
        New-Item -ItemType directory -Path c:\ops\temp\corp_plugins\archive -Force
        New-Item -ItemType directory -Path c:\ops\temp\corp_plugins\prerelease -Force
        New-Item -ItemType directory -Path c:\ops\temp\corp_plugins\qabuilds -Force
        <#
        These are from the admin server, fully ready for public consumption.
        #> 
        aws s3 sync s3://warfiles/all-latest-plugins "c:\ops\temp\corp_plugins\latest" --profile corpplugins --delete

        <#
        REM These are from the admin server, fully for internal consumption only.
        #>
        aws s3 sync s3://warfiles "c:\ops\temp\corp_plugins\archive" --profile corpplugins --delete --exclude "all-latest-plugins/*"
        aws s3 sync s3://warfiles-prerelease "c:\ops\temp\corp_plugins\prerelease" --profile corpplugins --delete
        aws s3 sync s3://warfiles "c:\ops\temp\corp_plugins\qabuilds" --profile corpplugins --delete
    
    }

elseif ($varNameDisplayCleaned -eq "example") 
    {
        Write-Host "-.. . -... ..- --.DEBUG : example"
    }

else 
    {
        Write-Host "-.. . -... ..- --.DEBUG : No specific config found, doing a basic sync instead."
        aws s3 sync s3://warfiles/all-latest-plugins "c:\ops\temp\corp_plugins\latest" --profile corpplugins --delete
    }


<#
corp auditing block. It should be part of every script. 
#>
Write-Host "-.. . -... ..- --.DEBUG : Arrived at the end!"
Stop-Transcript
exit 0