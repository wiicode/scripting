$WPSVersion = cmd.exe /C systeminfo | findstr /C:"OS Name"

If ($WPSVersion -Match "2008 R2" -eq "True")
{
cd \\192.168.168.1\gpo\PS_Upgrade
.\WS_2008R2_x64.msu /quiet
}
ElseIf ($WPSVersion -Match "2012 R2" -eq "True")
{
cd \\192.168.168.1\gpo\PS_Upgrade
.\WS_2012R2_x64.msu /quiet
}
ElseIf ($WPSVersion -Match "2012" -eq "True")
{
cd \\192.168.168.1\gpo\PS_Upgrade
.\WS_2012_x64.msu /quiet
} 
