@echo off
set "sketch=%cd%"
set "output=%TOT_TEMP%/processing-output"
set "processing_java=%TOT_PROG%\processing-3.3\processing-java"

supervisor -x %processing_java% -e pde -n exit -RV -- --sketch=%sketch% --output=%output% --force --run
