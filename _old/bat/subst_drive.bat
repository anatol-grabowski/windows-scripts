for /f "tokens=*" %%a in (%~dp0tot_drive.txt) do (
	subst "%%a" "%TOT_DIR%"
	setx TOT_DRIVE %%a
)
exit /B
