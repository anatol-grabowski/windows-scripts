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
global turns := 0
global doHide := 1

~WheelDown::
	if (A_PriorHotkey = A_ThisHotkey) {
		turns := 1
	} else {
		turns := turns + 1
	}
	SetTimer, ResetTurns, 800
	if (turns = 1) {
		doHide := 1
	}
	CheckTurns()
return

~WheelUp::
	if (A_PriorHotkey = A_ThisHotkey) {
		turns := 1
	} else {
		turns := turns + 1
	}
	SetTimer, ResetTurns, 800
	if (turns = 1) {
		doHide := 0
	}
	CheckTurns()
return


ResetTurns:
	SetTimer, ResetTurns, Off
	turns := 0
return

CheckTurns() {
	;ToolTip, turns: %turns%`nhide: %doHide%
	;SetTimer, RemoveToolTip, 2000
	if (turns >= 4) {
		SetTimer, ResetTurns, Off
		turns := 0
		if (doHide = 1) {
			Boss()
		} else {
			Unboss()
		}
	}
}


Boss() {
	;Run cmd /c start "" "%TOT_CORE%/totalcmd/TOTALCMD" "/O"
	WinActivate, % "ahk_class TTOTAL_CMD"
}

Unboss() {
	Send {Alt Down}{Tab}
	Sleep 50
	Send {Alt Up}
}


RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	ToolTip
return