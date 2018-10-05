#include ..\libs\gdip\Gdip.ahk
#include ..\libs\gdip\GdipHelper.ahk

Class MetaConsole {

	__New() {
		this.on := 0,
		this.timeout := 10000,
		this.commandStr := "",
		this.commands := Object()
		
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
	
		if (this.delay != -1) {										;if delay is -1 don't update delay
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
			inputTimeout := this.timeout/1000
			Input, char, L1 T%inputTimeout%, {Enter}{Esc}{BackSpace}
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
				this.delay := 250
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
			
			If (ErrorLevel = "EndKey:BackSpace")
			{
				this.commandStr :=  SubStr(this.commandStr,1,StrLen(this.commandStr)-1)
			}
			this.commandStr := this.commandStr char
			this.ParseCommand()																	;parse and continue input
			this.commText := "> " this.commandStr
			this.Display()
		}
		this.on := 0
		this.commColor := 0xFF606060
		this.Display()
		this.commandStr := ""
	}

	ParseCommand() {		
		splitted := StrSplit(this.commandStr, " ")
		comm := splitted[1]
		firstArgNumber := 2
		if (!comm) {
			this.Accept("Enter command...", -1, 0xFFE0E0FF)
		}
		for i, metaCommand in this.commands {
			if (comm = metaCommand.commandStr and this.on = metaCommand.state) {
				this.Accept(metaCommand.commandFunc.description, metaCommand.hintDelay)
				metaCommand.commandFunc.function.(splitted, firstArgNumber)
			}
		}
	}

	Accept(text, time=-1, color=0xFF00FF00) {				;if time is set end input
		if (time != -1) {
			this.delay := time
			this.on := 0
		}
		this.descrText := "  " text
		this.descrColor := color
	}
}

Class CommandFunc {
	__New(function, description="") {
    this.function := function, this.description := description
  }
}

Class MetaCommand {
  __New(commandStr, state, hintDelay, commandFunc) {
    this.commandStr := commandStr, this.state := state, this.hintDelay := hintDelay, this.commandFunc := commandFunc
		;tooltip, % command
  }
}