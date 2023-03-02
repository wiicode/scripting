# to list all variables you can "Get-ChildItem Env:"
$exists_filestore = Test-Path Env:\FILESTORE
$filestore = $Env:FILESTORE

$filestoreclean = $filestore -creplace '\\', ''
Write-Host "Verify this filestore before you continue: " $filestoreclean
Read-Host -Prompt "Continue..."
[string]$customername=Read-Host "Name this company (do not use spaces)"

If ($exists_filestore -eq $True)
{
Write-Host "Filestore Found, starting account creation."

#Create all the files we need.
New-Item -ItemType Directory -Force -Path C:\ProgramData\corp\corp-customers\$customername
New-Item -ItemType Directory -Force -Path C:\ProgramData\corp\corp-customers\$customername\corp-actions
New-Item -ItemType Directory -Force -Path C:\ProgramData\corp\corp-customers\$customername\corp-scripts
New-Item -ItemType Directory -Force -Path C:\ProgramData\corp\corp-customers\$customername\corp-groups

#Copy over all the settings we can copy.
Copy-Item C:\ops\scipts\work\conf\cloud\corp\*.properties C:\ProgramData\corp\corp-customers\$customername
Copy-Item C:\ops\scipts\work\conf\cloud\corp\*.json C:\ProgramData\corp\corp-customers\$customername
Copy-Item C:\ops\scipts\work\conf\cloud\corp\Users.txt C:\ProgramData\corp\corp-customers\$customername
Copy-Item C:\ops\scipts\work\conf\cloud\corp\Extensions.txt C:\ProgramData\corp\corp-customers\$customername

#Create SYMLINK for Extensions.txt
#retired because we cannot use symlink in 8.3.0
#cmd.exe /C mklink C:\ProgramData\corp\corp-customers\$customername\Extensions.txt "C:\ops\scipts\work\conf\cloud\corp\Extensions.txt"

#Create the filestore
New-Item -ItemType Directory -Force -Path $filestoreclean\$customername

#Update the properties with the customer name and location of filestore.
(Get-Content C:\ProgramData\corp\corp-customers\$customername\Filestore.properties).replace('[CUSTOMERNAME]', $customername) | Set-Content C:\ProgramData\corp\corp-customers\$customername\Filestore.properties
(Get-Content C:\ProgramData\corp\corp-customers\$customername\Filestore.properties).replace('[FILESTORE]', $filestore) | Set-Content C:\ProgramData\corp\corp-customers\$customername\Filestore.properties
}

Else {Write-Host "ERROR: Filestore Environment Variable is missing. This system cannot run script."}


Read-Host -Prompt "Press Enter to exit"
