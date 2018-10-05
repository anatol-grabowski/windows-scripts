@echo off

set "chrome_preferences="%TOT_CORE%\Google Chrome\chrome_profiles\Default\Preferences""
set "br_dow=%TOT_DOWB%"

:: '/F' to iterate through commandline output
:: 'USEBACKQ' to be able to use doublequotes inside backquotes without problems
:: '^' escapes pipe symbol '|'
:: no space before '^|' to prevent trailing space from appearing in variable
:: 'jrepl "\\" "\\\\"' quadruples backslashes (escapes double backslashes)
FOR /F "tokens=* USEBACKQ" %%F IN (`echo %br_dow%^| jrepl "\\" "\\\\" /x`) DO (SET br_dow=%%F)
echo Downloads folder will be set to: '%br_dow%'

set "regex="(\qdownload\q:{\qdefault_directory\q:\q)([\w\W]{0,}?)(\q)""
set "repl="$1%br_dow%$3""

:: '/x' to be able to use '\q' escape sequence for doublequotes symbol '"'
:: '/f' inFile
:: '/o' outFile
call jrepl %regex% %repl% /f %chrome_preferences% /o - /x

start "" "%TOT_CORE%\Google Chrome\chrome" --user-data-dir="%TOT_CORE%\Google Chrome\chrome_profiles" --profile-directory="Default"
:: start "" "%TOT_CORE%\Google Chrome\chrome" --user-data-dir="%TOT_CORE%\Google Chrome\chrome_profiles" --profile-directory="Default" --disk-cache-size=314572800
