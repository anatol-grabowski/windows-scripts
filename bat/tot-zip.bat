@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

ren "%TOT_TEMP%\backup" backup.zip
set "archname="%TOT_TEMP%\backup.zip""

set "filelist="
cd %TOT_DIR%
for %%A in (%*) do (
	set ondisk_path="%%~dpnxA"
	set inarch_path=!ondisk_path:%TOT_DIR%\=!
	echo Putting !ondisk_path! to !inarch_path!.
	set "filelist=!filelist! !inarch_path!"
)
echo filelist: %filelist%

echo on
"%TOT_7zip%\7z" a -tzip %archname% %filelist% > NUL
ren %archname% backup
::pause
exit /B
