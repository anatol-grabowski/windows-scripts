rem@echo off
rem This is a hybrid batch-vbs script
rem 'rem[Ctrl+Z]bat_command' format assures that the 'bat_command' will be executed
rem only if the file is launched as batch file, but not if it is launched as vbs script
rem 'rem' is a valid comment both in batch and vbs
rem '[Ctrl+Z]' after 'rem' moves caret to beginning of the line in batch but not in vbs
rem so 'bat_command' will overwrite 'rem' in some "batch command buffer"
rem The script is started as a batch script then after batch section execution is done
rem it calls itself through 'cscript //nologo //E:vbscript %0 %1 ...' and exits 
remset ARG0_SRCLNK="%USERPROFILE%\Desktop\%~n0.lnk"
remset ARG1_APPLCT="%0"
remset ARG2_APPARG=""
remset ARG3_WRKDRC="%~dp0"
remset ARG4_ICOLCT="%TOT_CORE%\totalcmd\Totalcmd.ico"
remset ARG5_HOTKEY="Ctrl+Alt+t"
remrem cscript //nologo //E:vbscript %0 %ARG0_SRCLNK% %ARG1_APPLCT% %ARG2_APPARG% %ARG3_WRKDRC% %ARG4_ICOLCT% %ARG5_HOTKEY%
remecho arg1 %1
remecho arg2 %2
remecho arg3 %3
remecho arg4 %4
remecho arg5 %5
remecho arg6 %6
remcscript //nologo //E:vbscript %0 %*
remexit /B
rem ========================== end of bat ====================================
rem start of vbs section, all the code above should start with 'rem'

set objWSHShell = WScript.CreateObject("WScript.Shell")
set objWSHShell = CreateObject("WScript.Shell")
set objFso = CreateObject("Scripting.FileSystemObject")
If WScript.arguments.count = 6 then
    WScript.Echo "usage: make-lnk.bat shortcutPath targetPath arguments workingDir IconLocation Hotkey"
    sShortcut = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(0))
    set objSC = objWSHShell.CreateShortcut(sShortcut) 
    sTargetPath = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(1))
    sArguments = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(2))
    sWorkingDirectory = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(3))
    sIconLocation = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(4))
	sHotkey = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(5))
    objSC.TargetPath = sTargetPath
    objSC.Arguments = Replace(sArguments, "QuteQ", Chr(34))
    objSC.WorkingDirectory = sWorkingDirectory
    rem objSC.Description = "Love Peace Bliss"
    rem 1 restore 3 max 7 min
    objSC.WindowStyle = "1"
    objSC.Hotkey = sHotkey
    objSC.IconLocation = sIconLocation
    objSC.Save
    WScript.Quit
end If
If WScript.arguments.count = 2 then
    WScript.Echo "usage: make-lnk.bat shortcutPath targetPath"
    sShortcut = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(0))
    set objSC = objWSHShell.CreateShortcut(sShortcut) 
    sTargetPath = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(1))
    sWorkingDirectory = objFso.GetAbsolutePathName(sShortcut)
    objSC.TargetPath = sTargetPath
    objSC.WorkingDirectory = sWorkingDirectory
    objSC.Save
    WScript.Quit
end If
WScript.Echo "error"
WScript.Quit
