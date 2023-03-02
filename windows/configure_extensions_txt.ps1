#JIRA IT-396
#Restart powershell between runs.
New-Item -ErrorAction Ignore c:\ops\temp -type directory
New-Item -ErrorAction Ignore C:\ops\temp\Extensions_step1_list.txt -type file
New-Item -ErrorAction Ignore C:\ops\temp\Extensions_step2_list.txt -type file
Get-ChildItem -Path C:\ProgramData\corp -Recurse | Where-Object {$_.BaseName -eq "Extensions" -and $_.Extension -eq ".txt"} | Format-Table fullname -HideTableHeaders | Out-File C:\ops\temp\Extensions_step1_list.txt -Force
Get-ChildItem -Path C:\ProgramData\corp -Recurse | Where-Object {$_.BaseName -eq "Extensions" -and $_.Extension -eq ".txt"} | Format-Table fullname -HideTableHeaders | Out-File C:\ops\temp\Extensions_step2_list.txt -Force

$C = Get-ChildItem -Path C:\ops\temp\Extensions_step2_list.txt | Get-Content | Measure-Object -Line
for($counter = 1; $counter -le $C.Lines; $counter++)

{
$X = Get-Content -Path C:\ops\temp\Extensions_step2_list.txt | Select-Object -Index $counter

cmd.exe /C mklink "C:\ops\temp\Extensions.txt" "C:\ops\scipts\conf\cloud\corp\Extensions.txt"
Move-Item C:\ops\temp\Extensions.txt -Destination $X -Force
Get-Content -Path C:\ops\temp\Extensions_step2_list.txt | Select-Object -Index $counter | Add-Content -Path c:\ops\temp\Extensions_step1_list.txt -Force
Add-Content -Path C:\ops\temp\Extensions_step1_list.txt -Value " -- Successfully Replaced" -Force
}
Remove-Item -Path C:\ops\temp\Extensions_step2_list.txt -Force
