	@echo off
	
	pushd %~dp0..\..\..
	set "TOT_DIR=%cd%"
	echo TOT_DIR is '%TOT_DIR%'
	popd
	
	set "TOT_APPS=%TOT_DIR%\_4_PORTABLE"
	echo TOT_APPS is '%TOT_APPS%'
	
	set "TOT_CORE=%TOT_APPS%\_1_CORE_APPS"
	echo TOT_CORE is '%TOT_CORE%'
	
	set "TOT_SCRIPTS=%TOT_APPS%\_2_SCRIPTS"
	echo TOT_SCRIPTS is '%TOT_SCRIPTS%'
	
	set "TOT_PROJ=%TOT_DIR%\_3_PROJECTS"
	echo TOT_PROJ is '%TOT_PROJ%'
	
	set "PATHEXT=.ex_app;.exe;.bat;.cmd;.vbs;.vbe;.js;.jse;.wsf;.wsh;.msc"
	echo PATHEXT is '%PATHEXT%'
	
	set "tempPATH="
	for /f "tokens=*" %%a in (%~dp0pathes.txt) do (
		echo Adding path: %%a
		call set tempPATH=%%a;%%tempPATH%%
	)
	set "PATH=%tempPATH%%PATH%"
	echo PATH is: %PATH%
	
	
	start "" "%TOT_CORE%\totalcmd\TOTALCMD"
	start "" "%TOT_CORE%\AutoHotkey\AutohotkeyU32" "%TOT_SCRIPTS%\ahk\metaconsole\MetaConsole\MetaCommands.ahk"
	::pause
	exit /B