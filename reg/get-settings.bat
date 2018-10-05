@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

set reg_files=
for /f "tokens=*" %%a in (%~dp0keys.txt) do (
	echo Getting branch: '%%a'
	FOR /F "tokens=* USEBACKQ" %%F IN (`echo %%a^| jrepl "\\" "-"`) DO (SET reg_file=%%F)
	FOR /F "tokens=* USEBACKQ" %%F IN (`echo !reg_file!^| jrepl "HKEY_CURRENT_USER" "HKCU"`) DO (SET reg_file=%%F)
	set reg_file=settings\!reg_file!
	echo        to file: '!reg_file!'
	regedit /e "!reg_file!" "%%a"
	set reg_files=!reg_files!+"!reg_file!"
)

echo.
FOR /F "tokens=* USEBACKQ" %%F IN (`echo %reg_files%^| jrepl "^\+" ""`) DO (SET reg_files=%%F)
echo Copying all to one file: %reg_files%
copy %reg_files% "settings.reg"
pause
