# Written by Karl 
$PSVersionTable.PSVersion
$ErrorActionPreference = "Continue"
$global:logfile = "c:\ops\logs\openssl_install.txt"
$global:downloaddir = "c:\ops\temp\openssl"
$global:installer = "$downloaddir\win64openssl.exe"
Start-Transcript -path $logfile -Append
Write-Host "Alpha"
## Edit these as needed ###
$global:url = "https://slproweb.com/download/Win64OpenSSL_Light-1_1_0j.exe"



######## FUNCTION ####################
function download
{
  Write-Host "DEBUG: Downloading Installer"
  $start_time = Get-Date
  New-Item -ItemType directory -Path $downloaddir -Force
  Invoke-WebRequest -Uri $url -OutFile $installer
  Write-Output "DEBUG: Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

}


######## FUNCTION ####################
function install
{
  #call function
    Write-Host "DEBUG: Installing"
    #Unable to use this approach right now because it does not accept
    Start-Process $installer -ArgumentList '/S /norestart' -Wait
  }


######## FUNCTION ####################
function localhost
{
  <#
  openssl req -x509 -out localhost.crt -keyout localhost.key \
    -newkey rsa:2048 -nodes -sha256 \
    -subj '/CN=localhost' -extensions EXT -config <( \
     printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
  #>

    Write-Host "DEBUG: generating self-signed certificate"
    New-Item -ItemType directory -Path "c:\ops\ssl\localhost" -Force
    #Unable to use this approach right now because it does not accept
    Start-Process C:\ops\bin\OpenSSL-Win64\bin\openssl.exe -ArgumentList 'openssl req -x509 -out c:\ops\ssl\localhost\localhost.crt -keyout c:\ssl\localhost\localhost.key -newkey rsa:2048 -nodes -sha256 -subj CN=localhost -extensions EXT -config <( printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")' -Wait
  }



#
#
#
# main body
#
#
#
#start of loop

#download  - presently running from our workper
#install - presently running from our workper
localhost

Stop-Transcript
