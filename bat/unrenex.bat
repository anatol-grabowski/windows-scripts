echo off
if [%1]==[] (
	set parentDir=%cd%
) else (
	set parentDir=%1\
)
echo Parent directory is: %parentDir%

set fromExt=ex_app
set toExt=exe

echo Renaming *.%fromExt% to *.%toExt%...
for /R %parentDir% %%G IN (*.%fromExt%) do (
	echo %%G
	ren "%%G" *.%toExt%
)

rem echo Updating registry...
rem reg import %~dp0..\reg\assoc_ex.reg

rem pause
