;============COMMON HEADER=========================
#SingleInstance force
Loop, %0%  ; For each parameter:
{
	param := %A_Index%   ; Fetch contents of variable which name is in A_Index.
	if (param = "noIcon") {
		Menu, Tray, NoIcon
		noIcon := true
	}
}

#Include %A_ScriptDir%\Ancillary.ahk

global WheelScrollMultiplier 		:= 3
global IsMouseSlow 							:= false
global SlowMouseSpeed      			:= 10
global NormalMouseSpeed    			:= 20
global MouseThreshold1     			:= 1
global MouseThreshold2     			:= 3
global MouseEnhance        			:= 2

global SPI_SETWHEELSCROLLLINES 	:= 0x69
global SPI_GETMOUSESPEED   			:= 0x70
global SPI_SETMOUSESPEED   			:= 0x71
global SPI_SETMOUSE        			:= 0x04
;________________________________________________________________________________________________

;LWin Up::   toggleMouseSpeed()

;LAlt:: DllCall("SystemParametersInfo", UInt,SPI_SETWHEELSCROLLLINES, UInt,6, UInt,0, UInt,0)
;LAlt Up:: DllCall("SystemParametersInfo", UInt,SPI_SETWHEELSCROLLLINES, UInt,3, UInt,0, UInt,0)

;-----------------------mouse slowdown HK
~LWin::
  if (IsMouseSlow) {
    return
  }
  IsMouseSlow := true
  setMouseSpeed(SlowMouseSpeed)
  
  if (noIcon) {
    Menu, Tray, Icon
  }
return

~LWin Up::
  IsMouseSlow := false
  setMouseSpeed(NormalMouseSpeed)
  
  if (noIcon) {
    Menu, Tray, NoIcon
  }
return

;-----------------------wheel speed up 
LWin & WheelDown::
  Loop, % WheelScrollMultiplier {
    Send, {WheelDown}
    Sleep, % TimeBetweenSends
  }
return

LWin & WheelUp::
  Loop, % WheelScrollMultiplier {
    Send, {WheelUp}
    Sleep, % TimeBetweenSends
  }
return

;-----------------------wheel horizontal scrolling 
LShift & WheelDown:: 
  Send, {WheelRight}
  Sleep, % TimeBetweenSends
  Send, {WheelRight}
return

LShift & WheelUp:: 
  Send, {WheelLeft}
  Sleep, % TimeBetweenSends
  Send, {WheelLeft}
return

;-----------------------find selected
LCtrl & f::
  if (A_PriorHotkey <> A_ThisHotkey or A_TimeSincePriorHotkey > TimeDoublePress) {
    global SelectedText := GetSelection()
    Sleep, % TimeBetweenSends
    Send ^f
    return
  }
  temp := ClipboardAll
  Clipboard := SelectedText
  Sleep, % TimeBetweenSends
  Send ^v
  Clipboard := temp
	temp := ""
  SelectedText := ""
return

;-----------------------replace selected
LCtrl & h::
  if (A_PriorHotkey <> A_ThisHotkey or A_TimeSincePriorHotkey > TimeDoublePress) {
    global SelectedText := GetSelection()
    Sleep, % TimeBetweenSends
    Send ^h
    return
  }
  temp := ClipboardAll
  Clipboard := SelectedText
	Sleep, % TimeBetweenSends
  Send ^v
  Clipboard := temp
	temp := ""
  SelectedText := ""
return

;=================================================================================================
setMouseSpeed(speed) {
  ;TimedTooltip(speed, 500)
  DllCall("SystemParametersInfo", UInt,SPI_SETMOUSESPEED, UInt,0, UInt, speed, UInt,0)
  ;Restore the original speed acceleration thresholds and speed
  ;VarSetCapacity(MySet, 32, 0) 
  ;InsertInteger(MouseThreshold1, MySet, 0)
  ;InsertInteger(MouseThreshold2, MySet, 4)
  ;InsertInteger(MouseEnhance   , MySet, 8)
  ;DllCall("SystemParametersInfo", UInt,SPI_SETMOUSE, UInt,0, Str,MySet, UInt,1)
}

InsertInteger(pInteger, ByRef pDest, pOffset = 0, pSize = 4) {
    ; Copy each byte in the integer into the structure as raw binary data. 
    Loop %pSize%
    DllCall("RtlFillMemory", "UInt",&pDest + pOffset + A_Index-1, "UInt", 1, "UChar", pInteger >> 8*(A_Index-1) & 0xFF) 
}
;=================================================================================================