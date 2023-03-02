$registryRoot = "HKLM:\SOFTWARE\Policies"
$registryProg = "HKLM:\SOFTWARE\Policies\Google"
$registryPath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
$Name = "CloudManagementEnrollmentToken"
$value = "HIDDEN"

New-Item -Path $registryRoot -Name Google -Force
New-Item -Path $registryProg -Name Chrome -Force
New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType String -Force | Out-Null