set Arr[0]=172.31.1.1


set "x=0"

:SymLoop
if defined Arr[%x%] (
    REM %SystemRoot%\system32\ping.exe -n 1 %MyServer% >nul
    echo %%Arr[%x%]%%
    call %SystemRoot%\system32\ping.exe -n 10 %%Arr[%x%]%%
    set /a "x+=1"
    GOTO :SymLoop
)


