global appDescs := Object()
portableDir := A_WorkingDir "\..\.."

appDescs.Insert(new AppDesc("n", "Notepad.exe", "Notepad"))
appDescs.Insert(new AppDesc("s", "cmd.exe", "ConsoleWindowClass"))
appDescs.Insert(new AppDesc("c", "calc.exe", "CalcFrame"))
appDescs.Insert(new AppDesc("f", portableDir "\totalcmd\TOTALCMD64.EXE", "TTOTAL_CMD"))
appDescs.Insert(new AppDesc("v", portableDir "\VLC\vlc.exe", "QWidget"))
appDescs.Insert(new AppDesc("m", portableDir "\AIMP3\AIMP3.exe", "TAIMPMainForm"))
appDescs.Insert(new AppDesc("b", portableDir "\stduViewer\STDUViewerApp.exe", "STDUViewerMainWindowClass"))
appDescs.Insert(new AppDesc("t", portableDir "\uTorrent\uTorrent.exe", "µTorrent4823DF041B09"))
appDescs.Insert(new AppDesc("x", portableDir "\np++\notepad++.exe", "Notepad++"))
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

ToggleActive(wndClass) {
  if (wndClass = "µTorrent4823DF041B09") {
    UTorrentToggle(wndClass)
    return
  }
  IfWinNotActive, % "ahk_class " wndClass 
  {
    WinActivate, % "ahk_class " wndClass
  }
  else
  {
    WinMinimize, % "ahk_class " wndClass
  }
}

UTorrentToggle(wndClass) {
  ;SetTitleMatchMode, Regex 
  ;PostMessage, WM_COMMAND := 0x111, UTM_HIDESHOW := 60, 0,, \xb5Torrent
  hWnd := DllCall( "FindWindow", Str,wndClass, Int,0 ), TC := A_TickCount 
  DllCall( "PostMessage", UInt,hWnd, UInt,0x111, UInt,60, Int,0 )
}

UTorrentFromURL() {
  ;SetTitleMatchMode, Regex
  ;PostMessage, WM_COMMAND := 0x111, UTM_HIDESHOW := 60, 0,, \xb5Torrent
  ;PostMessage, WM_COMMAND := 0x111, UTM_HIDESHOW := 73, 0,, \xb5Torrent
  wndClass := "µTorrent4823DF041B09"
  hWnd := DllCall( "FindWindow", Str,wndClass, Int,0 ), TC := A_TickCount 
  IfWinNotActive, % "ahk_class " wndClass 
  {
    DllCall( "PostMessage", UInt,hWnd, UInt,0x111, UInt,60, Int,0 )
  }
  DllCall( "PostMessage", UInt,hWnd, UInt,0x111, UInt,73, Int,0 )
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