$path = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*'
Get-ItemProperty -Path $path | Select-Object -Property PSChildName, ProfileImagePath
