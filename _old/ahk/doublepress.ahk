`::
	Hotkey, ``, Off
	Input, key, L1 T0.5
	if (ErrorLevel = "Timeout") {
		send, ``
		Hotkey, ``, On
		return
	}
	if (key != "``") {
		send, ``%key%
		Hotkey, ``, On
		return
	}
	Hotkey, ``, On
	send, c
return

c & r::
	Reload
return
