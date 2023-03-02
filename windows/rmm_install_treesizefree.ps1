# Written by Karl 
$PSVersionTable.PSVersion
$ErrorActionPreference = "Continue"
$global:logfile = "c:\ops\logs\treesizefree_install.txt"
$global:downloaddir = "c:\ops\temp\treesizefree"
$global:installer = "$downloaddir\TreeSizeFreeSetup.exe"
Start-Transcript -path $logfile -Append
Write-Host "Alpha"
## Edit these as needed ###
$global:url = "https://downloads.jam-software.de/treesize_free/TreeSizeFreeSetup.exe"



######## MAIN ####################

    Write-Host "DEBUG: Downloading Installer"
    $start_time = Get-Date
    New-Item -ItemType directory -Path $downloaddir -Force
    Invoke-WebRequest -Uri $url -OutFile $installer
    Write-Output "DEBUG: Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

    Write-Host "DEBUG: Installing"
    #Unable to use this approach right now because it does not accept
    Start-Process $installer -ArgumentList '/VERYSILENT /SUPRESSMSGBOXES /NORESTART /CLOSEAPPLICATIONS /LOG=c:\ops\logs\treesizeEXElog.txt' -Wait



Stop-Transcript
