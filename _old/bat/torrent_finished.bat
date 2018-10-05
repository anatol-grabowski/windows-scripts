::@echo off

echo "%~1"
echo "%~2"
echo "%~3"

set resumeDat="%~dp0..\..\_1_BASIC_APPS\uTorrent\resume.dat"
set resumeDatOld="%~dp0..\..\_1_BASIC_APPS\uTorrent\resumeOld.dat"
set resumeDatNew="%~dp0..\..\_1_BASIC_APPS\uTorrent\resumeNew.dat"
echo r %resumeDat%
echo o %resumeDatOld%
echo n %resumeDatNew%
pause

echo Replacing path in 'resume.dat'...
echo from "%~1"
echo to   "%~1%~3"
pause

jrepl "%~1" "%~1%~3" /L /F %resumeDat% /O %resumeDatNew%
::copy %resumeDat% %resumeDatOld%
echo Replaced.
pause

echo Moving "%~2" to "%~1\%~3\%~2"...
mkdir "%~1\%~3\"
move "%~1\%~2" "%~1\%~3\%~2"

pause