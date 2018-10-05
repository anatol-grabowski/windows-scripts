echo off
if [%1]==[] (
	set parentDir=%cd%
) else (
	set parentDir=%1\
)
echo Parent directory is: %parentDir%

set fromExt=exe
set toExt=ex_app

echo Renaming *.%fromExt% to *.%toExt%...
for /R %parentDir% %%G IN (*.%fromExt%) do (
	echo %%G
	ren %%G *.%toExt%
)

echo Updating registry...
reg import %~dp0..\reg\assoc_ex.reg

pause
