#include libs\Ancillary.ahk
#include libs\SimpleHKSequence.ahk
#include libs\Pathes.ahk
#include libs\AHKPanic.ahk
#include libs\AppsFunctions.ahk

ShowHint("Script started", 2000)

EndSeqStr := "]"
startSeqStr := "["

RAlt & LAlt::
LAlt & LWin::
	InSeq := InSeq startSeqStr
	ShowHint("Command: " InSeq, SeqTimeout)
	startSeq()
return

updSeq() {
	if (InSeq = "End") {
		return
	} if (InSeq = "Timeout") {
		ShowHint(InSeq, 1000, 0xFFFF0000)
		return
	} 
	else if (InSeq = "Cancel") {
		ShowHint(InSeq, 200, 0xFFFF0000)
		return
	}
	else {
		ShowHint("Command: " InSeq, SeqTimeout)
	}
	
	ParseSequence()	
}


ParseSequence() {
	splitted := StrSplit(InSeq)

	;folders
	if (InSeq = "[0") {
		com_to_run := Path_filemanager " /O /S /L=" Path_tot
	} 
	else if (InSeq = "[1") {
		com_to_run := Path_filemanager " /O /S /L=" Path_data
	} 
	else if (InSeq = "[2") {
		com_to_run := Path_filemanager " /O /S /L=" Path_downloads
	} 
	else if (InSeq = "[21") {
			com_to_run := Path_filemanager " /O /S /L=" Path_browserdownloads
	} 
	else if (InSeq = "[3") {
		com_to_run := Path_filemanager " /O /S /L=" Path_projects
	} 
	else if (InSeq = "[4") {
		com_to_run := Path_filemanager " /O /S /L=" Path_programming
	} 
	else if (InSeq = "[5") {
		com_to_run := Path_filemanager " /O /S /L=" Path_portable
	} 
	else if (InSeq = "[51") {
			com_to_run := Path_filemanager " /O /S /L=" Path_basicapps
	}
	else if (InSeq = "[511") {
			com_to_run := Path_filemanager " /O /S /L=" Path_scripts
	}
	else if (InSeq = "[6") {
		com_to_run := Path_filemanager " /O /S /L=" Path_installs
	}
	else if (InSeq = "[7") {
		com_to_run := Path_filemanager " /O /S /L=" Path_working
	}
	else if (InSeq = "[8") {
		com_to_run := Path_filemanager " /O /S /L=" Path_games
	}
	
	;urls
	else if (InSeq = "[b gs") {
		com_to_run := Url_googlesearch
		EndSeq()
	}
	else if (InSeq = "[b gm") {
		com_to_run := Url_googlemaps
		EndSeq()
	}
	else if (InSeq = "[b gp") {
		com_to_run := Url_googlmymap
		EndSeq()
	}
	else if (InSeq = "[b tpb") {
		com_to_run := Url_piratebay
		EndSeq()
	}
	else if (InSeq = "[b kat") {
		com_to_run := Url_kickass
		EndSeq()
	}
	else if (InSeq = "[b imdb") {
		com_to_run := Url_imdb
		EndSeq()
	}
	else if (InSeq = "[b se") {
		com_to_run := Url_stackexchange
		EndSeq()
	}
	else if (InSeq = "[b so") {
		com_to_run := Url_stackoverflow
		EndSeq()
	}
	else if (InSeq = "[b sp") {
		com_to_run := Url_southpark
		EndSeq()
	}
	else if (InSeq = "[b zh-mn") {
		com_to_run := Url_zhodinominsk
		EndSeq()
	}
	else if (InSeq = "[b mn-zh") {
		com_to_run := Url_minskzhodino
		EndSeq()
	}
	else if (InSeq = "[b zh-zh") {
		com_to_run := Url_zhodinozhodino
		EndSeq()
	}
	
	;apps
	else if (InSeq = "[ff") {
		com_to_run := Path_filemanager " /O"
		EndSeq()
	}
	else if (InSeq = "[n]") {
		com_to_run := Path_notepad
	}
	else if (InSeq = "[c]") {
		temp := Clipboard
		SendMessage 1075, 2029, 0, , ahk_class TTOTAL_CMD
		path := Clipboard
		Clipboard := temp
		com_to_run := Path_commandlineshell " /K cd /d " path
	}
	else if (InSeq = "[cc") {
		com_to_run := Path_calculator
		EndSeq()
	}
	else if (InSeq = "[r]") {
		com_to_run := Path_regedit
	}
	else if (InSeq = "[nn") {
		com_to_run := Path_texteditor
		EndSeq()
	}
	else if (InSeq = "[vv") {
		com_to_run := Path_videoplayer
		EndSeq()
	}
	else if (InSeq = "[aa") {
		com_to_run := Path_audioplayer
		EndSeq()
	}
	else if (InSeq = "[tt") {
		com_to_run := Path_torrentclient
	}
	else if (InSeq = "[ttt") {
		UTorrentFromURL()
		hint := "Add torrent by URL"
		EndSeq()
	}
	

	else if (InSeq = "[kk]") {
		hint := "Kill all scripts."
		AHKPanic(1, 0, 0, 0)
	}
	else if (InSeq = "[kkk") {
		AHKPanic(1, 0, 0, 1)
	}
	
	
	else if (splitted[splitted.MaxIndex()] = "]"){
		ShowHint(HintText "`n    No such command.", 1000, 0xFFFF0000)
		EndSeq()
		return
	}
	
	
	
	
	if (com_to_run) {
		Run, % com_to_run
		hint := com_to_run
	}
	if (hint) {
		;TimedTooltip(hint, 4000)
		if (splitted[splitted.MaxIndex()] = "]") {
			ShowHint(HintText "`n   " hint, 4000, 0xFF00FF00)
		} else {
			ShowHint(HintText "`n   " hint, 10000)
			}
	} else {
		ShowHint(HintText "`n   ...", 10000)
	}
}




