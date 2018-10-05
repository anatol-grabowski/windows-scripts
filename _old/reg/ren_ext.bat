echo off
if [%1]==[] (
	set parentDir=%~dp0
) else (
	set parentDir=%1\
)
echo Parent directory is: %parentDir%

set /P fromExt=Rename extension (e.g. exe): 
if [%fromExt%]==[] (
	set fromExt=exe
)

set /P toExt=Rename to (e.g. ex_app): 
if [%toExt%]==[] (
	set toExt=ex_app
)

echo Renaming *.%fromExt% to *.%toExt%...

for /R %parentDir% %%G IN (*.%fromExt%) do (
	echo %%G
	ren %%G *.%toExt%
)

pause