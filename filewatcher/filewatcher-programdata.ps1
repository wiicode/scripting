Function Register-Watcher {
    param ($folder)
    $filter = "*.properties" #all files
    $watcher = New-Object IO.FileSystemWatcher $folder, $filter -Property @{ 
        IncludeSubdirectories = $false
        EnableRaisingEvents = $true
    }

    $changeAction = [scriptblock]::Create('
        # This is the code which will be executed every time a file change is detected
        $path = $Event.SourceEventArgs.FullPath
        $name = $Event.SourceEventArgs.Name
        $changeType = $Event.SourceEventArgs.ChangeType
        $timeStamp = $Event.TimeGenerated
        Write-Host "The file $name was $changeType at $timeStamp"
    ')

    Register-ObjectEvent $Watcher -EventName "Changed" -Action $changeAction
}


 $varName = "c:\ProgramData\corp"
 $varExists = Test-Path $varName

  If ($varExists -eq $True)
    {
      $varNameDisplay = "$varName"
      Register-Watcher "$varNameDisplay"

    }
  Else
    {
      Write-Host "   --- MISSING!  $varName"
    }


