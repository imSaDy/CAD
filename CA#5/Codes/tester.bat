@echo off
setlocal enabledelayedexpansion

cd /d %~dp0

set /a passed=0
set /a total=0

for /D %%d in (testcases\*) do (
    echo ---------------------------------------
    echo [TEST] %%d
    set /a total += 1
    py main.py "%%d"
    py checker.py "%%d"
        if !errorlevel! equ 0 (
        set /a passed += 1
        echo Result: PASS
    ) else (
        echo Result: FAIL
    )
)

echo =======================================
echo FINAL SCORE: !passed!/!total! tests passed.
pause