#Include Ancillary.ahk
#Include Times.ahk

global SelToFileSelection := ""
global SelToFilePath := " "
global SelToFileDefPath := A_WorkingDir "\selections.txt"
global SelToFileNumPresses := 0
global SelToFileLogLevel := 3
fn := Func("SelToFile")

LWin & Home::
  SelToFileNumPresses++
  Log(SelToFileLogLevel, "LWin & Home, presses = " SelToFileNumPresses)
  if (SelToFileNumPresses = 1) {
    SelToFileSelection := GetSelection()
    Log(SelToFileLogLevel, "LWin & Home, GetSelection() = " SelToFileSelection)
  }
  TimedTooltip(SelToFileNumPresses "`nClipboard: " Clipboard "`nSelection: " SelToFileSelection, TooltipSelToFileTime)
  SetTimer, % fn, % -TimeMultiPress
  Log(SelToFileLogLevel, "LWin & Home, set timer = " -TimeMultiPress)
return

SelToFile() {
  presses := SelToFileNumPresses
  SelToFileNumPresses := 0
  Log(SelToFileLogLevel, "SelToFile(), reset pressesNum = " presses)

  if (presses = 1) {
    FileAppend, % SelToFileSelection "`n", % SelToFilePath
    TimedTooltip(SelToFileSelection "`nAppended to file: " SelToFilePath, TooltipSelToFileTime)
    SelToFileSelection := ""
  }
  else if (presses = 2) {
    SelToFilePath := SelToFileSelection
    Log(SelToFileLogLevel, "SelToFile(), SelToFilePath = " SelToFilePath)
    SelToFilePath := CheckIfPathValid(SelToFilePath, SelToFileDefPath)
    Log(SelToFileLogLevel, "SelToFile(), CheckIfPathValid() = " SelToFilePath)
    TimedTooltip("File set: " SelToFilePath, TooltipSelToFileTime)
    SelToFileSelection := ""
  }
  else if (presses = 3) {
    TimedTooltip("File is: " SelToFilePath, TooltipSelToFileTime)
    SelToFileSelection := ""
  }
  else if (presses = 4) {
    Run, % "notepad.exe " SelToFilePath
    TimedTooltip("Opened file: " SelToFilePath, TooltipSelToFileTime)
    SelToFileSelection := ""
  }
}