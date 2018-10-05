@TITLE = WINDOWS 10 AP on/off
ECHO OFF
#SCRIPT BY S56K
SETLOCAL ENABLEEXTENSIONS
CLS
:MENU
CLS
ECHO.
ECHO -----------------------------------------------
ECHO Enter 1, 2, 3 or 4 to choose, 5 to exit.
ECHO -----------------------------------------------
ECHO.
ECHO 1 - Set SSID and password
ECHO 2 - Run WiFi AP
ECHO 3 - Stop WiFi AP
ECHO 4 - Show AP status
ECHO 5 - Exit
ECHO.
CHOICE /C:12345 /M Choose
IF ERRORLEVEL 1 SET M=1
IF ERRORLEVEL 2 SET M=2
IF ERRORLEVEL 3 SET M=3
IF ERRORLEVEL 4 SET M=4
IF ERRORLEVEL 5 SET M=5
IF %M%==1 GOTO SSIDMENU
IF %M%==2 GOTO START
IF %M%==3 GOTO STOP
IF %M%==4 GOTO SHOW
IF %M%==5 GOTO END
:SSIDMENU
CLS
ECHO.
ECHO -----------------------------------------------
ECHO Press 1 or 2 to choose, 3 for exit.
ECHO -----------------------------------------------
ECHO.
ECHO 1 - Set SSID and password
ECHO 2 - Use SSID and password from file
ECHO 3 - Main menu
ECHO.
CHOICE /C:123 /M Choose
IF ERRORLEVEL 1 SET M=1
IF ERRORLEVEL 2 SET M=2
IF ERRORLEVEL 3 SET M=3
IF %M%==1 GOTO SSID
IF %M%==2 GOTO FROMFILE
IF %M%==3 GOTO MENU
CHOICE /C:123 /M Choose
IF ERRORLEVEL 1 SET M=1
IF ERRORLEVEL 2 SET M=2
IF ERRORLEVEL 3 SET M=3
IF %M%==1 GOTO SSID
IF %M%==2 GOTO FROMFILE
:SSID
set /p SSID=Enter SSID:
set /p PASS=Enter SSID (at least 8 characters):
netsh wlan set hostednetwork mode=allow ssid="%SSID%" key=%PASS%
GOTO SAVEQ
:SAVEQ
CLS
ECHO -----------------------------------------------
ECHO Press 1 or 2 to choose.
ECHO -----------------------------------------------
ECHO.
ECHO 1 - Save to file
ECHO 2 - Without saving
ECHO.
CHOICE /C:12 /M Choose
IF ERRORLEVEL 1 SET M=1
IF ERRORLEVEL 2 SET M=2
IF %M%==1 GOTO SAVE
IF %M%==2 GOTO MENU
:SAVE
@ECHO %SSID%>SSID.txt
@ECHO %PASS%>PASS.txt
CLS
ECHO SSID and password saved.
TIMEOUT /T 3
GOTO MENU
:FROMFILE
set /p SSID=<SSID.txt
IF NOT EXIST SSID.txt GOTO ERRORSSID
set /p PASS=<PASS.txt
IF NOT EXIST PASS.txt GOTO ERRORPASS
netsh wlan set hostednetwork mode=allow ssid="%SSID%" key=%PASS%
CLS
ECHO.
ECHO.
ECHO Used from file.
ECHO.
ECHO.
ECHO SSID = "%SSID%"
ECHO Password = %PASS%
ECHO.
ECHO.
ECHO Press any key to return to Main Menu
Pause>nul
GOTO MENU
:START
@netsh wlan start hostednetwork
CLS
ECHO.
ECHO.
ECHO AP Started
TIMEOUT>nul /T 3
GOTO MENU
:STOP
@netsh wlan stop hostednetwork
CLS
ECHO.
ECHO.
ECHO AP Stopped
TIMEOUT>nul /T 3
GOTO MENU
:SHOW
CLS
netsh wlan show hostednetwork
ECHO Press any key to return to Main Menu
PAUSE >nul
CLS
GOTO MENU
:ERRORSSID
CLS
ECHO.
ECHO.
ECHO File with SSID not found.
ECHO.
ECHO.
ECHO Press any key to return to Main Menu
Pause>nul
GOTO MENU
:ERRORPASS
CLS
ECHO.
ECHO.
ECHO File with password not found.
ECHO.
ECHO.
ECHO Press any key to return to Main Menu
Pause>nul
GOTO MENU
:END
exit 0