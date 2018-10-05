
#include gdip\Gdip.ahk
#include gdip\GdipHelper.ahk

global TimeDoublePress := 400
global TimeMultiPress := 1000
global TimeBetweenSends := 10
global TooltipTime := 1500
global TooltipSelToFileTime := 4000
global TooltipVolumeTime := 0
global TooltipBrightnessTime := 1500
global FileWrightSleepTime := 100


global HintText := ""

global LogLevel := 10
;_________________________________________________________________________________________________

;--------------------------------------timed tooltip
TimedTooltip(text, time, x=-1, y=-1) {
	if (x=-1) {
		Tooltip, % text
	}	else {
		Tooltip, % text, x, y
	}
  fn := Func("HideTooltip")
  SetTimer, % fn, % -time
}

HideTooltip() {
  Tooltip
}

ShowHint(text, time, color=0xD0F0F0FF) {
	HintText := text
	x := 5
	y := A_ScreenHeight-115
	h := 50
	w := StrLen(text)*10.4 + 10
	StartDrawGDIP()
		SetBrushColor(color)
		Gdip_FillRectangle(G, pBrush, x, y, w, h)
	
		Gdip_TextToGraphics(G, HintText, "x" x+5 "y" y+5 "cff000000 s18", "Arial")
	EndDrawGDIP()
	
	fn := Func("HideHint")
  SetTimer, % fn, % -time
}

HideHint() {
	HintText := ""
	ClearDrawGDIP()
}


;--------------------------------------get selection
GetSelection() {
  Log(1, "GetSelection(), save clipboard = " Clipboard)
  savedClipboard := Clipboard
  Clipboard := ""
  Send ^c
  Sleep, TimeBetweenSends
  selection := Clipboard
  Log(1, "GetSelection(), get selection = " selection)
  Clipboard := savedClipboard
  Log(1, "GetSelection(), restore clipboard = " Clipboard)
  return selection
}

;--------------------------------------validify path
CheckIfPathValid(path, defaultPath) {
  checkIfPathValidLogLevel := 1
  SplitPath, defaultPath, defName, defDir
  SplitPath, path, name, , extension
  Log(checkIfPathValidLogLevel, "CheckIfPathValid(), path = " path)
  if( !InStr(path, "\") ) {
    Log(checkIfPathValidLogLevel, "CheckIfPathValid(), path wasn't \ = " path)
    path := defDir "\" name ".txt"
    Log(checkIfPathValidLogLevel, "CheckIfPathValid(), new path = " path)
  }
  else if( InStr( FileExist(path), "D") ) {
    Log(checkIfPathValidLogLevel, "CheckIfPathValid(), path was D = " path)
    path := path "\" defName
    Log(checkIfPathValidLogLevel, "CheckIfPathValid(), new path = " path)
  }
  else if (extension <> "txt") {
    Log(checkIfPathValidLogLevel, "CheckIfPathValid(), bad extension = " path)
    path := defaultPath
    Log(checkIfPathValidLogLevel, "CheckIfPathValid(), new path = " path)
  }
  return path
}

;---------------------------------------log
Log(level, entry) {
  if (level < LogLevel)
    return
  FileAppend, % A_Now ": " entry "`n", % A_WorkingDir "\log.txt"
}