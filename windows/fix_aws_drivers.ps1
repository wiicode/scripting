# Change the two lines below as needed, the driver should be for where
# Windows is located (not the system partition) of both the corrupted and working partitions
$brokenDriversParitionLetter = "E:"
$workingDriversParitionLetter = "C:"

$brokenDriversPath =  $brokenDriversParitionLetter + "\Windows\System32\DriverStore\FileRepository"
$workingDriversPath =  $workingDriversParitionLetter + "\Windows\System32\DriverStore\FileRepository"

$allBrokenDrivers = (Get-ChildItem -Path $brokenDriversPath -Recurse | Where-Object { !$PsIsContainer -and [System.IO.Path]::GetFileName($_.Name) -like "xe*.inf" })
$allWorkingDrivers = (Get-ChildItem -Path $workingDriversPath -Recurse | Where-Object { !$PsIsContainer -and [System.IO.Path]::GetFileName($_.Name) -like "xe*.inf" })

# Removing any Amazon old drivers
foreach ($brokenDriver in $allBrokenDrivers)
{
    $message = "`n=======================================`nREMOVING OLD DRIVER " + $brokenDriver.Name.ToUpper() +"`n======================================="
    echo $message
    Remove-WindowsDriver -Path $brokenDriversParitionLetter -Driver $brokenDriver.FullName
}

# Injecting drivers from the working instance partition
foreach ($workingDriver in $allWorkingDrivers)
{
    $message = "`n=======================================`nINJECTING NEW DRIVER " + $workingDriver.Name.ToUpper() +"`n======================================="
    echo $message
    Add-WindowsDriver –Path $brokenDriversParitionLetter –Driver $workingDriver.FullName -ForceUnsigned
}
#end script
