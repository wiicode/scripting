$varName = "hostname_public"
$varNameDisplay = (get-item env:$varName).Value
$ipV4 = Test-Connection -ComputerName (hostname) -Count 1  | Select -ExpandProperty IPV4Address
if ([System.Diagnostics.EventLog]::SourceExists("PaperTrail") -eq $False) {
    New-EventLog -LogName Application -Source "PaperTrail"
    Write-EventLog -LogName "Application" -Source "PaperTrail" -EventID 9988 -EntryType Error -Message "This is $varNameDisplay on IP $ipV4. NinjaRMM has written this entry to enable communication verification of NXLog for PaperTrail." -RawData 10,20
}

Else

{
Write-EventLog -LogName "Application" -Source "PaperTrail" -EventID 9988 -EntryType Error -Message "This is $varNameDisplay on IP $ipV4. NinjaRMM has written this entry to enable communication verification of NXLog for PaperTrail." -RawData 10,20
}