@echo off

for %%A in ("%path:;=";"%") do (
    echo '%%~A'
)
pause