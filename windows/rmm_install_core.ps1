<#
ABOUT THIS SCRIPT:
Installs key stuff from the web.
#>

<#
SECURITY STATEMENT:
Installs software.
#>

<#
Auditing block. It should be part of every script.
#>
$PSVersionTable.PSVersion
$ErrorActionPreference = "Continue"
$global:currentfile = $MyInvocation.MyCommand.Name #you can use Path to get the full path.
$global:logfile = "c:\ops\logs\$currentfile.txt" #this is where we keep our stuff.
Start-Transcript -Path $logfile
Write-Host "-.. . -... ..- --.DEBUG Callsign: ALPHA"
Write-Host "-.. . -... ..- --.DEBUG Logfile:" $logfile

function awscli
{
    write-host ("The name of this function is: {0} " -f $MyInvocation.MyCommand)
    #prepare
    $product = "awcli"
    $url = "https://s3.amazonaws.com/aws-cli/AWSCLI64PY3.msi"
    $installer = "awscli.msi"
    $output_dir = "c:\ops\temp\work\$product\"
    $output = "$output_dir\$installer"
    $start_time = Get-Date
    #download
    New-Item -ItemType directory -Path $output_dir -Force
    Invoke-WebRequest -Uri $url -OutFile $output
    Write-Output "DEBUG: Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
    #install
    Start-Process msiexec.exe -ArgumentList "/i c:\ops\temp\work\$product\$installer /q" -Verb runAs -Wait

}

function RMM
{
    write-host ("The name of this function is: {0} " -f $MyInvocation.MyCommand)
    #prepare
    $product = "RMM"
    $url = "hidden"
    $installer = "RMM.msi"
    $output_dir = "c:\ops\temp\work\$product\"
    $output = "$output_dir\$installer"
    $start_time = Get-Date
    #download
    New-Item -ItemType directory -Path $output_dir -Force
    Invoke-WebRequest -Uri $url -OutFile $output
    Write-Output "DEBUG: Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
    #install
    Start-Process msiexec.exe -ArgumentList "/i c:\ops\temp\work\$product\$installer /q" -Verb runAs -Wait

}

function ninite
{
    write-host ("The name of this function is: {0} " -f $MyInvocation.MyCommand)
    #prepare
    $product = "ninite"
    $url = "https://ninite.com/7zip-chrome-correttojdkx8-foxit-notepadplusplus/ninite.exe"
    $installer = "ninite.exe"
    $output_dir = "c:\ops\temp\work\$product\"
    $output = "$output_dir\$installer"
    $start_time = Get-Date
    #download
    New-Item -ItemType directory -Path $output_dir -Force
    Invoke-WebRequest -Uri $url -OutFile $output
    Write-Output "DEBUG: Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
    #install
    Start-Process "c:\ops\temp\work\$product\$installer" -Wait


}

function git
{
    write-host ("The name of this function is: {0} " -f $MyInvocation.MyCommand)
    #prepare
    $product = "git"
    $url = "https://github.com/git-for-windows/git/releases/download/v2.21.0.windows.1/Git-2.21.0-64-bit.exe"
    $installer = "git.exe"
    $output_dir = "c:\ops\temp\work\$product\"
    $output = "$output_dir\$installer"
    $start_time = Get-Date
    #download
    New-Item -ItemType directory -Path $output_dir -Force
    Invoke-WebRequest -Uri $url -OutFile $output
    Write-Output "DEBUG: Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
    #install
    Start-Process  "c:\ops\temp\work\$product\$installer" -ArgumentList '/VERYSILENT /LOADINF=c:\ops\temp\work\git.inf /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS=icons,ext\reg\shellhere,assoc,assoc_sh' -Wait

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

awscli
RMM
ninite
git


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