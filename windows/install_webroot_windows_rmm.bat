:: Webroot Auto Installer

@cls
@echo off
setlocal
rem *******************
rem * Setup Variables *
rem *******************
rem If the folder named below is found at the following location then the script will end.
set XLocation="%ProgramFiles%\webroot"
set WLocation="%ProgramFiles(x86)%\webroot"
rem MSI one liner
set MSICommand=msiexec.exe
set cmd2=/i
set cmd3=http://anywhere.webrootcloudav.com/zerol/wsasme.msi
set cmd4=GUILIC=3AF9-PLSW-54E0-FA60-49E3  rem RMM KEY
set cmd5=CMDLINE=SME,quiet
set cmd6=/qn
set cmd7=/l*v
set cmd8=install.log


rem ****************
rem *  The Script  *
rem ****************
call :TestIf64Bit
call :InstallWebroot
goto :Endscript

rem ***************
rem *  Functions  *
rem ***************

:TestIf64Bit
echo Checking for a 64-bit operating system...
if "%ProgramFiles(x86)%"=="" (
	echo This is not a 64 bit OS.
	echo.
	goto :TestIfNeed32
) else (
	echo The OS is a 64-bit Operating System.
	echo.
	goto :TestIfNeed64
)

:TestIfNeed64
echo %WLocation%
echo Checking if webroot installed...
if not exist %WLocation% (
	echo Webroot not installed - moving to install.
	echo.
	goto :eof
	)
	goto :EndScript2
	)

:TestIfNeed32
echo Checking if webroot installed...
	if not exist %XLocation% (
	echo Webroot not installed - moving to install..
	echo.
	goto :eof
	)
	goto :EndScript2
)

:InstallWebroot
%MSICommand% %cmd2% %cmd3% %cmd4% %cmd5% %cmd6%
goto :eof
)

:EndScript
echo Installer initiated. Check Webroot dashboard
endlocal
exit
)

:EndScript2
echo Installed already. Installer not run.
echo
endlocal
exit
)
