<#
-----
corp Harvester version 0.1.4
This script will collect corp installation information and output it to a file.
It should run on the corp Server installation and any InDesign Engines being used.

This script collects the following information into a single text file.
-----
#>

$PSVersionTable.PSVersion
$ErrorActionPreference = "Continue"
$global:currentfile = $MyInvocation.MyCommand.Path
$global:logfile = "$currentfile.txt"
$global:corp = "c:\ProgramData\corp"

<#
-----
Start Logging
-----
#>
Start-Transcript -path $logfile
Write-Host "-.. . -... ..- --.DEBUG Callsign: ALPHA"
Write-Host "-.. . -... ..- --.DEBUG Logfile:" $logfile
<#
-----
Set Global  Variables
-----
#>

<#
-----
INDESIGN SERVER
-----
#>

  $idsregkey = 'HKLM:\SYSTEM\CurrentControlSet\Services\InDesignServerService x64'
  If (Test-Path $idsregkey) {

    Write-Host "DEBUG: OK! Adobe InDesign Server Service was found."
    $regkey = Get-ItemProperty -Path $idsregkey -Name "ImagePath"
    $value = $regkey.ImagePath
    $path = $value.Replace("`"","")
    $folder = Split-Path -Path $path
    $global:idsMajorVersion = (Get-Item "$folder\InDesignServer.exe").VersionInfo.FileMajorPart
    $global:idsLocation = $folder

    $ids_path_exe = "$idsLocation\InDesignServer.exe"
    $ids_exe_version = [System.Diagnostics.FileVersionInfo]::GetVersionInfo("$ids_path_exe").FileVersion

           Write-Host " "
           Write-Host " ---------------------               --------------------- "
           Write-Host " ---------------------               --------------------- "
           Write-Host " --------------------- SECTION START --------------------- "
           Write-Host " ---------------------               --------------------- "
           Write-Host " ---------------------               --------------------- "
           Write-Host " "
           Write-Host " * * * * * * * * * * * * * "
           Write-Host "InDesign Collector:"
           Write-Host " * * * * * * * * * * * * * "
           Write-Host "-t-> InDesign Server Version:" $ids_exe_version
           Write-Host "-t-> InDesign Server Directory:" $idsLocation
           Write-Host " "
           Write-Host " ---------------------               --------------------- "
           Write-Host " "
           Write-Host " * * * * * * * * * * * * * "
           Write-Host "InDesign Fonts List: "
           Write-Host " * * * * * * * * * * * * * "
           $fonts = "$idsLocation\Fonts"
           If (Test-Path $fonts) {
              Write-Host "-t-> InDesign Server Fonts Directory:" $fonts
              #Get size of Adobe Font folder, manifest retrieval is not reliable
              $ids_fontsize = "{0:N2} MB" -f ((Get-ChildItem "$fonts" -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
              Write-Host "-t-> InDesign Server Fonts take up this much space:" $ids_fontsize
              Get-ChildItem "$idsLocation\Fonts" -Attributes -Force -EA 0 !Directory -Recurse | Format-Table Name, LastWriteTime, Directory
            }

           Write-Host " "
           Write-Host " ---------------------               --------------------- "
           Write-Host " "
           Write-Host " * * * * * * * * * * * * * "
           Write-Host "-t-> InDesign Server Plugins List"
           Write-Host " * * * * * * * * * * * * * "
           Get-ChildItem "$idsLocation\Plug-Ins" -Dir | Format-Table Name, LastWriteTime
           Write-Host " "
           Write-Host " ---------------------               --------------------- "
           Write-Host " "
           Write-Host " * * * * * * * * * * * * * "
           Write-Host "-t-> InDesign Server Scripts List:"
           Write-Host " * * * * * * * * * * * * * "
           Get-ChildItem "$idsLocation\Scripts" -File | Format-Table Name, LastWriteTime
           Write-Host " "
           Write-Host " ---------------------               --------------------- "
           Write-Host " "
           Write-Host " * * * * * * * * * * * * * "
           Write-Host "-t-> InDesign Server Presets are:"
           Write-Host " * * * * * * * * * * * * * "
           Get-ChildItem "$idsLocation\Resources\Adobe PDF\settings\mul" -File | Format-Table Name, LastWriteTime
           Write-Host " "
           Write-Host " ---------------------               --------------------- "
           Write-Host " "
           Write-Host " * * * * * * * * * * * * * "
           Write-Host "-t-> InDesign Server Services include :"
           Write-Host " * * * * * * * * * * * * * "
           Get-WmiObject Win32_Service -Filter "name='InDesignServerService x64'" | Format-Table Name, DisplayName, State, StartMode, StartName
           Write-Host " "
           Write-Host " ---------------------               --------------------- "
           Write-Host " "
           Write-Host " * * * * * * * * * * * * * "
           Write-Host "-t-> InDesign Server Processes include :"
           Write-Host " * * * * * * * * * * * * * "
           #Get-Process -Name *indesign* | Format-Table -Property Path,Name,Id,Company
           Get-Process -Name *indesign* | Format-Table -Property Name, ID, @{Name='WorkingSet';Expression={($_.WorkingSet64/1MB)}}
           Get-Process -Name InDesign* | ForEach-Object { Get-NetTCPConnection -OwningProcess $_.Id -ErrorAction SilentlyContinue }
           Write-Host " "
           Write-Host " ---------------------               --------------------- "
           Write-Host " "

           $idsLicDirectory = "C:\ProgramData\regid.1986-12.com.adobe"
           If (Test-Path $idsLicDirectory)
               {
                 $adobeIdsLicenseFiles = @(Get-ChildItem -Path $idsLicDirectory\*.swidtag)
                 foreach ($idsLicFile in $adobeIdsLicenseFiles)
                 {
                   Write-Host " * * * * * * * * * * * * * "
                   Write-Host "-t-> InDesign License Readout for file $idsLicFile"
                   Write-Host " * * * * * * * * * * * * * "
                   Write-Host " "
                   Write-Host "*****************************************************************"
                   Write-Host "*********************** FILE OUTPUT *****************************"
                   Write-Host "*****************************************************************"
                   Write-Host " "
                   Get-Content $idsLicFile | select -Last 7
                   Write-Host " "
                   Write-Host "*****************************************************************"
                   Write-Host "************************** END **********************************"
                   Write-Host "*****************************************************************"
                   Write-Host " "
                 }
               }

           Else
               {

                   Write-Host "-.. . -... ..- --.DEBUG No .swidtag"

                }



            Write-Host " "
            Write-Host " ---------------------             --------------------- "
            Write-Host " ---------------------             --------------------- "
            Write-Host " ---------------------             --------------------- "
            Write-Host " --------------------- SECTION END --------------------- "
            Write-Host " ---------------------             --------------------- "
            Write-Host " ---------------------             --------------------- "
            Write-Host " ---------------------             --------------------- "
            Write-Host " "

 }
   Else
       {

          Write-Host "-.. . -... ..- --.DEBUG InDesign Server search complete."

        }

<#
-----
corp SERVER
-----
#>


Write-Host " "
Write-Host " ---------------------               --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " --------------------- SECTION START --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " ---------------------               --------------------- "
Write-Host " "
Write-Host " ---------------------               --------------------- "
Write-Host " "
Write-Host " * * * * * * * * * * * * * "
Write-Host "-t-> corp Installations include:"
Write-Host " * * * * * * * * * * * * * "
#SLOWLOOKUP
Get-WmiObject -Class Win32_Product -Filter "Name LIKE 'corp%'" | Format-Table -Property Name,Version
Write-Host " "

If (Test-Path $corp)
    {
        #Suepruser harvest.
        $fsu_path = "$corp\Superuser.properties"
        $fsu_values = Get-Content $fsu_path | Out-String | ConvertFrom-StringData
        Write-Host " ---------------------               --------------------- "
        Write-Host " "
        If ($fsu_values.SUPERUSER_PASSWORD -eq 99999999)
          {
              Write-Host " * * * * * * * * * * * * * "
              Write-Host "-t-> Superuser password has NOT been changed! // DEBUG:" $fsu_values.SUPERUSER_PASSWORD
              Write-Host " * * * * * * * * * * * * * "
            }
        Else
          {
              Write-Host " * * * * * * * * * * * * * "
              Write-Host "-t-> Superuser password has been changed, you are doing grrreat!"
              Write-Host " * * * * * * * * * * * * * "
          }
        Write-Host " "

        #Filestore harvest.
        $fs_path = "$corp\Filestore.properties"
        $fs_values = Get-Content $fs_path | Out-String | ConvertFrom-StringData
        Write-Host " ---------------------               --------------------- "
        Write-Host " "
        Write-Host " * * * * * * * * * * * * * "
        Write-Host "-t-> File Store is located at:" $fs_values.FILESTORE_LOC
        Write-Host " * * * * * * * * * * * * * "
        #SOWLOOKUP
        $fs_size = "{0:N2} MB" -f ((Get-ChildItem $fs_values.FILESTORE_LOC -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
        Write-Host " * * * * * * * * * * * * * "
        Write-Host "-t-> File Store size is:" $fs_size
        Write-Host " * * * * * * * * * * * * * "
        Write-Host " "

        #LDAP harvest.
        $ldap_path = "$corp\Ldap.properties"
        $ldap_values = Get-Content $ldap_path | Out-String | ConvertFrom-StringData
        Write-Host " ---------------------               --------------------- "
        Write-Host " "
        Write-Host " * * * * * * * * * * * * * "
        Write-Host "-t-> LDAP is in use:" $ldap_values.LDAP_IN_USE
        Write-Host " * * * * * * * * * * * * * "
        Write-Host " "
        Write-Host "-t-> LDAP is in use:" $ldap_values.LDAP_URL
        Write-Host "-t-> LDAP is in use:" $ldap_values.LDAP_SEARCH_BASE
        Write-Host "-t-> LDAP is in use:" $ldap_values.LDAP_AUTHENTICATION_NAME
        Write-Host "-t-> LDAP is in use:" $ldap_values.LDAP_ADDITIONAL_SEARCH_FILTER
        Write-Host "-t-> LDAP is in use:" $ldap_values.LDAP_USERNAME_ATTRIBUTE
        Write-Host "-t-> LDAP is in use:" $ldap_values.LDAP_DISPLAY_NAME_ATTRIBUTE
        Write-Host " "

        #Tomcat harvest.
        $corp_reg = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\corp\Server8"
        $corp_reg_32bit = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\corp\Server8"
        If (Test-Path $corp_reg)
          {

            $tomcat_path = (Get-ItemProperty -LiteralPath "$corp_reg").'Path'
            $jre = & cmd /c "$tomcat_path\JRE\bin\java.exe -version 2>&1"
            $java = & cmd /c "java -version 2>&1"

            Write-Host " ---------------------               --------------------- "
            Write-Host " "
            Write-Host " * * * * * * * * * * * * * "
            Write-Host "-t-> corp Tomcat is installed to:" $tomcat_path
            Write-Host "-t-> Installed JRE is:" $jre
            Write-Host "-t-> Installed system JAVA is:" $java
            Write-Host "-t-> corp Plugins installed are:"
            Get-ChildItem $tomcat_path\Server\webapps -File | Format-Table Name, LastWriteTime
            Write-Host " * * * * * * * * * * * * * "
            Write-Host " "

          }
        Else
          {

            $tomcat_path = (Get-ItemProperty -LiteralPath "$corp_reg_32bit").'Path'
            $jre = & cmd /c "$tomcat_path\JRE\bin\java.exe -version 2>&1"
            $java = & cmd /c "java -version 2>&1"

            Write-Host " ---------------------               --------------------- "
            Write-Host " "
            Write-Host "-t-> corp Tomcat is installed to:" $tomcat_path
            Write-Host "-t-> Installed JRE is:" $jre
            Write-Host "-t-> Installed system JAVA is:" $java
            Write-Host "-t-> corp Plugins installed are:"
            Get-ChildItem $tomcat_path\Server\webapps -File | Format-Table Name, LastWriteTime
            Write-Host " "

          }


        #license harvest.
        Write-Host " "
        Write-Host " ---------------------               --------------------- "
        Write-Host " "
        Write-Host "-t-> corp Licenses:"
        Write-Host " "
        Write-Host "*****************************************************************"
        Write-Host "*********************** FILE OUTPUT *****************************"
        Write-Host "*****************************************************************"
        Write-Host " "
        Get-Content $corp\licenses.json
        Write-Host " "
        Write-Host "*****************************************************************"
        Write-Host "************************** END **********************************"
        Write-Host "*****************************************************************"
        Write-Host " "

        #engines harvest.
        Write-Host " "
        Write-Host " ---------------------               --------------------- "
        Write-Host " "
        Write-Host "-t-> corp Engines:"
        Write-Host " "
        Write-Host "*****************************************************************"
        Write-Host "*********************** FILE OUTPUT *****************************"
        Write-Host "*****************************************************************"
        Write-Host " "
        Get-Content $corp\engines.json
        Write-Host " "
        Write-Host "*****************************************************************"
        Write-Host "************************** END **********************************"
        Write-Host "*****************************************************************"
        Write-Host " "



        #Log harvest.
        Write-Host " "
        Write-Host " ---------------------               --------------------- "
        Write-Host " "
        Write-Host "-t-> corp TPSS Log's last few lines:"
        Write-Host " "
        Write-Host "*****************************************************************"
        Write-Host "*********************** FILE OUTPUT *****************************"
        Write-Host "*****************************************************************"
        Write-Host " "
        Get-Content $corp\TPSS.log | select -Last 42
        Write-Host " "
        Write-Host "*****************************************************************"
        Write-Host "************************** END **********************************"
        Write-Host "*****************************************************************"
        Write-Host " "



    }

    Else
        {

           Write-Host "-.. . -... ..- --.DEBUG InDesign Server search complete."

         }

Write-Host " "
Write-Host " ---------------------             --------------------- "
Write-Host " ---------------------             --------------------- "
Write-Host " ---------------------             --------------------- "
Write-Host " --------------------- SECTION END --------------------- "
Write-Host " ---------------------             --------------------- "
Write-Host " ---------------------             --------------------- "
Write-Host " ---------------------             --------------------- "
Write-Host " "

<#
-----
Stop Logging
-----
#>
Stop-Transcript
