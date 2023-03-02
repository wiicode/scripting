#Requires -RunAsAdministrator
<#
ABOUT THIS SCRIPT:
WARNING -- this script cannot run unattended. Needs to run as Asmin from Windows.
This script upgrades existing XAMPP installations and takes into account our existing setups.
Unfortunatley, the --prefix parameter does not work as expected and we cannot target a folder.
As a result this installation goes to a slightly different locationa and uses sumlinks.
Do not change any values during the install.
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
$global:logfile = "c:\ops\logs\$currentfile.txt" #this is where we keep our stuff.
Start-Transcript -Path $logfile
Write-Host "-.. . -... ..- --.DEBUG Callsign: ALPHA"
Write-Host "-.. . -... ..- --.DEBUG Logfile:" $logfile


$global:url = "https://downloadsapachefriends.global.ssl.fastly.net/7.4.4/xampp-windows-x64-7.4.4-0-VC15-installer.exe"
$global:installer = "xampp-windows-x64-7.4.4-0-VC15-installer.exe"
$global:xampplist = @("C:\PAYLOAD\xampp")

<#
MAIN BODY
#>
Write-Host " "
Write-Host "-.. . -... ..- --.DEBUG: Main Body."
Write-Host " ---------------------               --------------------- "
Write-Host " --------------------- SECTION START --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " "
Write-Host "DEBUG: Downloading XAMPP"

$output_dir = "c:\ops\temp\work\xampp\"
$output = "$output_dir\$installer"
$start_time = Get-Date
$timestamp = get-date -uformat "%Y-%m-%d@%H-%M-%S"





foreach ($xampp in $xampplist) {
    Write-Host "Trying XAMPP:" $xampp

    If (Test-Path $xampp)
        {
            Write-Host "Detected installation in $xampp"
            #download
            New-Item -ItemType directory -Path $output_dir -Force
            Invoke-WebRequest -Uri $url -OutFile $output
            Write-Output "DEBUG: Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

            #prepare
            Stop-Service -Name "Apache2.4"
            Copy-Item  $xampp\apache\conf\httpd.conf -Destination $output_dir -Force
            Copy-Item  $xampp\apache\conf\extra\httpd-ssl.conf -Destination $output_dir -Force
            Copy-Item  $xampp\apache\conf\extra\httpd-vhosts.conf -Destination $output_dir -Force
            cmd.exe /c "c:\PAYLOAD\xampp\apache\bin\httpd.exe -k uninstall"
            Move-Item -Path $xampp -Destination $xampp-$timestamp

            if (Test-Path c:\xampp) {
                Remove-Item c:\xampp -Force -Recurse
            }

            #install
            Start-Process -FilePath "$output" -ArgumentList "--prefix C:\PAYLOAD\xampp --disable-components xampp_mysql,xampp_filezilla,xampp_mercury,xampp_tomcat,xampp_phpmyadmin,xampp_webalizer,xampp_sendmail --launchapps 0 --unattendedmodeui minimal" -Wait
            CMD /c mklink /D "$xampp" c:\xampp
            Copy-Item  $output_dir\httpd.conf -Destination $xampp\apache\conf -Force
            Copy-Item  $output_dir\httpd-ssl.conf -Destination $xampp\apache\conf\extra -Force
            Copy-Item  $output_dir\httpd-vhosts.conf -Destination $xampp\apache\conf\extra -Force
            cmd.exe /c "c:\PAYLOAD\xampp\apache\bin\httpd.exe -k install"




            #finalize
            Start-Service -Name "Apache2.4"
        }

    Else
        {

            Write-Host "Did not find Xampp on this attempt."

         }

#end of loop
 }













Write-Host " "
Write-Host " ---------------------               --------------------- "
Write-Host " --------------------- SECTION   END --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " "


<#
corp auditing block, end. It should be part of every script. 
#>
Write-Host "-.. . -... ..- --.DEBUG : Arrived at the end!"
Stop-Transcript
exit 0