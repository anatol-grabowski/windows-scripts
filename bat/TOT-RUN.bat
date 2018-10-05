@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
 
GOTO :START

:SETENV
  if "%3"=="+" (
    cd %2
    echo Env set%3: %1 = '!cd!'
    set "%1=!cd!"
    exit /B
  )
  echo Env set: %1 = '%~2'
  set "%1=%~2"
  exit /B

:SETPATH
  echo Path add: '%~1'
  set tempPATH=%~1;%tempPATH%
  exit /B

:START
:set_env
  for /f "tokens=*" %%a in (%~dp0envvars.txt) do (call :SETENV %%a)
  cd %~dp0
  echo(

:set_pathext
  set "PATHEXT=.ex_app;.exe;.bat;.cmd;.vbs;.vbe;.js;.jse;.wsf;.wsh;.msc"
  echo PATHEXT  is '%PATHEXT%'
  echo(

:set_path
  set "tempPATH="
  for /f "tokens=*" %%a in (%~dp0pathes.txt) do (call :SETPATH %%a)
  set "PATH=%tempPATH%%PATH%"
  set "tempPATH="
  echo PATH is: 
  for %%A in ("%path:;=";"%") do (echo.  '%%~A')
  echo(

:make_lnk
  set "urlFile=%USERPROFILE%\Desktop\%~n0.lnk"
  if not exist %urlFile% (
    call make-lnk.bat %urlFile% %0 "" %~dp0 "%TOT_totalcmd%\Totalcmd.ico" "Ctrl+Alt+r"
    call make-lnk.bat "%USERPROFILE%\Desktop\calc.lnk" "calc.exe" "" "" "calc.exe" "Ctrl+Alt+c" > NUL
    ::call make-lnk.bat "%USERPROFILE%\Desktop\cmd.lnk" "cmd.exe" "" "" "cmd.exe" "Ctrl+Alt+s" > NUL
    echo Shortcut created.
    pause
  ) else (
    echo Shortcut is already created.
  )
echo(

:register_fonts
  ::call "%TOT_CONF%\Fonts\register-all.bat" 
  echo(

:run_apps
  echo Starting applications.
  ::start "" "%TOT_totalcmd%\TOTALCMD" "/i=%TOT_CONF%/totalcmd/wincmd.ini" "/F=%TOT_CONF%/totalcmd/wcx_ftp.ini"
  start "" "%TOT_totalcmd%\TOTALCMD"
  ::start "" "%TOT_CORE%\uTorrent\uTorrent" "/MINIMIZED"

  ::start "" "%TOT_CORE%\AutoHotkey\AutohotkeyU32" "%TOT_SCR%\ahk\metaconsole\MetaConsole\MetaCommands.ahk"
  ::start "" "%TOT_CORE%\AutoHotkey\AutohotkeyU32" "%TOT_SCR%\ahk\commonHKs\ALL_HKs.ahk"
  start "" "%TOT_autohotkey%\AutohotkeyU32" "%TOT_SCR%\ahk\commonHKs\TOT_HKs.ahk" "noIcon"
  ::start "" "%TOT_CORE%\AutoHotkey\AutohotkeyU32" "%TOT_SCR%\ahk\boss-key.ahk" "noIcon"
  ::pause
  exit /B
