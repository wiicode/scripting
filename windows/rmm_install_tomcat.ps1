#Requires -RunAsAdministrator
# Written by Karl 
$PSVersionTable.PSVersion
$ErrorActionPreference = "Continue"
$global:logfile = "c:\ops\logs\tomcat_install_output.txt"
Start-Transcript -path $logfile -Append
Write-Host "Alpha"
## Edit these as needed ###
$global:tomcat_version = "8.5.40" #Example: "3_0_1_058"
$global:tomcat_url = "http://url/Tomcat"
$global:install_dir = "C:\PAYLOAD"
$global:scripts = "C:\ops\scipts"
#


######## FUNCTION ####################
function downloadTomcat
{
    write-host ("The name of this function is: {0} " -f $MyInvocation.MyCommand)
    Write-Host "-.. . -... ..- --.DEBUG: Downloading Tomcat"
    $global:tomcat_zip = "apache-tomcat-$tomcat_version-windows-x64.zip"
    $url = "$tomcat_url/$tomcat_zip"
    $global:output_dir = "c:\ops\temp\tomcat"
    $global:output = "$output_dir\$tomcat_zip"
    $start_time = Get-Date

    New-Item -ItemType directory -Path $output_dir -Force
    Invoke-WebRequest -Uri $url -OutFile $output
    Write-Output "-.. . -... ..- --.DEBUG: Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

}


######## FUNCTION ####################
function installTomcat
{
    write-host ("The name of this function is: {0} " -f $MyInvocation.MyCommand)
    #clean
    Get-ChildItem $install_dir -Force -Filter apache-tomcat* | Remove-Item -Recurse
    #production
    Microsoft.PowerShell.Archive\Expand-Archive -Path $output -DestinationPath $install_dir -Force
    New-Item -Path "c:\ops\temp\tomcat" -Name "manifest.txt" -ItemType "file" -Value "$tomcat_version" -Force

    #set global for the name of this new folder
    $global:latest_tomcat = Get-ChildItem -Path $install_dir | Sort-Object LastAccessTime -Descending | Select-Object -First 1
    Write-Host "-.. . -... ..- --.DEBUG: We installed into:" $latest_tomcat.name

    #set env
    $global:tomcat_home = $install_dir + "\" + $latest_tomcat.name
    Write-Host "-.. . -... ..- --.DEBUG: tomcat_home" $tomcat_home
    $webapps = $tomcat_home + "\webapps"
    Write-Host "-.. . -... ..- --.DEBUG: webapps" $webapps
    $global:corp_PLUGINS = $webapps
    [Environment]::SetEnvironmentVariable("corp_PLUGINS", $corp_PLUGINS, "Machine")
    Write-Host "-.. . -... ..- --.DEBUG: corp_PLUGINS" $corp_PLUGINS
    [Environment]::SetEnvironmentVariable("tomcat_path", $tomcat_home, "Machine")
}

######## FUNCTION ####################
function installTomcatService
{
    write-host ("The name of this function is: {0} " -f $MyInvocation.MyCommand)
}

######## FUNCTION ####################
function configureTomcat
{
    write-host ("The name of this function is: {0} " -f $MyInvocation.MyCommand)
    Copy-Item $scripts\conf\cloud\tomcat\*.* -Destination $install_dir\$latest_tomcat\conf -Force -verbose
    
}

######## FUNCTION ####################
function configurecorp
{
    write-host ("The name of this function is: {0} " -f $MyInvocation.MyCommand)
    
    New-Item -ItemType directory -Path $corp_conf
    New-Item -ItemType directory -Path "$corp_conf\Filestore"
    Copy-Item $scripts\conf\cloud\corp\*.* -Destination "C:\ProgramData\corp" -Force -verbose

    #Update the default property file filestore.
    (Get-Content C:\ProgramData\corp\Filestore.properties).replace('[CUSTOMERNAME]', 'Filestore') | Set-Content C:\ProgramData\corp\Filestore.properties
    (Get-Content C:\ProgramData\corp\Filestore.properties).replace('[FILESTORE]', 'C\:/ProgramData/corp') | Set-Content C:\ProgramData\corp\Filestore.properties
    [Environment]::SetEnvironmentVariable("FILESTORE", "c\:/ProgramData/corp/Filestore", "Machine")
    $global:filestore = "c\:/ProgramData/corp/Filestore"
    $global:filestoreclean = $filestore -creplace '\\', ''
    Write-Host "Verify this filestore before you continue: " $filestoreclean
    New-Item -ItemType Directory -Path $filestoreclean

        
}

######## FUNCTION ####################
#rather than deted JAVA_HOME we are figuring out the location.  This is a double-safety.

function configureJavaCACerts
{

    $java_reg = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Development Kit'
    If (test-path $java_reg)
    {
        Write-Host "-.. . -... ..- --.DEBUG: Amazon Corretto detected."
        $java_ver = (Get-ItemProperty -Path $java_reg -Name "CurrentVersion").CurrentVersion
        Write-Host "-.. . -... ..- --.DEBUG: $java_ver"
        $java_reg_current = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Development Kit\$java_ver"
        $java_ver_current = (Get-ItemProperty -Path $java_reg_current -Name "JavaHome").JavaHome
        Write-Host "-.. . -... ..- --.DEBUG: $java_ver_current"
        $global:javahome = $java_ver_current
        write-host ("The name of this function is: {0} " -f $MyInvocation.MyCommand)
        Write-Host "-.. . -... ..- --.INFO: Corretto Installation sets these variables."
        Copy-Item C:\ops\temp\work\cacerts -Destination "$javahome\jre\lib\security\cacerts" -verbose -Force
    }

    else
    {
        Write-Host "-.. . -... ..- --.WARNING: Amazon Corretto not found. Skipping step."
    }

}


######## FUNCTION ####################
function loadWARs
{
    write-host ("The name of this function is: {0} " -f $MyInvocation.MyCommand)
    Get-ChildItem $corp_PLUGINS -Force -Filter corp-plugin* | Remove-Item -Recurse
    Get-ChildItem $corp_PLUGINS -Force -Filter ROOT* | Remove-Item -Recurse
    Write-Host "-.. . -... ..- --.INFO: Our S3 WAR sync pulls a variety of files, but this may not be desirable for this installation.  We are doing the most conservative install here."
    New-Item -ItemType directory -Path c:\ops\temp\corp_plugins\qabuilds -Force
    aws s3 sync s3://warfiles "c:\ops\temp\corp_plugins\qabuilds" --profile corpplugins --delete
    Copy-Item C:\ops\temp\corp_plugins\qabuilds\cloud_wars\*.* -Destination $corp_PLUGINS -verbose
}

######## FUNCTION ####################
function setPermissions
{
    write-host ("The name of this function is: {0} " -f $MyInvocation.MyCommand)
    $folder1 = "c:\programdata\corp"
    $folder2 = "c:\PAYLOAD"

    $folders = @("$folder1","$folder2") #example, "$folder1","$folder2","$folder3"

    foreach ($folder in $folders)
        {

            $Acl = Get-ACL $folder
            $AccessRule= New-Object System.Security.AccessControl.FileSystemAccessRule("everyone","FullControl","ContainerInherit,Objectinherit","none","Allow")
            $Acl.AddAccessRule($AccessRule)
            Set-Acl $folder $Acl

        }
}

######## FUNCTION ####################
function configurecorpCustomerSample
{
    write-host ("The name of this function is: {0} " -f $MyInvocation.MyCommand)
    Write-Host "-.. . -... ..- --.INFO: Borrowing code from CREATE_CLOUD_CUSTOMER.ps1."
    $customername = "Sample"
    #Create all the files we need.
    New-Item -ItemType Directory -Force -Path C:\ProgramData\corp\corp-customers\$customername
    New-Item -ItemType Directory -Force -Path C:\ProgramData\corp\corp-customers\$customername\corp-actions
    New-Item -ItemType Directory -Force -Path C:\ProgramData\corp\corp-customers\$customername\corp-scripts
    New-Item -ItemType Directory -Force -Path C:\ProgramData\corp\corp-customers\$customername\corp-groups

    #Copy over all the settings we can copy.
    Copy-Item C:\ops\scipts\conf\cloud\corp\*.properties C:\ProgramData\corp\corp-customers\$customername
    Copy-Item C:\ops\scipts\conf\cloud\corp\*.json C:\ProgramData\corp\corp-customers\$customername
    Copy-Item C:\ops\scipts\conf\cloud\corp\Users.txt C:\ProgramData\corp\corp-customers\$customername
    Copy-Item C:\ops\scipts\conf\cloud\corp\Extensions.txt C:\ProgramData\corp\corp-customers\$customername

    $filestoresample = $filestoreclean + "\" + $customername
    New-Item -ItemType Directory -Path $filestoresample

    #Update the properties with the customer name and location of filestore.
    (Get-Content C:\ProgramData\corp\corp-customers\$customername\Filestore.properties).replace('[CUSTOMERNAME]', $customername) | Set-Content C:\ProgramData\corp\corp-customers\$customername\Filestore.properties
    (Get-Content C:\ProgramData\corp\corp-customers\$customername\Filestore.properties).replace('[FILESTORE]', $filestore) | Set-Content C:\ProgramData\corp\corp-customers\$customername\Filestore.properties



}

######## FUNCTION ####################
function installTomcatService
{
    write-host ("The name of this function is: {0} " -f $MyInvocation.MyCommand)
    start-process "cmd.exe" "/c cd $tomcat_home\bin && service.bat install corpTomcat && ping 127.0.0.1 -n 6 > nul" -verb runas
}


####################
#########################################
# main body
#########################################
####################

downloadTomcat
installTomcat
installTomcatService
configureTomcat


$global:corp_conf = "C:\ProgramData\corp"
If (test-path $corp_conf)
{
    Write-Host "-.. . -... ..- --.WARNING: Existing configuration detected.  Not making any changes."

}
else
{
    Write-Host "-.. . -... ..- --.INFO: Looks like this is all fresh, moving forward."
    configurecorp
    configurecorpCustomerSample
}

configureJavaCACerts
loadWARs
setPermissions

#detect existing service
#detect existing install
#ask to overwrite (backup old installation)

Stop-Transcript
