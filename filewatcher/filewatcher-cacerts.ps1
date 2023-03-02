Function Register-Watcher {
    param ($folder)
    $filter = "*.*" #all files
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


 $varName = "CACERTS_HOME"
 $varExists = Test-Path Env:\$varName

  If ($varExists -eq $True)
    {
      $varNameDisplay = (get-item env:$varName).Value
      $varNameDisplayCleaned = $varNameDisplay -creplace '\\', ''
      Write-Host "DEBUG: I detected variable $varName with value $varNameDisplay"
      Register-Watcher "$varNameDisplay"

    }
  Else
    {
      Write-Host "   --- MISSING!  $varName"
    }


