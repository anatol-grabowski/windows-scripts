portableDir := A_WorkingDir "\..\.."

global notepad := new application("Notepad.exe", "ahk_class Notepad")
global cmd := new application("cmd.exe", "ahk_class ConsoleWindowClass")
global calc := new application("calc.exe", "ahk_class CalcFrame")
global totalcmd := new application(portableDir "\totalcmd\TOTALCMD64.EXE", "ahk_class TTOTAL_CMD")
global vlc := new application(portableDir "\VLC\vlc.exe", "ahk_class QWidget")
global aimp := new application(portableDir "\AIMP3\AIMP3.exe", "ahk_class TAIMPMainForm")
global stdu := new application(portableDir "\stduViewer\STDUViewerApp.exe", "ahk_class STDUViewerMainWindowClass")
global uTorrent := new application(portableDir "\uTorrent\uTorrent.exe", "ahk_class µTorrent4823DF041B09")
global nppp := new application(portableDir "\np++\notepad++.exe", "ahk_class Notepad++")
global chrome := new application("c:\Program Files (x86)\Google\Chrome\Application\chrome.exe", "ahk_class Chrome_WidgetWin_1")

#WinActivateForce
DetectHiddenWindows, on
;==============================================================================================
Run(application) {
  path := application.path
  Run, %path%
}

RunOrToggle(application) {
  path := application.path
  SplitPath, path, process
  Process, Exist, %process%
  If !ErrorLevel {
    Run, %path%
  }
  else {
    Toggle(application.window)
  }
}

Toggle(window) {
  IfWinNotActive, % window 
  {
    WinActivate, % window
  }
  else
  {
    WinMinimize, % window
  }
}


Close(application) {
  path := application.path
  SplitPath, path, process
  Process, Exist, %process%
  If !ErrorLevel {
    return
  }
  else {
    window := application.window
    WinClose, % window
  }
}

UTorrentToggle() {
  ;SetTitleMatchMode, Regex 
  ;PostMessage, WM_COMMAND := 0x111, UTM_HIDESHOW := 60, 0,, \xb5Torrent
  hWnd := DllCall( "FindWindow", Str, uTorrent.window, Int,0 ), TC := A_TickCount 
  DllCall( "PostMessage", UInt,hWnd, UInt,0x111, UInt,60, Int,0 )
}

UTorrentFromURL() {
  ;SetTitleMatchMode, Regex
  ;PostMessage, WM_COMMAND := 0x111, UTM_HIDESHOW := 60, 0,, \xb5Torrent
  ;PostMessage, WM_COMMAND := 0x111, UTM_HIDESHOW := 73, 0,, \xb5Torrent
  hWnd := DllCall( "FindWindow", Str,uTorrent.window, Int,0 ), TC := A_TickCount 
  IfWinNotActive, % uTorrent.window 
  {
    DllCall( "PostMessage", UInt,hWnd, UInt,0x111, UInt,60, Int,0 )
  }
  DllCall( "PostMessage", UInt,hWnd, UInt,0x111, UInt,73, Int,0 )
}
;==============================================================================================

Class application {
  __New(path, window) {
    this.path := path, this.window := window
  }
}