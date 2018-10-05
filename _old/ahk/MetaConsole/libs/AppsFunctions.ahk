UTorrentFromURL() {
  ;SetTitleMatchMode, Regex
  ;PostMessage, WM_COMMAND := 0x111, UTM_HIDESHOW := 60, 0,, \xb5Torrent
  ;PostMessage, WM_COMMAND := 0x111, UTM_HIDESHOW := 73, 0,, \xb5Torrent
  wndClass := "µTorrent4823DF041B09"
  hWnd := DllCall( "FindWindow", Str, wndClass, Int, 0 )
  IfWinNotActive, % "ahk_class " wndClass 
  {
    DllCall( "PostMessage", UInt,hWnd, UInt,0x111, UInt,60, Int,0 )
  }
  DllCall( "PostMessage", UInt,hWnd, UInt,0x111, UInt,73, Int,0 )
}


StartPath(path) {
	console.Accept("Start " path)
	Run, % path	
}


RunCmdInFolder() {
	temp := Clipboard
	SendMessage 1075, 2029, 0, , ahk_class TTOTAL_CMD
	path := Clipboard
	Clipboard := temp
	com_to_run := Path_commandlineshell " /K cd /d " path
	Run, % path
}

RunOrActivateApp(path, wnd) {
  SplitPath, path, process
  Process, Exist, %process%
  If !ErrorLevel {
    Run, % path
  }
  else {
    WinActivate, % wnd
  }
}

GetFilesFromDir(dir, mask) {
Loop, % dir "\" mask, 0
	{
		files := files A_LoopFileName "`n"
	}
	Loop, % dir "\" mask, 2
	{
		files := files A_LoopFileName "\" "`n"
	}
	return SubStr(files, 1, StrLen(files)-1)
}
