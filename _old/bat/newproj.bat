  @ECHO off

  SET templatesDir=%TOT_DIR%\_3_PROJECTS\_1_TEMPLATES
  ECHO Templates directory is: %templatesDir%
	if not [%1] == [] (
		SET template=%1
		GOTO :TEMPL_NAME_CHECK
	)
:ENTER_TEMPL_NAME
  SET /p template=Template name: 
:TEMPL_NAME_CHECK
  SET templDir=%templatesDir%\%template%
  IF NOT EXIST %templDir% (
    ECHO Template '%template%' doesn't exist.
    GOTO :ENTER_TEMPL_NAME
  )

  SET parentDir=%cd%
  ECHO Parent directory is:    %parentDir%
	if not [%2] == [] (
		SET project=%2
		GOTO :PROJ_NAME_CHECK
	)
:ENTER_PROJ_NAME
  SET /p project=New project name: 
:PROJ_NAME_CHECK
  SET projDir=%parentDir%\%project%
  SET projFile=%projDir%\%project%._proj
  IF NOT EXIST %projDir% (
		echo Creating project at '%projDir%'...
		set newProj=_-new-proj-_
    call :COPY_PROJ
    call :REN_PROJ_REFS
		echo Project '%project%' created.
  ) ELSE (
    ECHO Project '%project%' already exists.
    GOTO :ENTER_PROJ_NAME
  )
	GOTO :EOF

:COPY_PROJ
	echo Copying '%template%' template files...
	xcopy %templDir% %projDir%\ /E
	echo Renaming '%newProj%.*' files...
	for /R %projDir% %%G IN (%newProj%.*) do (
		echo %%G
		ren %%G %project%.*
	)
	echo Renamed.
	EXIT /B

:REN_PROJ_REFS
	echo Replacing '%newProj%' references in files...
	for /R %projDir% %%G IN (*) do (
		echo %%G
		ren %%G %%~nxG_
		jrepl "%newProj%" "%project%" /f %%G_ /o %%G
		del %%G_
	)
	echo Replaced.
	EXIT /B

:EOF
  PAUSE