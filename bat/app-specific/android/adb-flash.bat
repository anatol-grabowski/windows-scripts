@echo off
rem THIS SCRIPT DOES NOT WORK
set "project="
set "package="
set "build_type=debug"

FOR /F "tokens=* USEBACKQ" %%F IN (`cd^| jrepl "\\" "\n" /x`) DO (SET "project=%%F")
set "apk_file=build/outputs/apk/%project%-%build_type%.apk"


set "manifest_file=./src/main/AndroidManifest.xml"
	rem set "sed_pattern=s/\(package=\"\)\([a-z\.]*\)\(\"^>\)/\2/p"
set "sed_pattern=/package/p"
set "sed_cmd=sed -n -e "%sed_pattern%" "%manifest_file%""
	rem %sed_cmd%
	rem FOR /F "tokens=* USEBACKQ" %%F IN (`%sed_cmd%`) DO (SET "package=%%F")
FOR /F USEBACKQ^ tokens^=2^ delims^=^" %%F IN (`%sed_cmd%`) DO (SET package=%%F)
	rem notice: works only if package name is the 2nd token!!!!

echo package: '%package%'
echo apk_file: '%apk_file%'

@echo on
adb uninstall %package%
adb install %apk_file%
