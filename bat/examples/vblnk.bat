rem@echo off
remset VBS=createSCUT.vbs 
remset SRC_LNK="shortcut1.lnk"
remset ARG1_APPLCT="C:\Program Files\Google\Chrome\Application\chrome.exe"
remset ARG2_APPARG="--profile-directory=QuteQProfile 25QuteQ"
remset ARG3_WRKDRC="C:\Program Files\Google\Chrome\Application"
remset ARG4_ICOLCT="%USERPROFILE%\Local Settings\Application Data\Google\Chrome\User Data\Profile 28\Google Profile.ico"
remcscript //nologo //E:vbscript %0 %SRC_LNK% %ARG1_APPLCT% %ARG2_APPARG% %ARG3_WRKDRC% %ARG4_ICOLCT%
rempause
remexit /B

Set objWSHShell = WScript.CreateObject("WScript.Shell")
set objWSHShell = CreateObject("WScript.Shell")
set objFso = CreateObject("Scripting.FileSystemObject")
If WScript.arguments.count = 5 then
    WScript.Echo "usage: makeshortcut.vbs shortcutPath targetPath arguments workingDir IconLocation"
    sShortcut = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(0))
    set objSC = objWSHShell.CreateShortcut(sShortcut) 
    sTargetPath = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(1))
    sArguments = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(2))
    sWorkingDirectory = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(3))
    sIconLocation = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(4))
    objSC.TargetPath = sTargetPath
    rem http://www.bigresource.com/VB-simple-replace-function-5bAN30qRDU.html#
    objSC.Arguments = Replace(sArguments, "QuteQ", Chr(34))
    rem http://msdn.microsoft.com/en-us/library/f63200h0(v=vs.90).aspx http://msdn.microsoft.com/en-us/library/267k4fw5(v=vs.90).aspx
    objSC.WorkingDirectory = sWorkingDirectory
    objSC.Description = "Love Peace Bliss"
    rem 1 restore 3 max 7 min
    objSC.WindowStyle = "3"
    rem objSC.Hotkey = "Ctrl+Alt+e";
    objSC.IconLocation = sIconLocation
    objSC.Save
    WScript.Quit
end If
If WScript.arguments.count = 4 then
    WScript.Echo "usage: makeshortcut.vbs shortcutPath targetPath arguments workingDir "

    sShortcut = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(0))
    set objSC = objWSHShell.CreateShortcut(sShortcut) 
    sTargetPath = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(1))
    sArguments = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(2))
    sWorkingDirectory = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(3))
    objSC.TargetPath = sTargetPath
    objSC.Arguments = Replace(sArguments, "QuteQ", Chr(34))
    objSC.WorkingDirectory = sWorkingDirectory
    objSC.Description = "Love Peace Bliss"
    objSC.WindowStyle = "3"
    objSC.Save
    WScript.Quit
end If
If WScript.arguments.count = 2 then
    WScript.Echo "usage: makeshortcut.vbs shortcutPath targetPath"
    sShortcut = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(0))
    set objSC = objWSHShell.CreateShortcut(sShortcut) 
    sTargetPath = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(1))
    sWorkingDirectory = objFso.GetAbsolutePathName(sShortcut)
    objSC.TargetPath = sTargetPath
    objSC.WorkingDirectory = sWorkingDirectory
    objSC.Save
    WScript.Quit
end If
