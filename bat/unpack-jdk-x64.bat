@echo off
set "tool7z=%TOT_CORE%\7-Zip\7z"
set "jdk_exe=%1"

echo Extracting '.rsrc/1033/JAVA_CAB10/111'
%tool7z% e %jdk_exe% .rsrc/1033/JAVA_CAB10/111
:: %tool7z% e %jdk_exe% .rsrc/1033/version.txt

echo Extracting '111'
extrac32 111

echo Removing '111'
del 111

echo Extracting 'tools.zip'
%tool7z% x tools.zip -ojdk

echo Removing 'tools.zip'
del tools.zip

echo Extracting '*.pack'
cd jdk
for /r %%x in (*.pack) do .\bin\unpack200 -r "%%x" "%%~dx%%~px%%~nx.jar"
cd ..

echo Done.
