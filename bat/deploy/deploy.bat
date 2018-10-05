	@echo off
:: "UTF-8 without BOM" encoding is used
	chcp 65001

::set_TOT_DIR
	pushd %~dp0..\..\..
	set totDir=%cd%
	popd
	choice /c ny /n /m "TOT_DIR is going to be: %totDir%. ok? [y/n]
	IF %errorlevel%==1 goto :END
	setx TOT_DIR %totDir%
	echo TOT_DIR environment variable set to: %totDir%.

::set_TOT_DRIVE
	set /P totDrive=Enter drive letter for 'subst': 
	subst "%totDrive%" "%totDir%"
	echo %totDrive%:>tot_drive.txt
	call %~dp0\subst_drive.bat
	echo TOT_DRIVE environment variable set to: %totDrive%.

::set_PATH
	choice /c ny /n /m "Update PATH and PATHEXT environment variables? [y/n]
	IF %errorlevel%==1 goto :set_autorun
	call %~dp0\add_pathes.bat
	call %~dp0\add_pathext.bat

::set_autorun
	choice /c ny /n /m "Add autorun? [y/n]
	IF %errorlevel%==1 goto :set registry
	call %~dp0\add_autorun.bat

::set registry
	choice /c ny /n /m "Set file associations? [y/n]
	IF %errorlevel%==1 goto :END
	regedit  "%~dp0..\registry\assoc_exts.reg"

	goto :END

:END
	echo Deployed.
	pause
