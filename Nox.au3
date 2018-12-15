#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include-once
#include <Globals.au3>

Static Global $NOX_TITLE = "NoxPlayer"
Static Global $NOX_CONTROL = "AnglePlayer_01"

Func IsNoxRunning()
   If ProcessExists("Nox.exe") Then
	  $gNoxIsRunning = true
   Else
	  $gNoxIsRunning = false
   EndIf

   Return $gNoxIsRunning
EndFunc

Func GetNoxHwnd()
   Return $gNoxHwnd
EndFunc
