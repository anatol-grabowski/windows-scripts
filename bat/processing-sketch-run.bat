@set "sketch=%~dp1"
@set "output=%TOT_TEMP%/processing-output"
@set "processing_java=%TOT_PROG%\processing-3.3\processing-java"

:run_sketch
%processing_java% --sketch=%sketch% --output=%output% --force --run
::@rm -rf %output%

@pause >nul|set/p =Press any key to restart the sketch...
@echo.
@GOTO :run_sketch
