<#
-----
corp C drive cleanup script.  Custom made to our needs but can run on any Windows Server.
Removes stale log files, including that stored in corp installations
-----
#>

$PSVersionTable.PSVersion
$ErrorActionPreference = "Continue"
$global:logfile = "c:\ops\logs\RMM_file_cleanup.txt"
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
Start cleanup of common C drive paths
-----
#>

function cleanCdrive
{

  Write-Host "-.. . -... ..- --.DEBUG : Default deletions"
  $folders = @("C:\Windows\Temp\*", "C:\Documents and Settings\*\Local Settings\temp\*", "C:\Users\*\Appdata\Local\Temp\*", "C:\Users\*\Appdata\Local\Microsoft\Windows\Temporary Internet Files\*", "C:\Windows\SoftwareDistribution\Download", "C:\Windows\System32\FNTCACHE.DAT", "C:\Windows\Logs\*","c:\Windows\ServiceProfiles\AppData\Local\Temp\*"),"c:\Windows\ServiceProfiles\LocalService\AppData\Local\Temp\*"
  foreach ($folder in $folders) {Remove-Item $folder -force -recurse  -verbose -ErrorAction SilentlyContinue}



} #END FUNCTION

<#
-----
Start cleanup of corp common items in corp Workgroup.
-----
#>

function cleancorp
{
  Write-Host "-.. . -... ..- --.DEBUG : corp Sequence start"
        If (Test-Path $corp)
          {

            #Tomcat detect.
            Write-Host "-.. . -... ..- --.DEBUG : Collecting install paths"
            $corp_reg = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\corp\Server8"
            $corp_reg_32bit = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\corp\Server8"
            If (Test-Path $corp_reg)
              {
                Write-Host "-.. . -... ..- --.DEBUG : Commence corp Workgroup 64bit Cleanup"
                Write-Host "-.. . -... ..- --.DEBUG : CLEANING FILES IN $tomcat_path"
                $tomcat_path = (Get-ItemProperty -LiteralPath "$corp_reg").'Path'
                $folders = @("$tomcat_path\temp\*", "$tomcat_path\logs\*", "$tomcat_path\Server\temp\*", "$tomcat_path\Server\logs\*")
                foreach ($folder in $folders) {Remove-Item $folder -force -recurse -verbose -ErrorAction SilentlyContinue}

            }

          ElseIf (Test-Path $corp_reg_32bit)
            {
              Write-Host "-.. . -... ..- --.DEBUG : Commence corp Workgroup 32bit Cleanup"
              Write-Host "-.. . -... ..- --.DEBUG : CLEANING FILES IN $tomcat_path"
              $tomcat_path = (Get-ItemProperty -LiteralPath "$corp_reg_32bit").'Path'
              $folders = @("$tomcat_path\temp\*", "$tomcat_path\logs\*", "$tomcat_path\Server\temp\*", "$tomcat_path\Server\logs\*")
              foreach ($folder in $folders) {Remove-Item $folder -force -recurse -verbose -ErrorAction SilentlyContinue}

            }

          ElseIf ($corp_tomcat_env_test -eq $True)
            {
              Write-Host "-.. . -... ..- --.DEBUG : Commence corp Cloud cleanup."
              Write-Host "-.. . -... ..- --.DEBUG : CLEANING FILES IN $tomcat_path"
              $corp_tomcat_path = (get-item env:tomcat_path).Value
              $folders = @("$corp_tomcat_path\temp\*", "$corp_tomcat_path\logs\*", "$tomcat_path\Server\temp\*", "$tomcat_path\Server\logs\*")
              foreach ($folder in $folders) {Remove-Item $folder -force -recurse -verbose -ErrorAction SilentlyContinue}

            }

          Else
            {

              #do nothing

            }

      }



} #End Function

<#
-----
MAIN CODE
-----
#>


#Call Functions
cleanCdrive
cleancorp



Write-Host "-.. . -... ..- --.DEBUG : Arrived at the end!"
Stop-Transcript
exit 0
