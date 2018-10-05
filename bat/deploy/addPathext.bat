@echo off
setlocal enabledelayedexpansion
for /f "usebackq tokens=2,*" %%a in (`reg query HKCU\Environment /v PATHEXT`) do (
	echo PATHEXT before: %%b
	set path_ext=%%b
)
set ext=.ex_app
if ";!path_ext:%ext%;=!;" equ ";%path_ext%;" (
	setx PATHEXT "%ext%;%path_ext%"
)
for /f "usebackq tokens=2,*" %%a in (`reg query HKCU\Environment /v PATHEXT`) do (
	echo PATHEXT after: %%b
)
