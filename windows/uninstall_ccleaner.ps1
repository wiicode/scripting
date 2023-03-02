if (Get-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
    Where-Object DisplayName -match CCleaner -OutVariable Results) {
    & "$($Results.InstallLocation)\uninst.exe" /S
}

if (Get-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
    Where-Object DisplayName -match CCleaner -OutVariable Results) {
    & "c:\Corporate\CC\uninst.exe" /S
}
