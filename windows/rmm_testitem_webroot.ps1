#This is specifically designed to use with RMM.
#The Error -1 will cause PowerShell to exit with an error state, reporting an error to RMM's task system.
$webroot = Test-Path "hklm:\SOFTWARE\Wow6432Node\WRData"
IF ($webroot -eq "True") {exit 0} ELSE {exit -1}
IF ($webroot -eq "False") {exit -1} ELSE {exit 0}
