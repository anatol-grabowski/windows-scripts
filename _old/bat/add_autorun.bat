@echo off
setlocal enabledelayedexpansion

set autorun_path="%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
for /f "tokens=*" %%a in (%~dp0autorun.txt) do (
	echo Adding to autorun: %%a
	call %~dp0\create_url.bat %%a %autorun_path%\%%~na.url
)

endlocal