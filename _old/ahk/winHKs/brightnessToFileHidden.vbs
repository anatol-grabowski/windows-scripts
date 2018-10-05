Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "cmd /c brightnessToFile.bat"
oShell.Run strArgs, 0, false