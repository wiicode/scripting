$PSVersionTable.PSVersion
$ErrorActionPreference = "SilentlyContinue"
$global:currentfile = $MyInvocation.MyCommand.Name #you can use Path to get the full path.
$timestamp = get-date -Format yyyyMMdd
$global:logfile = "c:\ops\logs\$currentfile-$timestamp.txt" #this is where we keep our stuff.
Start-Transcript -Path $logfile
Write-Host "-.. . -... ..- --"
Write-Host "The instance-id of this instance is:"
Get-EC2InstanceMetadata -Category InstanceId
$iid = (Get-EC2InstanceMetadata -Category InstanceId)
Get-EC2Tag -Filter @{Name="resource-id";Value="$iid"}
Write-Host "The Windows Computer Name of this instance is:"
$env:COMPUTERNAME
Write-Host "The localhostname of this instance is:"
Get-EC2InstanceMetadata -Category LocalHostname
Write-Host "The publichostname of this instance is:"
Get-EC2InstanceMetadata -Category PublicHostname
Write-Host "The security-group(s) of this instance is:"
Get-EC2InstanceMetadata -Category SecurityGroup
Write-Host "The identity document of this instance is:"
Get-EC2InstanceMetadata -Category IdentityDocument
Write-Host "-.. . -... ..- --"
Stop-Transcript
exit 0