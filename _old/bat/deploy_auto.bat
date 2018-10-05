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
	call %~dp0\subst_drive.bat
	echo TOT_DRIVE environment variable set.

::set_PATH
	call %~dp0\add_pathes.bat
	call %~dp0\add_pathext.bat
	echo PATH and PATHEXT environment variables updated.

::set_autorun
	call %~dp0\add_autorun.bat
	echo Scripts added to autorun.

::set registry
	choice /c ny /n /m "Set file associations? [y/n]
	IF %errorlevel%==1 goto :END
	regedit  "%~dp0..\registry\assoc_exts.reg"

	goto :END

:END
	echo Deployed.
	pause
