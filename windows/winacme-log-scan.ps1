Get-Item "C:\ProgramData\win-acme\acme-v02.api.letsencrypt.org\Log\*.*" | Foreach {
    $lastupdatetime = $_.LastWriteTime
    $nowtime = get-date
    if (($nowtime - $lastupdatetime).totalhours -le 72) {
        Write-Host "File modified within last 72 hours "$_.name 
        Write-Host " - "
        Write-Host "------------ EXCEPTION BLOCK START -- any response is a problem for WIN-ACME"
        Write-Host ""
        $logname = $_.Name
        $output = ($_ | Select-String "AcmeProtocolException")
        if ([System.Diagnostics.EventLog]::SourceExists("PaperTrail") -eq $False) {
            New-EventLog -LogName Application -Source "PaperTrail"
            Write-EventLog -LogName "Application" -Source "PaperTrail" -EntryType Error -EventID 9987 -Message "WIN-ACME $output." -RawData 10, 20
        }
        Else {
            Write-EventLog -LogName "Application" -Source "PaperTrail" -EntryType Error -EventID 9987 -Message "WIN-ACME $output." -RawData 10, 20
        }
        Write-Host ""
        Write-Host "------------ EXCEPTION BLOCK END "


        
    }
    else {

    }
}