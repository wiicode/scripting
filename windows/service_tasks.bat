REM this bat file uses subroutines.
REM if functions define the system, which has dedicated subroutines.
REM each IF/ElSE statement should "goto common" as the last step

REM what system are we on?
set host=%COMPUTERNAME%
echo %host%

REM what subroutine do we run?
IF %host%==dev (
  goto dev
  goto common
) ELSE IF %host%==example (
  goto example
  goto common
) ELSE (
  goto common
)

REM common services across most systems (it's ok if this list has stuff in it that's not precisely matched, it will just skip)
:common
  REM net start "whatever"
goto:eof

REM subroutines
:example
	echo nothing to do, this is just an example

REM subroutines
:dev
	net start "UNIVERSALTYPESERVER"
	net start "UTSANALYTICS"
	net start "UTS_PG"
	net start "ESPADMSVC"
	net start "FontLinkConnectorDatabase"
	net start "FontLinkModuleDatabase"
	net start "FONTLINKMODULE"
  net start "FONTLINKCONNECTOR"
