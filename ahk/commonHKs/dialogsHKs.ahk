;=========== COMMON HEADER ========================
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

;============= SCRIPT =======================
#IfWinActive, ahk_class #32770 ; dialog window class

F1::
~LWin & o::
~RWin & o::
	tempClip  := ClipboardAll
	SendMessage 1075, 2029, 0, , ahk_class TTOTAL_CMD ; cm_CopySrcPathToClip=2029
	setDialogPath(Clipboard)
	Clipboard := tempClip   ; restore clipboard (not ClipboardAll)
	tempClip  := ""
return
F2::
	tempClip  := ClipboardAll
	SendMessage 1075, 2030, 0, , ahk_class TTOTAL_CMD ; cm_CopyTargetPath
	setDialogPath(Clipboard)
	Clipboard := tempClip   ; restore clipboard (not ClipboardAll)
	tempClip  := ""
return

F3::
	EnvGet, totdir, TOT_DIR
	setDialogPath(totdir)
return
F4::
	EnvGet, dowbrdir, TOT_DOWB
	setDialogPath(dowbrdir)
return

F8::
	setDialogPath(Clipboard)
return

setDialogPath(p) {
	ControlFocus Edit1, ahk_class #32770
	ControlSetText Edit1, %p%, ahk_class #32770
	SendInput {Enter}
}
