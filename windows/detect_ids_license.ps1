New-Item -ErrorAction Ignore c:\ops\logs -type directory
New-Item -ErrorAction Ignore c:\ops\logs\Extension_log.log -type file
Get-ChildItem -Path c:\ProgramData\regid.1986-12.com.adobe -Recurse | Where-Object {$_.BaseName -match "InDesign" -and $_.Extension -eq ".swidtag"} | Format-Table fullname -HideTableHeaders | Out-File c:\ops\logs\Extension_log.log -Force
#list down all AIDS & AID installations
get-childitem c:\ops\logs -include *.log -Filter *IDS_License_Audit_* -recurse -Force | foreach ($_) {remove-item $_.fullname}
#remove any existing/previous log files created earlier

New-Item c:\ops\logs\IDS_License_Audit_.log -ItemType file -Force
#this log records all necessary info as requested

$PHD = Get-ChildItem -Path c:\ops\logs\Extension_log.log | Get-Content | Measure-Object -Line
#this will count the number of AIDS & AID installations
for($cnt = 1; $cnt -le $PHD.Lines; $cnt++)
{
$HD = Get-Content -Path C:\ops\logs\Extension_log.log | Select-Object -Index $cnt
#select installations one-by-one to grab the required info

Add-Content c:\ops\logs\IDS_License_Audit_.log $HD -Force
Get-Content -Path $HD | Where-Object { $_.Contains("<swid:unique_id>") }         | Add-Content c:\ops\logs\IDS_License_Audit_.log -Force
Get-Content -Path $HD | Where-Object { $_.Contains("<swid:activation_status>") } | Add-Content c:\ops\logs\IDS_License_Audit_.log -Force
Get-Content -Path $HD | Where-Object { $_.Contains("<swid:channel_type>") }      | Add-Content c:\ops\logs\IDS_License_Audit_.log -Force
Get-Content -Path $HD | Where-Object { $_.Contains("<swid:serial_number>") }     | Add-Content c:\ops\logs\IDS_License_Audit_.log -Force
Add-Content c:\ops\logs\IDS_License_Audit_.log -Force `n
}
dir c:\ops\logs\IDS_License_Audit_.log | Rename-Item -NewName {$_.BaseName+(Get-Date -f dd-MM-yyyy)+$_.Extension} -Force
#put a time-stamp to the output file

Read-Host -Prompt "Press Enter to exit"