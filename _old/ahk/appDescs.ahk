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
DetectHiddenWindows, on
;=============================================================================================
RunOrToggleApp(appDesc) {
  DeactivateHKs("")
  path := appDesc.path
  if (!appDesc) {
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

CloseApp(appDesc) {
  path := appDesc.path
  if (!appDesc) {
    return
  }
  ;MsgBox % "app: " appDesc "( " appDesc.path ", " appDesc.wndClass " )" ;app to run/toggle
  SplitPath, path, process
  Process, Exist, %process%
  If !ErrorLevel {
    
  }
  else {
    wndClass := appDesc.wndClass
    WinClose, % "ahk_class " wndClass
  }
}
;===============================================================================================
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