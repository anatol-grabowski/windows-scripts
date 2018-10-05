#NoEnv
#SingleInstance force
#InstallKeybdHook
#HotkeyInterval 2000  
#MaxHotkeysPerInterval 300

;;media keys
#^!Left::Send {Media_Prev}
#^!SPACE::Send {Media_Play_Pause}
#^!Right::Send {Media_Next}
#^!Down::Send {Volume_Down}
#^!Up::Send {Volume_Up}
#^!Enter::Send {Volume_Mute}
 
 
;;;;;;;;;;;;;;;; trackpad for surface type cover ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
;;-----swipe left for backward navigation---------------
WheelRight::
 winc_pressesR += 1
 SetTimer, Whright, 400 ; Wait for more presses within a 400 millisecond window.
return
 
Whright:
 SetTimer, Whright, off ; Disable timer after first time its called.
 if winc_pressesR >= 16 ; The key was pressed once or more.
 {
  SendInput, !{Left} ; Send alt + left for back button (in Chrome at least)
 }
 ; Regardless of which action above was triggered, reset the count to prepare for the next series of presses:
 winc_pressesR = 0
return
;-----------------------------------------------
 
;;-----swipe right for forward navigation---------------
WheelLeft::
 winc_pressesL += 1
 SetTimer, Whleft, 400 ; Wait for more presses within a 400 millisecond window.
return
 
Whleft:
 SetTimer, Whleft, off ; Disable timer after first time its called.
 if winc_pressesL >= 16 ; The key was pressed once or more.
 {
  SendInput, !{Right} ; Send alt + left for forward button (in Chrome at least)
 }
 ; Regardless of which action above was triggered, reset the count to prepare for the next series of presses:
 winc_pressesL = 0
 return
;-----------------------------------------------
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 
;;;;;;;;;;;;;;;; brightness shortcuts for surface type cover ;;;;;;;;;;;;;;;;;;
 
toggle := false
 
SetWorkingDir %A_ScriptDir%
SendMode, Input
 
LWin & Q::
MoveBrightness(10)
return

LWin & A::
MoveBrightness(-10)
return
 
#Escape::SendMessage 0x112, 0xF170, 2, , Program Manager
 
;############################################################################
; Functions
;############################################################################
 
MoveBrightness(IndexMove)
{
 
        VarSetCapacity(SupportedBrightness, 256, 0)
        VarSetCapacity(SupportedBrightnessSize, 4, 0)
        VarSetCapacity(BrightnessSize, 4, 0)
        VarSetCapacity(Brightness, 3, 0)
       
        hLCD := DllCall("CreateFile"
        , Str, "\\.\LCD"
        , UInt, 0x80000000 | 0x40000000 ;Read | Write
        , UInt, 0x1 | 0x2  ; File Read | File Write
        , UInt, 0
        , UInt, 0x3  ; open any existing file
        , UInt, 0
          , UInt, 0)
       
        if hLCD != -1
        {
               
                DevVideo := 0x00000023, BuffMethod := 0, Fileacces := 0
                  NumPut(0x03, Brightness, 0, "UChar")   ; 0x01 = Set AC, 0x02 = Set DC, 0x03 = Set both
                  NumPut(0x00, Brightness, 1, "UChar")      ; The AC brightness level
                  NumPut(0x00, Brightness, 2, "UChar")      ; The DC brightness level
                DllCall("DeviceIoControl"
                  , UInt, hLCD
                  , UInt, (DevVideo<<16 | 0x126<<2 | BuffMethod<<14 | Fileacces) ; IOCTL_VIDEO_QUERY_DISPLAY_BRIGHTNESS
                  , UInt, 0
                  , UInt, 0
                  , UInt, &Brightness
                  , UInt, 3
                  , UInt, &BrightnessSize
                  , UInt, 0)
               
                DllCall("DeviceIoControl"
                  , UInt, hLCD
                  , UInt, (DevVideo<<16 | 0x125<<2 | BuffMethod<<14 | Fileacces) ; IOCTL_VIDEO_QUERY_SUPPORTED_BRIGHTNESS
                  , UInt, 0
                  , UInt, 0
                  , UInt, &SupportedBrightness
                  , UInt, 256
                  , UInt, &SupportedBrightnessSize
                  , UInt, 0)
               
                ACBrightness := NumGet(Brightness, 1, "UChar")
                ACIndex := 0
                DCBrightness := NumGet(Brightness, 2, "UChar")
                DCIndex := 0
                BufferSize := NumGet(SupportedBrightnessSize, 0, "UInt")
                MaxIndex := BufferSize-1
 
                Loop, %BufferSize%
                {
                ThisIndex := A_Index-1
                ThisBrightness := NumGet(SupportedBrightness, ThisIndex, "UChar")
                if ACBrightness = %ThisBrightness%
                        ACIndex := ThisIndex
                if DCBrightness = %ThisBrightness%
                        DCIndex := ThisIndex
                }
               
                if DCIndex >= %ACIndex%
                  BrightnessIndex := DCIndex
                else
                  BrightnessIndex := ACIndex
 
                BrightnessIndex += IndexMove
               
                if BrightnessIndex > %MaxIndex%
                   BrightnessIndex := MaxIndex
                   
                if BrightnessIndex < 0
                   BrightnessIndex := 0
 
                NewBrightness := NumGet(SupportedBrightness, BrightnessIndex, "UChar")
               
                NumPut(0x03, Brightness, 0, "UChar")   ; 0x01 = Set AC, 0x02 = Set DC, 0x03 = Set both
        NumPut(NewBrightness, Brightness, 1, "UChar")      ; The AC brightness level
        NumPut(NewBrightness, Brightness, 2, "UChar")      ; The DC brightness level
               
                DllCall("DeviceIoControl"
                        , UInt, hLCD
                        , UInt, (DevVideo<<16 | 0x127<<2 | BuffMethod<<14 | Fileacces) ; IOCTL_VIDEO_SET_DISPLAY_BRIGHTNESS
                        , UInt, &Brightness
                        , UInt, 3
                        , UInt, 0
                        , UInt, 0
                        , UInt, 0
                        , Uint, 0)
               
                DllCall("CloseHandle", UInt, hLCD)
       
        }
 
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;