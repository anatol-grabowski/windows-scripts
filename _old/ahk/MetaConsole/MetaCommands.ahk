#include ..\libs\Pathes.ahk
#include ..\libs\AHKPanic.ahk
#include ..\libs\AppsFunctions.ahk
#include MetaConsole.ahk


global console := new MetaConsole()
console.commText := "MetaConsole started."
console.descrText := "  Press '~' to enter command."
console.delay := 3000
console.Display()


killscripts := new CommandFunc(Func("AHKPanic").Bind(1, 0, 0, 0), "Kill all scripts.")
killALLscripts := new CommandFunc(Func("AHKPanic").Bind(1, 0, 0, 1), "Kill all scripts including this.")
torFromUrl := new CommandFunc(Func("UTorrentFromURL"), "Add torrent from URL.")
cmdInFolder := 	new CommandFunc(Func("RunCmdInFolder"), "Run cmd in selected folder.")
tcmdcdx := 	new CommandFunc(Func("CDX"))

console.commands.Insert( new MetaCommand( "cc", 1, 3000, cmdInFolder ))
console.commands.Insert( new MetaCommand( "cmd", 1, 3000, 	new CommandFunc(Func("StartPath").Bind(Path_commandlineshell)) ))

console.commands.Insert( new MetaCommand( "calc", 1, 3000, 	new CommandFunc(Func("StartPath").Bind(Path_calculator)) ))
console.commands.Insert( new MetaCommand( "c", 0, 3000, 	new CommandFunc(Func("StartPath").Bind(Path_calculator)) ))

console.commands.Insert( new MetaCommand( "reg", 1, 3000, 	new CommandFunc(Func("StartPath").Bind(Path_regedit)) ))

console.commands.Insert( new MetaCommand( "n", 0, 3000, 	new CommandFunc(Func("StartPath").Bind(Path_notepad)) ))
console.commands.Insert( new MetaCommand( "nn", 1, 3000, 	new CommandFunc(Func("StartPath").Bind(Path_notepad)) ))
console.commands.Insert( new MetaCommand( "npp", 1, 3000, 	new CommandFunc(Func("StartPath").Bind(Path_texteditor)) ))

console.commands.Insert( new MetaCommand( "aimp", 1, 3000, 	new CommandFunc(Func("StartPath").Bind(Path_audioplayer)) ))

console.commands.Insert( new MetaCommand( "kk", 0, 3000, killscripts) )
console.commands.Insert( new MetaCommand( "kkkk", 1, 3000, killALLscripts) )
console.commands.Insert( new MetaCommand( "ttt", 1, 3000, torFromUrl) )

console.commands.Insert( new MetaCommand( "ww", 1, 3000, 	new CommandFunc(Func("TcmdToggleWindowed")) ))
console.commands.Insert( new MetaCommand( "cdx", 0, 3000, tcmdcdx) )
console.commands.Insert( new MetaCommand( "f", 1, -1, tcmdcdx) )


`::
	console.Start()
return

` & r::
	Reload
return


