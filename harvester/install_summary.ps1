#Tomcat harvest.
        $corp_reg = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\corp\Server8"
        $corp_reg_32bit = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\corp\Server8"
        If (Test-Path $corp_reg)
          {

            $tomcat_path = (Get-ItemProperty -LiteralPath "$corp_reg").'Path'
            $jre = & cmd /c "$tomcat_path\JRE\bin\java.exe -version 2>&1"
            $java = & cmd /c "java -version 2>&1"

            Write-Host " ---------------------               --------------------- "
            Write-Host " "
            Write-Host " * * * * * * * * * * * * * "
            Write-Host "-t-> corp Tomcat is installed to:" $tomcat_path
            Write-Host "-t-> Installed JRE is:" $jre
            Write-Host "-t-> Installed system JAVA is:" $java
            Write-Host "-t-> corp Plugins installed are:"
            Get-ChildItem $tomcat_path\Server\webapps -File | Format-Table Name, LastWriteTime
            Write-Host " * * * * * * * * * * * * * "
            Write-Host " "

          }
        elseif (Test-Path $corp_reg_32bit)
          {

            $tomcat_path = (Get-ItemProperty -LiteralPath "$corp_reg_32bit").'Path'
            $jre = & cmd /c "$tomcat_path\JRE\bin\java.exe -version 2>&1"
            $java = & cmd /c "java -version 2>&1"

            Write-Host " ---------------------               --------------------- "
            Write-Host " "
            Write-Host "-t-> corp Tomcat is installed to:" $tomcat_path
            Write-Host "-t-> Installed JRE is:" $jre
            Write-Host "-t-> Installed system JAVA is:" $java
            Write-Host "-t-> corp Plugins installed are:"
            Get-ChildItem $tomcat_path\Server\webapps -File | Format-Table Name, LastWriteTime
            Write-Host " "

          }
        Else
          {
              Write-Host "Nothing to do."
          }