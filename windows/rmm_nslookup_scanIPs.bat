@echo off
setlocal EnableDelayedExpansion
set "xNext="
set "xComputer="
for /f %%A in ('net view /all') do (
    set "xComputer=%%~A"
    if "!xComputer:~0,2!"=="\\" for /f "tokens=2,* delims=. " %%X in ('nslookup %%A') do (
        if "!xNext!"=="1" (
            echo.!xComputer! = %%X.%%Y
            set "xNext=0"
        )
        if "!xComputer:~2!"=="%%~X" set "xNext=1"
    )
)
endlocal
