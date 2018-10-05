#SingleInstance force

#include %A_ScriptDir%\..\libs\Pathes.ahk
#include %A_ScriptDir%\..\libs\AHKPanic.ahk
#include %A_ScriptDir%\..\libs\AppsFunctions.ahk
#include %A_ScriptDir%\..\libs\TotalCmdFuncs.ahk
#include %A_ScriptDir%\MetaConsole.ahk


global console := new MetaConsole()
console.x := 5
console.w := 800
console.commText := "MetaConsole started."
console.descrText := "  Press '~' twice to enter command."
console.delay := 1000
console.Display()


killscripts := new CommandFunc(Func("AHKPanic").Bind(1, 0, 0, 0), "Kill all scripts.")
killALLscripts := new CommandFunc(Func("AHKPanic").Bind(1, 0, 0, 1), "Kill all scripts including this.")
torFromUrl := new CommandFunc(Func("UTorrentFromURL"), "Add torrent from URL.")
cmdInFolder := 	new CommandFunc(Func("RunCmdInFolder"), "Run cmd in selected folder.")
tcmdcdx := 	new CommandFunc(Func("CDX"))

;"command", autoaccept, hintdelay, function
console.commands.Insert( new MetaCommand( "cc", 1, 3000, cmdInFolder ))
console.commands.Insert( new MetaCommand( "cmd", 1, 3000, 	new CommandFunc(Func("StartPath").Bind(Path_commandlineshell)) ))

console.commands.Insert( new MetaCommand( "calc", 1, 3000, 	new CommandFunc(Func("StartPath").Bind(Path_calculator)) ))
console.commands.Insert( new MetaCommand( "c", 0, 3000, 	new CommandFunc(Func("StartPath").Bind(Path_calculator)) ))

console.commands.Insert( new MetaCommand( "reg", 1, 3000, 	new CommandFunc(Func("StartPath").Bind(Path_regedit)) ))

console.commands.Insert( new MetaCommand( "n", 0, 3000, 	new CommandFunc(Func("StartPath").Bind(Path_notepad)) ))
console.commands.Insert( new MetaCommand( "nn", 1, 3000, 	new CommandFunc(Func("StartPath").Bind(Path_notepad)) ))
console.commands.Insert( new MetaCommand( "npp", 1, 3000, 	new CommandFunc(Func("StartPath").Bind(Path_texteditor)) ))

console.commands.Insert( new MetaCommand( "kk", 0, 3000, killscripts) )
console.commands.Insert( new MetaCommand( "kkkk", 1, 3000, killALLscripts) )
console.commands.Insert( new MetaCommand( "ttt", 1, 3000, torFromUrl) )

console.commands.Insert( new MetaCommand( "ww", 1, 3000, 	new CommandFunc(Func("TcmdToggleWindowed")) ))
console.commands.Insert( new MetaCommand( "cdx", 0, 3000, tcmdcdx) )
console.commands.Insert( new MetaCommand( "f", 1, -1, tcmdcdx) )


`::
	KeyWait, ``
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
	console.Start()
return

~` & r::
	Reload
return