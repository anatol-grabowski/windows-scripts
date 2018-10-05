#include appDescs.ahk
global quickHKsOnPeriod := 1000
global quickHKsOffTime := 0
global quickHKsActivated := 0

ActivateHKs("RunOrToggleApp", "#")
ActivateHKs("CloseApp", "#!")

ActivateHKs(funcName, prefix) {
  for i, appDesc in appDescs {
    fn := Func(funcName).Bind(appDesc)
    Hotkey, % prefix appDesc.key, % fn, on
  }
}

DeactivateHKs(prefix) {
  for i, appDesc in appDescs {
    Hotkey, % prefix appDesc.key, off, UseErrorLevel
  }
  if (!prefix) {
    quickHKsActivated := 0
    quickHKsOffTime := A_TickCount
  }
}

LAlt Up::
LWin Up::
  stringsplit, splitted_, A_PriorHotkey
  if (splitted_1 = "#") { ;win+key combo has just been released
    return
  }
  if (A_ThisHotkey = "LWin Up") {
    
  }
  fn := Func("ActivateQuickHKs").Bind("RunOrToggleApp")
  SetTimer, % fn, -0
return

;===============================================QuickHKs===================================
ActivateQuickHKs(funcName) {
  quickHKsOffTime := A_TickCount + quickHKsOnPeriod
  if (quickHKsActivated) { 
    return
  }
  quickHKsActivated := 1
  ActivateHKs(funcName, "")

  capsState := GetKeyState("CapsLock", "T")
  numState := GetKeyState("NumLock", "T")
  SetCapsLockState, % "Off"
  SetNumLockState, % "Off"
  timeToggle := 100
  while (A_TickCount < quickHKsOffTime) {
    SetCapsLockState, % "On"
    Sleep, % timeToggle
    SetCapsLockState, % "Off"
    Sleep, % timeToggle
    SetNumLockState, % "On"
    Sleep, % timeToggle
    SetNumLockState, % "Off"
    Sleep, % timeToggle
  }
  SetCapsLockState, % (capsState) ? "On" : "Off"
  SetNumLockState, % (numState) ? "On" : "Off"

  DeactivateHKs("")
}