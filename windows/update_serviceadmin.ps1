#This script will search for admin services and update their passwords.
#copy2
$password = $Env:admin

#Update user account password for all services using that account
#$services = Get-WmiObject win32_service -computer "DEV-01" | Where-Object { $_.StartName -eq "corp\admin" }
$services = Get-WmiObject win32_service | Where-Object { $_.StartName -eq "corp\admin" }
foreach($service in $services)
{$service.change($null,$null,$null,$null,$null,$null,"corp\admin",$password)
if ($service.State -eq "Running") {Restart-Service $service.Name}}

#Update user account password for all services using that account
#$services = Get-WmiObject win32_service -computer "DEV-01" | Where-Object { $_.StartName -eq "corp\admin" }
$services = Get-WmiObject win32_service | Where-Object { $_.StartName -eq "admin@corp.aws" }
foreach($service in $services)
{$service.change($null,$null,$null,$null,$null,$null,"corp\admin",$password)
if ($service.State -eq "Running") {Restart-Service $service.Name}}
