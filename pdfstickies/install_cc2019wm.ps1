<#
Created to deploy PDF Stickies for PLANETA
http://kerntiff.com/corp/PDFStickies%20Server%20Win%20CC%202019.zip
#>
$PSVersionTable.PSVersion
$ErrorActionPreference = "Continue"
$global:logfile = "c:\ops\logs\$currentfile.txt"
Start-Transcript -path $logfile -Append
Write-Host "Alpha"
#check if InDesign CC version exists, and figure out the installation directory
#2019, Registry::HKEY_CLASSES_ROOT\CLSID\{CE7A178C-C019-4749-8FA5-45A847E01EAF}\LocalServer32
#2018, Registry::HKEY_CLASSES_ROOT\CLSID\{74812DB7-FA97-43E0-97F5-87D1E47B76E4}\LocalServer32
#2017, Registry::HKEY_CLASSES_ROOT\CLSID\{C62D9F67-2815-4C5D-9754-5CEAA121CDD8}\LocalServer32
#
#Figure out if InDesign is installed and do stuff!
## Edit this as needed
$ids2020 = "Registry::HKEY_CLASSES_ROOT\CLSID\{24F00A91-FA8D-442E-9A2F-146801EA5896}\LocalServer32"
$ids2019 = "Registry::HKEY_CLASSES_ROOT\CLSID\{CE7A178C-C019-4749-8FA5-45A847E01EAF}\LocalServer32"
$ids2018 = "Registry::HKEY_CLASSES_ROOT\CLSID\{74812DB7-FA97-43E0-97F5-87D1E47B76E4}\LocalServer32"
$ids2017 = "Registry::HKEY_CLASSES_ROOT\CLSID\{C62D9F67-2815-4C5D-9754-5CEAA121CDD8}\LocalServer32"
#
## Edit these as needed ###
$global:hotfix_url = "http://kerntiff.com/corp/NFR/PDFStickies%20Server%20Win%20CC%202019%20NFR.zip"
$idsVersions = @("$ids2019") # using one script per server.
#


######## FUNCTION ####################
function download($YYYY)
{
  Write-Host "DEBUG: Downloading hotfix for InDesign CC" $YYYY
  $zip = "PDFStickies.zip"
  $url = "$hotfix_url"
  $global:output_dir = "c:\ops\temp\pdfstickies\$YYYY-zip\"
  $output = "$output_dir\$zip"
  $start_time = Get-Date

  New-Item -ItemType directory -Path $output_dir -Force
  Invoke-WebRequest -Uri $url -OutFile $output
  Write-Output "DEBUG: Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

}


######## FUNCTION ####################
function install($YYYY)
{
  #call function
    Write-Host "DEBUG: Stopping InDesign CC $YYYY"
    Stop-Service -Name "InDesignServerService x64"

  #call function

    #main body
    #production
    Microsoft.PowerShell.Archive\Expand-Archive -Path $output_dir\PDFStickies.zip -DestinationPath "c:\ops\temp\pdfstickies\$YYYY-extracted" -Force
    #if a license exists (maybe this is a reinstall?) then copy it in.

    Copy-Item c:\ops\temp\pdfstickies\$YYYY-extracted\ -Destination "$ids_path_dir\Plug-Ins" -verbose -Force -Recurse


    #call function
    Write-Host "DEBUG: Starting InDesign CC $YYYY"
    Start-Service -Name "InDesignServerService x64"


}



#
#
#
# main body
#
#
#
#start of loop

 foreach ($idsVer in $idsVersions) {
   "$idsVer = " + $idsVer.length
    Write-Host "Trying InDesign:" $idsVer

    If (Test-Path $idsVer)
        {
            Write-Host "$idsFound"
            $ids_path_exe = (Get-ItemProperty -LiteralPath "$idsVer").'(default)'
            Write-Host "DEBUG:" $ids_path_exe
            $global:ids_path_dir = Split-Path -Path $ids_path_exe
            Write-Host "DEBUG:" $ids_path_dir
            $global:idsYYYY = $ids_path_dir.substring($ids_path_dir.length - 4)
            Write-Host "DEBUG:" $idsYYYY

            download "$idsYYYY"
            install "$idsYYYY"




        }

    Else
        {

            Write-Host "Did not find InDesign on this attempt."

         }

#end of loop
 }

Stop-Transcript
