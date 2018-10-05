global HKs := Object()

TestFunction(message) {
  msgbox, % message  
}

HKs.Insert(new Hotkey("LWin_D hH", Func("TestFunction").Bind("It worked!!!"), ""))
fn := HKs[1].function
Hotkey, % "LWin", % fn, on
AddHK(HKs[1])

AddHK(hotkey) {
  up := "u"
  hold := "h"
  holdL := "H"
  delay := "d"
  delayL := "D"
  keys := StrSplit(hotkey.keys, " ")
  firstKey := StrSplit(keys[1], "_")
  if (firstKey[2] == "D") {
    msgbox % keys[1]
    msgbox % firstKey[2]
  }
}
;==============================================================================================

Class Hotkey {
  __New(keys, function, context) {
    this.keys := keys, this.function := function, this.context := context
  }
}
