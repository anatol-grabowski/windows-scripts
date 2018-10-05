#include libs\Times.ahk
#include libs\Ancillary.ahk

global InSeq := ""
global SeqON := 0
global EndSeqStr := "}"

updSeq() {
	Send, % InSeq
	;InSeq := ""
}

startSeq() {

	if (SeqON) { 
    return
  }
  SeqON := 1
	
	InSeq := InSeq "["
	loop {
		Input, out, L1 
		if (!SeqON) {
			Send, % out
			break
		}
		
		InSeq := InSeq out
		updSeq()
	}
}

endSeq() {
	SeqON := 0
	InSeq := InSeq "]"
	updSeq()
	InSeq := ""
}

LAlt & LWin::
	fn := Func("endSeq")
	startSeq()
  SetTimer, % fn, -1000
return