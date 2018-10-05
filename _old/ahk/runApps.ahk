global timeHK := 1000

global appDescs := Object()
appDescs.Insert(new AppDesc("n", "Notepad.exe", "Notepad"))
appDescs.Insert(new AppDesc("s", "cmd.exe", "ConsoleWindowClass"))
appDescs.Insert(new AppDesc("c", "calc.exe", "CalcFrame"))
appDescs.Insert(new AppDesc("f", "c:\_PORTABLE\totalcmd\TOTALCMD64.EXE", "TTOTAL_CMD"))
appDescs.Insert(new AppDesc("v", "c:\_PORTABLE\VLC\vlc.exe", "QWidget"))
appDescs.Insert(new AppDesc("m", "c:\_PORTABLE\AIMP3\AIMP3.exe", "TAIMPMainForm"))
appDescs.Insert(new AppDesc("b", "c:\_PORTABLE\stduViewer\STDUViewerApp.exe", "STDUViewerMainWindowClass"))
appDescs.Insert(new AppDesc("t", "c:\_PORTABLE\uTorrent\uTorrent.exe", "µTorrent4823DF041B09"))
appDescs.Insert(new AppDesc("i", "c:\Program Files (x86)\Google\Chrome\Application\chrome.exe", "Chrome_WidgetWin_1"))

#WinActivateForce

for i, appDesc in appDescs {
  fn1 := Func("RunOrToggleApp").Bind(appDesc)
  Hotkey, % "#" appDesc.key, % fn1, on
  ;Hotkey, % "!#" appDesc.key, % fn2, on
}

~LWin Up::
  stringsplit, splitted_, A_PriorHotkey
  ;MsgBox % splitted_1
  if (splitted_1 = "#") { ;win+key combo has just been released
    return
  }
  StartTime := A_TickCount
  Input, key, L1, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}
  timeElapsed := A_TickCount - StartTime
  if (timeElapsed > timeHK) {
    ;MsgBox % "time elapsed " timeElapsed " > " timeHK ;compare times
    return
  }
  appDesc := AppDescByKey(key)
  RunOrToggleApp(appDesc)
return

RunOrToggleApp(appDesc) {
  DetectHiddenWindows, on
  path := appDesc.path
  if (!path) {
    return
  }
  ;MsgBox % "app: " appDesc "( " appDesc.path ", " appDesc.wndClass " )" ;app to run/toggle
  SplitPath, path, process
  Process, Exist, %process%
  If !ErrorLevel {
    Run, %path%
  }
  else {
    ToggleActive(appDesc.wndClass)
  }
}

ToggleActive(wndClass)
{
  IfWinNotActive, % "ahk_class " wndClass 
  {
    WinActivate, % "ahk_class " wndClass
  }
  else
  {
    WinMinimize, % "ahk_class " wndClass
  }
}

AppDescByKey(key) {
  for i, appDesc in appDescs {
    ;MsgBox % "key: " key ", appDesc.key: " appDesc.key ; keys comparison
    if (key = appDesc.key) {
      ;MsgBox % "app: " appDesc "( " appDesc.path ", " appDesc.wndClass " )" ; found appDesc
      return appDesc
    }
  }
}

Class AppDesc {
  __New(key, path, wndClass) {
    this.key := key, this.path := path, this.wndClass := wndClass
  }
}