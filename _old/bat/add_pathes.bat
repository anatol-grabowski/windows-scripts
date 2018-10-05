@echo off
for /f "usebackq tokens=2,*" %%a in (`reg query HKCU\Environment /v PATH`) do (
	echo PATH before: %%b
)

for /f "tokens=*" %%a in (%~dp0pathes.txt) do (
	echo Adding path: %%a
	set p=%%a
	call %~dp0add_path.bat p /B
)

for /f "usebackq tokens=2,*" %%a in (`reg query HKCU\Environment /v PATH`) do (
	echo PATH after:  %%b
)
exit /B