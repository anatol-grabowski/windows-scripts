global comboJustUp := false
global altDown := false
global winDown := false
global firstPressed := ""

LAlt::
  altDown := true
  if (winDown) {
    return
  }
  firstPressed := "!"
return

LWin::
  winDown := true
  if (altDown) {
    return
  }
  firstPressed := "#"
return

LAlt Up::
  altDown := false
  if (!winDown) {
    if (comboJustUp) {
      comboJustUp := false
      return
    }
    msgbox !
  }
  if (winDown) {
    comboJustUp := true
    if (firstPressed = "#") {
      msgbox #!!.
    }
    if (firstPressed = "!") {
      msgbox !#!.
    }
  }
return

LWin Up::
  winDown := false
  if (!altDown) {
    if (comboJustUp) {
      comboJustUp := false
      return
    }
    msgbox #
  }
  if (altDown) {
    comboJustUp := true
    if (firstPressed = "#") {
      msgbox #!#.
    }
    if (firstPressed = "!") {
      msgbox !##.
    }
  }
return
