#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include-once
#include <ImageSearch2015.au3>

Local $x

Local $y

If _ImageSearch("images/msm-icon.png", 1, $x, $y, 50) Then
   MouseMove($x, $y)
   ConsoleWrite($x & " " & $y)
Else
   ConsoleWrite("Nothing found")
EndIf