#Include Ancillary.ahk

Loop, %0%  ; For each parameter:
{
    param := %A_Index%     ; Fetch the contents of the variable whose name is contained in A_Index.
    if (param = "noIcon") {
      TimedTooltip(A_ScriptName " started with noIcon arg", TooltipTime)
      Menu, Tray, NoIcon
	  noIcon := true
    }
}

/*
~LWin::
  if (noIcon) {
    Menu, Tray, Icon
  }
return

~LWin Up::
  if (noIcon) {
    Menu, Tray, NoIcon
  }
return
*/

global appBrightnessPath := A_WorkingDir "\DisplayBrightnessConsole.exe"
global scriptBrightnessPath := A_WorkingDir "\brightnessToFileHidden.vbs"
global fileBrightnessPath := A_WorkingDir "\current_brightness.txt"
global brightnessIncrement := 5
global savedBrightness := 0
global defaultBrightness := 60

;-------------------------------------------------------brightness HKs
LWin & Q::
  brightness := getBrightness()
  setBrightness(brightness + brightnessIncrement)
  brightness := getBrightness()
  TimedTooltip("Brightness+: " brightness, TooltipBrightnessTime)
return

LWin & A::
  brightness := getBrightness()
  setBrightness(brightness - brightnessIncrement)
  brightness := getBrightness()
  TimedTooltip("Brightness-: " brightness, TooltipBrightnessTime)
return

LWin & Z::
  brightness := getBrightness()
  if (brightness != 0) {
    savedBrightness := brightness
	setBrightness(0)
  }
  else {
    if (savedBrightness = 0) {
      savedBrightness := defaultBrightness
    }
    setBrightness(savedBrightness)
  }
  brightness := getBrightness()
  TimedTooltip("Brightness: " brightness, TooltipBrightnessTime)
return

;==========================================================brightness control
getBrightness() {
  FileDelete, % fileBrightnessPath
  while (FileExist(fileBrightnessPath) != "") {
    TimedTooltip(i++, TooltipBrightnessTime)
    Sleep, FileWrightSleepTime
  }
  ;Run, % "cmd.exe " appPath ">" filePath
  Run, % scriptBrightnessPath
  while (bri = "") {
    Sleep, FileWrightSleepTime
    FileRead, bri, % fileBrightnessPath
  }
  bri := Trim(bri, "`r`n")
  return bri
}

setBrightness(brightness) {
  Run, % appBrightnessPath " " brightness
}