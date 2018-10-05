rem Starting: %*@echo off
rem This script allows to run commandline applications silently (without window)
rem This is a hybrid batch-vbs script
rem 'rem[Ctrl+Z]bat_command' format assures that the 'bat_command' will be executed
rem only if the file is launched as bat file, but not if it is launched as vbs script
rem 'rem' is a valid comment both in batch and vbs
rem '[Ctrl+Z]' after 'rem' moves caret to beginning of the line in batch but not in vbs
rem so 'bat_command' will overwrite 'rem' in some "batch command buffer"
rem The script is started as a batch script then after batch section execution is done
rem it calls itself through 'cscript //nologo //E:vbscript %~dpnx0 %*' and exits
remcscript //nologo //E:vbscript %~dpnx0 %*
remexit /B
rem ========================== end of bat ====================================

rem ====== vbs section below, all the code above should start with 'rem' =====
ReDim arr(WScript.Arguments.Count-1)    'create an array arr
For i = 0 To WScript.Arguments.Count-1
  arr(i) = WScript.Arguments(i)         'copy arguments to arr
Next
args = Join(arr)                        'convert arr to a string
rem WScript.Echo args
set objWSHShell = CreateObject("WScript.Shell")
objWSHShell.Run args, 0                 'run with intWindowStyle=0 (hide window)
