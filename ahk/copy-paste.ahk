~F11::
	;if (A_PriorHotkey <> "~LControl" or A_TimeSincePriorHotkey > 400) {
		;KeyWait, LControl
		;return
	;}

	Send {Alt Down}{Tab}
	Sleep 50
	Send {Alt Up}

	Tooltip, Select text to copy., 300, 5
	KeyWait, LButton, D T15
	if (ErrorLevel = 1) {
		Goto, RemoveTooltip
	}
	KeyWait, LButton

	Send {Ctrl Down}{c}
	Sleep 50
	Send {Ctrl Up}

	Send {Alt Down}{Tab}
	Sleep 50
	Send {Alt Up}

	Tooltip, Select text to paste over., 300, 5
	KeyWait, LButton, D T15
	if (ErrorLevel = 1) {
		Goto, RemoveTooltip
	}
	KeyWait, LButton

	Send {Ctrl Down}{v}
	Sleep 50
	Send {Ctrl Up}

	Sleep 200
	Send {Ctrl}
	Sleep 300
	Send {C}

RemoveTooltip:
	Tooltip
	
return


~F9::
	Send {Alt Down}{Tab}
	Sleep 50
	Send {Alt Up}

	Tooltip, Select text to copy., 300, 5
	KeyWait, LButton, D T15
	if (ErrorLevel = 1) {
		Goto, RemoveTooltip2
	}
	KeyWait, LButton

	Send {Ctrl Down}{c}
	Sleep 50
	Send {Ctrl Up}

	Send {Alt Down}{Tab}
	Sleep 50
	Send {Alt Up}

	Tooltip, Select text to paste over., 300, 5
	KeyWait, LButton, D T15
	if (ErrorLevel = 1) {
		Goto, RemoveTooltip2
	}
	KeyWait, LButton

	Send {Ctrl Down}{v}
	Sleep 50
	Send {Ctrl Up}

	Sleep 200
	Send {Alt}
	Sleep 200
	Send {z}
	Sleep 50
	Send {a}{a}
	Sleep 50
	Send {T}{i}{m}{Enter}

	Sleep 100
	Send {Alt}
	Sleep 100
	Send {z}
	Sleep 50
	Send {a}{h}
	Sleep 50
	Send {1}{6}{Enter}

RemoveTooltip2:
	Tooltip
	
return
