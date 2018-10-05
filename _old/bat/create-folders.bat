	@echo off
	rem 'goto' cause %1 unavailable in 'call'
	goto :GET_PARENT_DIR
:BAT_CODE
	pause
	for /f "tokens=*" %%a in (%~dp0\folders.txt) do (
		echo Creating folder: %parentDir%%%a
		md %parentDir%%%a
	)
	goto :END



:GET_PARENT_DIR
  echo %1
	if [%1]==[] (
		set parentDir=%~dp0
	) else (
		set parentDir=%1\
	)
	echo Parent directory is: %parentDir%
	goto :BAT_CODE

:END
  pause