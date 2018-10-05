set APPDATA=%~dp0portable_conf
mkdir %APPDATA%
START /D"%~dp0" codeblocks.exe %*