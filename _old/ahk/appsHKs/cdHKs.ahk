global quickHKsOnPeriod := 1000
global quickHKsOffTime := 0
global quickHKsActivated := 0

;<<=========================
global appDescs := Object()
appDescs.Insert(new AppDesc("b", "c:\_tot\_1_DATA\"))

Class AppDesc {
  __New(key, path, wndClass) {
    this.key := key, this.path := path
  }
}
;>>=========================

ActivateHKs("#")

cd(path) {
	command := "c:\_tot\_5_PORTABLE\_1_BASIC_APPS\totalcmd\TOTALCMD.EXE /O /S /L=c:\_tot"
	Run, %command%
}

ActivateHKs(prefix) {
  for i, appDesc in appDescs {
    fn := Func(cd).Bind(appDesc)
    Hotkey, % prefix "b", % fn, on
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

~LWin Up::
  stringsplit, splitted_, A_PriorHotkey
  if (splitted_1 = "#") { ;win+key combo has just been released
    return
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
  ActivateHKs("")

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