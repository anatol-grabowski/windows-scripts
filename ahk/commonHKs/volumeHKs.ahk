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

;==============================================
#Include %A_ScriptDir%\Ancillary.ahk

;-----------------------sound HKs
LWin & W::
  Send, {Volume_Up 1}
  volumeTooltip()
return

LWin & S::
  Send, {Volume_Down 1}
  volumeTooltip()
return

LWin & X::
  Send, {Volume_Mute}
  volumeTooltip()
return

;=================================================================================================
volumeTooltip() {
  if !TooltipVolumeTime
    return
  SoundGet, volume, MASTER, VOLUME
  TimedTooltip("Volume: " round(volume) "%", TooltipVolumeTime)
}
;=================================================================================================