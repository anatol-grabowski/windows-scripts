#include ..\libs\gdip\Gdip.ahk
#include ..\libs\gdip\GdipHelper.ahk

global HintCommand := new Hint("", 22, , 5, A_ScreenHeight-130, 700, -1)
global HintDescription := new Hint("", 18, 0xFFE0E0FF)
global MetaHintDelay := 3000

Max(var1, var2) {
	return var1 > var2 ? var1 : var2
}


MetaConsoleDisplay() {
	HintCommand.CountWH()
	HintDescription.CountWH()
	HintDescription.x := HintCommand.x
	HintDescription.y := HintCommand.y + HintCommand.h
	w := Max(HintDescription.w, HintCommand.w)
	w := Max(w, 700)
	HintCommand.w := w
	HintDescription.w := w
	StartDrawGDIP()
		SetBrushColor(HintCommand.color)
		Gdip_FillRectangle(G, pBrush, HintCommand.x, HintCommand.y, HintCommand.w, HintCommand.h)
		Gdip_TextToGraphics(G, HintCommand.text, "x" HintCommand.x+5 "y" HintCommand.y+5 "cff000000 s" HintCommand.size, "Arial")
		SetBrushColor(HintDescription.color)
		Gdip_FillRectangle(G, pBrush, HintDescription.x, HintDescription.y, HintDescription.w, HintDescription.h)
		Gdip_TextToGraphics(G, HintDescription.text, "x" HintDescription.x+5 "y" HintDescription.y+5 "cff000000 s" HintDescription.size, "Arial")
	EndDrawGDIP()
	
	if (MetaHintDelay != -1) {
		fn := Func("HideHints")
		SetTimer, % fn, % -MetaHintDelay
	}
}

HideHints() {
	ClearDrawGDIP()
	HintCommand.w := -1
	HintDescription.w := -1
}

Class MetaConsole {

	__New() {
		this.on := 0,
		this.timeout := 10000,
		this.command := "",
		
		this.delay := -1,
		this.x := 5,
		this.w := 700,
		
    this.commText := "", 
		this.commColor := 0xFFFFFFFF, 
		this.commH := -1,
		this.commSize := 22,
		this.commY := A_ScreenHeight-130,
		
		this.descrText := "", 
		this.descrColor := 0xFFE0E0FF, 
		this.descrH := -1,
		this.descrSize := 18,
		this.descrY := -1
  }
	
	CountWH() {
		splitted := StrSplit(this.commText, "`n")
		h1 := splitted.MaxIndex()*this.commSize*1.1 +10
		splitted := StrSplit(this.descrText, "`n")
		h2 := splitted.MaxIndex()*this.descrSize*1.1 +10
		w1 := StrLen(this.commText)*(this.commSize/18*10.4) + 10
		w2 := StrLen(this.descrText)*(this.descrSize/18*10.4) + 10
		w := 700
		w := w1 > w2 ? w1 : w2
		if (this.commH < h1) {
			this.commH := h1
		}
		if (this.descrH < h2) {
			this.descrH := h2
		}
		if (this.w < w) {
			this.w := w
		}
		this.descrY := this.commY + this.commH		
	}
	
	Display() {
		this.CountWH()
		StartDrawGDIP()
			SetBrushColor(this.commColor)
			Gdip_FillRectangle(G, pBrush, this.x, this.commY, this.w, this.commH)
			Gdip_TextToGraphics(G, this.commText, "x" this.x+5 "y" this.commY+5 "cff000000 s" this.commSize, "Arial")
			SetBrushColor(this.descrColor)
			Gdip_FillRectangle(G, pBrush, this.x, this.descrY, this.w, this.descrH)
			Gdip_TextToGraphics(G, this.descrText, "x" this.x+5 "y" this.descrY+5 "cff000000 s" this.descrSize, "Arial")
		EndDrawGDIP()
	
		if (this.delay != -1) {
			fn := Func("ClearDrawGDIP")
			SetTimer, % fn, % -this.delay
		}
	}
	
	Start() {
		this.on := 1
		
		this.commText := "> "
		this.commColor := 0xFFFFFFFF
		this.descrText := "  Enter command..."
		this.descrColor := 0xFFE0E0FF
		this.delay := this.timeout
		this.Display()
		
		loop {
			if (!this.on) {
				break
			}
			Input, char, L1 T10, {Enter}{Esc}
			if (ErrorLevel = "Timeout") {
				this.descrColor := 0xFFFF0000
				this.descrText := "  Timeout"
				this.delay := 1000
				break
			}
			If (ErrorLevel = "EndKey:Escape")
			{
				this.descrColor := 0xFFFF0000
				this.descrText := "  Canceled"
				this.delay := 200
				break
			}
			
			If (ErrorLevel = "EndKey:Enter")
			{
				this.on := 0
				this.descrColor := 0xFFFF0000
				this.descrText := "  Command not found."
				this.delay := 500
				this.ParseCommand()																;parse and end input
				break
			}
			this.command := this.command char
			this.commText := "> " this.command
			this.ParseCommand()																	;parse and continue input
			this.Display()
		}
		this.on := 0
		this.commColor := 0xFF606060
		this.Display()
		this.command := ""
	}

	ParseCommand() {
		if (this.command = "code2") {
			this.Accept("  Code2 accepted...", 3000)
		}
		if (this.command = "code3" and !this.on) {
			this.descrColor := 0xFF00FF00
			this.descrText := "  Command accepted."
			this.delay := 2000
		}
		
		for i, metaCommand in MetaCommands {
			if ((this.command = metaCommand.command) and (this.on = metaCommand.state)) {
				this.Accept("  " metaCommand.description, metaCommand.hintDelay)
				metaCommand.function.()
			}
		}
	}

	Accept(text, time=-1, color=0xFF00FF00) {
		if (time != -1) {
			this.delay := time
			this.on := 0
		}
		this.descrText := text
		this.descrColor := color
	}
}

Class Hint {
  __New(text, size, color=0xFFFFFFFF, x=0, y=0, w=-1, h=-1) {
    this.text := text, this.size := size, this.color := color, this.x := x, this.y := y, this.w := w, this.h := h
  }
	
	CountWH() {
		splitted := StrSplit(this.text, "`n")
		h := splitted.MaxIndex()*this.size*1.1 +10
		w := StrLen(this.text)*(this.size/18*10.4) + 10
		if (this.h < h) {
			this.h := h
		}
		if (this.w < w) {
			this.w := w
		}
	}
	
	Draw(time=-1) {
		this.CountWH()
		StartDrawGDIP()
			SetBrushColor(this.color)
			Gdip_FillRectangle(G, pBrush, this.x, this.y, this.w, this.h)
			Gdip_TextToGraphics(G, this.text, "x" this.x+5 "y" this.y+5 "cff000000 s" this.size, "Arial")
		EndDrawGDIP()
		
		if (time != -1) {
			fn := Func("HideHints")
			SetTimer, % fn, % -time
		}
	}
}