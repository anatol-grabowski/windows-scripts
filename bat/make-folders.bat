@echo off
if [%1]==[] (
	set parentDir=%cd%
) else (
	set parentDir=%1\
)
echo Parent directory is: %parentDir%

for /f "tokens=*" %%a in (%~dp0\folders.txt) do (
	echo Creating folder: %%a
	md %parentDir%\%%a
)

endlocal