# JIRA IT-499
# Requires PowerShell 5.0 or better.  https://www.microsoft.com/en-us/download/details.aspx?id=50395
# Assumes sourceDir will have only 1 file.
# Requires our environment variable toolkit

#Run as admin if needed.  Last check did not reuqire this so it is commented out.
#If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
#
#{
#$arguments = "& '" + $myinvocation.mycommand.definition + "'"
#Start-Process powershell -Verb runAs -ArgumentList $arguments
#Break
#}


#PS Community Extensions for zipping as we can't use normal commands.
$PSVersionTable.PSVersion
Install-Module -Name Pscx -Force -AllowClobber

#Global Variables
$sourceDir =  "\\fileserver\customer\\Deliverables\XSLT\Prerelease"
$workingDir = "C:\ops\temp\IT499"
$ingestDir = "C:\ops\temp\IT499\ingest"
$digestDir = "C:\ops\temp\IT499\digest"
$deliverDir = "C:\ops\temp\IT499\deliver"
$stagingDir = "C:\ops\temp\IT499\staging"

# STEP ---- PREPARE Environment
if (Test-Path $workingDir) {
Remove-Item $workingDir -Force -Recurse
}
New-Item -ItemType directory -Path $workingDir -Force

if (Test-Path $ingestDir) {
Remove-Item $ingestDir -Force -Recurse
}
New-Item -ItemType directory -Path $ingestDir -Force

if (Test-Path $digestDir) {
Remove-Item $digestDir -Force -Recurse
}
New-Item -ItemType directory -Path $digestDir -Force

if (Test-Path $deliverDir) {
Remove-Item $deliverDir -Force -Recurse
}
New-Item -ItemType directory -Path $deliverDir -Force

if (Test-Path $stagingDir) {
Remove-Item $stagingDir -Force -Recurse
}
New-Item -ItemType directory -Path $stagingDir -Force


# STEP ---- Copy the files from FTP server to a local work adirectory.
$source = "X:\"
$password  = ConvertTo-SecureString -AsPlainText -Force -String $Env:admin
$user = "corp\admin"
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user,$password
New-PSDrive -Name X -PSProvider FileSystem -Root $sourceDir -Credential $credentials
Copy-Item $source\*.* -Destination $ingestDir
Get-PSDrive X | Remove-PSDrive

# STEP ---- Rename the XZIP to ZIP
#be aware that rest of the code is assuming that we will have only 1 zip file here.
Get-ChildItem -Path $ingestDir *.xzip | rename-item -newname { [io.path]::ChangeExtension($_.name, "zip") }

# STEP ---- Extract File
#again, warning about number of files; we expect only 1 zip file.
#Get-ChildItem -Path $ingestDir -Filter *.zip | Expand-Archive -DestinationPath $digestDir -Force
Write-Host "60 destDir and ingestDir" $digestDir and $ingestDir
Expand-Archive -Path $ingestDir\*.zip -OutputPath $digestDir -Force

# STEP ---- Cleanup the first, and then subsequent, zip archives.
Move-Item -Path $digestDir\Transforms\*.xsl -Destination $stagingDir

# STEP ---- Compress our zip archives.
Get-ChildItem -Path $stagingDir |
Foreach-Object {
	$filename =  [System.IO.Path]::GetFileNameWithoutExtension($_.fullname)
	Move-Item -Path $stagingDir\$filename.xsl -Destination $digestDir\Transforms\$filename.xsl
	#Due to problems with certain files on extract, I am changing to a legacy zip class.
	#Compress-Archive -Path $digestDir\* -DestinationPath $deliverDir\$filename.zip
	$source = "$digestDir"
	$destination = "$deliverDir\$filename.zip"
	Write-Host "Destination: " $destination
	#After the above, I tried the Powershell 2.0 method with better but still problematic results.  Mac would extract the file as a flat archive.
	#If(Test-path $destination) {Remove-item $destination}
	#Add-Type -assembly "system.io.compression.filesystem"
	#[io.compression.zipfile]::CreateFromDirectory($Source, $destination)
	#Gave up and went 3rd party.
	Get-ChildItem -Recurse $source |
	Write-Zip -OutputPath $destination -IncludeEmptyDirectories -EntryPathRoot $source
	Remove-Item -Path $digestDir\Transforms\$filename.xsl
}

# STEP ---- Rename everything back to xzip
Get-ChildItem -Path $deliverDir *.zip | rename-item -newname { [io.path]::ChangeExtension($_.name, "xzip") }

# STEP ---- Deliver our files.
$destination = "Z:\IT499"
$password  = ConvertTo-SecureString -AsPlainText -Force -String $Env:admin
$user = "corp\admin"
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user,$password
New-PSDrive -Name Z -PSProvider FileSystem -Root $sourceDir -Credential $credentials
if (Test-Path $destination) {
Remove-Item $destination -Force -Recurse
}
New-Item -ItemType directory -Path $destination -Force
Copy-Item $deliverDir\*.* -Destination $destination
Get-PSDrive Z | Remove-PSDrive
