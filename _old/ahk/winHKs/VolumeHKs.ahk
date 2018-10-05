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