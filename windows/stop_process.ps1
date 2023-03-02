function Stop-Processes {
    param(
        [parameter(Mandatory=$true)] $processName,
                                     $timeout = 5
    )
    [System.Diagnostics.Process[]]$processList = Get-Process $processName -ErrorAction SilentlyContinue

    ForEach ($Process in $processList) {
        # Try gracefully first
        $Process.CloseMainWindow() | Out-Null
    }

    # Check the 'HasExited' property for each process
    for ($i = 0 ; $i -le $timeout; $i++) {
        $AllHaveExited = $True
        $processList | ForEach-Object {
            If (-NOT $_.HasExited) {
                $AllHaveExited = $False
            }                    
        }
        If ($AllHaveExited -eq $true){
            Return
        }
        Start-Sleep 1
    }
    # If graceful close has failed, loop through 'Stop-Process'
    $processList | ForEach-Object {
        If (Get-Process -ID $_.ID -ErrorAction SilentlyContinue) {
            Stop-Process -Id $_.ID -Force -Verbose
        }
    }
}