for /f "tokens=*" %%a in (tot_drive.txt) do (
	subst "%%a" /d
)
REG delete HKCU\Environment /F /V TOT_DRIVE