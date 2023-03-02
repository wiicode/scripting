<#
-----
corp Cloud Filestore version 0.1.1
Designed to run on corp Cloud Bronze servers, this script will collect FileStore usage information.   It can be adapted to Workgroup.
-----
#>
$ErrorActionPreference = "SilentlyContinue"
$corpcustomers = "C:\ProgramData\corp\corp-customers"



If (Test-Path $corpcustomers)
    {
      Write-Host " "
      Write-Host " --------------------- SECTION START --------------------- "
      Write-Host " "
      Write-Host " Reminder: Bronze Customers get 100GB"
      Write-Host " "
      Write-Host " "
      Write-Host " "

      $array = @()
      $filestorefiles = @(Get-ChildItem -Path $corpcustomers\Filestore.properties -Recurse | ? { $_.FullName -inotmatch 'zzz_archive' })
      foreach ($custFS in $filestorefiles)
      {
        #Filestore harvest.
        $fs_values = Get-Content $custFS | Out-String | ConvertFrom-StringData
        $fs_size = "{0:N2} GB" -f ((Get-ChildItem $fs_values.FILESTORE_LOC -Recurse | Measure-Object -Property Length -Sum -ErrorAction Continue).Sum / 1GB)
        $customer =  ($fs_values.FILESTORE_LOC -split '/')[-1]
        #Write-Host " Filestore: " $fs_values.FILESTORE_LOC
        #Write-Host " Size:" $fs_size
        #Write-Host " "
        $array += [pscustomobject]@{ Customer = $customer; Size = $fs_size }
      }

      $array | Format-Table Customer, Size -Auto
    }

Else
    {

        Write-Host "-.. . -... ..- --.DEBUG No corp-Customers found."

     }

Write-Host " "
Write-Host " --------------------- SECTION END --------------------- "
Write-Host " "
