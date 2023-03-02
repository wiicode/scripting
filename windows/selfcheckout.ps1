#git clone https://hidden:$key@github.com/hidden/hidden.git
#token is for corp Systems.
$key=$env:hidden
Set-Location -Path C:\ops\scipts -PassThru
git clean -f
git reset --hard
git pull https://hidden:$key@github.com/hidden/hidden.git
#test, test2, test3, test4, test5
#remote change
$varName = "hostname_public"
$varNameDisplay = (get-item env:$varName).Value
$ipV4 = Test-Connection -ComputerName (hostname) -Count 1  | Select -ExpandProperty IPV4Address
$ipV4message = $ipV4.IPAddressToString
#Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
#Install-Module -Name Posh-SYSLOG -SkipPublisherCheck -Force
#$message = "Hi! This is $varNameDisplay.  I just completed a GIT check.  My private IP is $ipV4message."
#Send-SyslogMessage -Server 'logs3.papertrailapp.com' -Message $message -Severity 'Debug' -Facility 'syslog' -UDPPort 10167
if ([System.Diagnostics.EventLog]::SourceExists("PaperTrail") -eq $False) {
    New-EventLog -LogName Application -Source "PaperTrail"
    Write-EventLog -LogName "Application" -Source "PaperTrail" -EntryType Error -EventID 9987 -Message "Hi! This is $varNameDisplay.  I just completed a GIT check.  My private IP is $ipV4message." -RawData 10,20
}
Else
{
    Write-EventLog -LogName "Application" -Source "PaperTrail" -EntryType Error -EventID 9987 -Message "Hi! This is $varNameDisplay.  I just completed a GIT check.  My private IP is $ipV4message." -RawData 10,20
}