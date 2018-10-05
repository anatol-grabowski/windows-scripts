	@echo off
	if [%1]==[] goto :END
	if [%2]==[] (
		set url="%~dpn1.url"
	) else (
		set url="%~dpnx2"
	)
	if exist %url% (
		del %url%
	)
	echo [InternetShortcut] >> %url%
	echo URL="%~1" >> %url%
	echo Shortcut created.
:END