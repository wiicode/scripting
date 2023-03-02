<#
ABOUT THIS SCRIPT:
Purpose and author. Add relevant dates and JIRA entries if able.
#>

<#
SECURITY STATEMENT:
List any concerns over this script.
#>

<#
Auditing block. It should be part of every script.
#>
$PSVersionTable.PSVersion
$ErrorActionPreference = "Continue"
$global:currentfile = $MyInvocation.MyCommand.Name #you can use Path to get the full path.
$global:logfile = "c:\ops\logs\$currentfile.txt" #this is where we keep our stuff.
$global:OSVersion = (get-itemproperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName

Start-Transcript -Path $logfile
Write-Host "-.. . -... ..- --.DEBUG Callsign: ALPHA"
Write-Host "-.. . -... ..- --.DEBUG Logfile:" $logfile


$global:url = "https://url/s//windmsetup-rlg.zip?dl=1"
$global:installer = "windmsetup-rlg.zip"

<#
MAIN BODY
#>
Write-Host " "
Write-Host "-.. . -... ..- --.DEBUG: Main Body."
Write-Host " ---------------------               --------------------- "
Write-Host " --------------------- SECTION START --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " "
Write-Host "DEBUG: Downloading mspagent"

$output_dir = "c:\ops\temp\mspagent"
$output = "$output_dir\$installer"
$start_time = Get-Date



If($OSVersion -eq "Windows 7 Professional")
    {
        Write-Host "-.. . -... ..- --.DEBUG : Downloading Files."
        New-Item -ItemType directory -Path $output_dir -Force
        Import-Module BitsTransfer
        Start-BitsTransfer -Source $url -Destination $output
        Write-Host "-.. . -... ..- --.DEBUG : EXTRACTING ZIP file with 7-ZIP"
        $7z = "C:\Program Files\7-zip\7z.exe"
        Start-Process $7z -ArgumentList "x $output_dir\windmsetup-rlg.zip -oc:\ops\temp\mspagent\windmsetup-rlg" -Wait
    }
#Microsoft Windows 8.1 Pro
Elseif($OSVersion -eq "Microsoft Windows 8.1 Pro")
    {
        Write-Host "-.. . -... ..- --.DEBUG : Downloading Files."
        New-Item -ItemType directory -Path $output_dir -Force
        Import-Module BitsTransfer
        Start-BitsTransfer -Source $url -Destination $output
        Write-Host "-.. . -... ..- --.DEBUG : EXTRACTING ZIP file with 7-ZIP"
        $7z = "C:\Program Files\7-zip\7z.exe"
        Start-Process $7z -ArgumentList "x $output_dir\windmsetup-rlg.zip -oc:\ops\temp\mspagent\windmsetup-rlg" -Wait
        #Start-Process "C:\Program Files\7-zip\7z.exe" -ArgumentList "x c:\ops\temp\mspagent\windmsetup-rlg.zip -oc:\ops\temp\mspagent\windmsetup-rlg"

    }

Else
    {
        Write-Host "-.. . -... ..- --.DEBUG : Downloading Files."
        New-Item -ItemType directory -Path $output_dir -Force
        Invoke-WebRequest -Uri $url -OutFile $output
        Write-Output "DEBUG: Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
        Write-Host "-.. . -... ..- --.DEBUG : EXTRACTING ZIP file with PowerShell"
        Microsoft.PowerShell.Archive\Expand-Archive -Path $output_dir\windmsetup-rlg.zip -DestinationPath "c:\ops\temp\mspagent\windmsetup-rlg" -Force
    }



#install mspagent
Write-Host "-.. . -... ..- --.DEBUG : Starting MSIEXEC"
Set-Location "c:\ops\temp\mspagent\windmsetup-rlg"
Start-Process msiexec.exe -ArgumentList '/i SetupDM.exe /q' -Verb runAs -Wait


Write-Host " "
Write-Host " ---------------------               --------------------- "
Write-Host " --------------------- SECTION   END --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " "


<#
Auditing block, end. It should be part of every script.
#>
Write-Host "-.. . -... ..- --.DEBUG : Arrived at the end!"
Stop-Transcript
exit 0