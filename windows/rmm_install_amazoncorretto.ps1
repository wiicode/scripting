#Requires -RunAsAdministrator
# Written by Karl 
$PSVersionTable.PSVersion
$ErrorActionPreference = "Continue"
$global:logfile = "c:\ops\logs\corretto_install_output.txt"
Start-Transcript -path $logfile -Append
Write-Host "Alpha"
## Edit these as needed ###
$global:correttoMSI = "amazon-corretto-8.202.08.2-windows-x64.msi"
$global:scripts = "C:\ops\scipts"
#


######## corretto ####################
function corretto
{
    write-host ("The name of this function is: {0} " -f $MyInvocation.MyCommand)
    $java_reg = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Development Kit'

    Write-Host "-.. . -... ..- --.DEBUG: Amazon Corretto detected, running repair/update."
    Start-Process msiexec.exe -ArgumentList "/i c:\ops\temp\work\$correttoMSI /qn" -Wait
    $java_ver = (Get-ItemProperty -Path $java_reg -Name "CurrentVersion").CurrentVersion
    Write-Host "-.. . -... ..- --.DEBUG: $java_ver"
    $java_reg_current = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Development Kit\$java_ver"
    $java_ver_current = (Get-ItemProperty -Path $java_reg_current -Name "JavaHome").JavaHome
    Write-Host "-.. . -... ..- --.DEBUG: $java_ver_current"
    $global:javahome = $java_ver_current


}



######## FUNCTION ####################
function configureJavaCACerts
{
    write-host ("The name of this function is: {0} " -f $MyInvocation.MyCommand)
    Write-Host "-.. . -... ..- --.INFO: Corretto Installation sets these variables."
    Copy-Item C:\ops\temp\work\cacerts -Destination "$javahome\jre\lib\security\cacerts" -verbose -Force
}



####################
#########################################
# main body
#########################################
####################


corretto
configureJavaCACerts


Stop-Transcript
