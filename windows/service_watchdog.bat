@ECHO OFF

SC QUERYEX "PC Monitor" | FIND "STATE" | FIND /v "RUNNING" > NUL && (
NET START "PC Monitor" > NUL || (
        EXIT /B 1
    )
    EXIT /B 0
) || (
    EXIT /B 0
)