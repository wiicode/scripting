#git clone https://hidden:$key@github.com/hidden/hidden.git

$Location = "C:\ops\scipts\"
New-Item $Location -ItemType "directory"

$key=$env:hidden
Set-Location -Path C:\ops -PassThru
git clone https://$me:$key@github.com/hidden/hidden.git

$pass=$env:admin
Register-ScheduledTask -Xml (get-content '\\access\gitSoftware\GITcheck.xml' | out-string) -TaskName "GIT" -User corp\admin -Password $pass -Force

Read-Host -Prompt "Press Enter to exit"