#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include-once

; 2 pixel border from left
Local Const $iWindowOffsetX = 2

; 30 pixel top toolbar
Local Const $iWindowOffsetY = 30


Func GetRelativeCoords($hWnd, $bIncludeOffset, $x, $y)
   $aClientSize = WinGetClientSize($hWnd)

   If @error Then
	  ConsoleLog("Couldn't get window size.")
	  Return @error
   EndIf

   $winNoOffset_X = $aClientSize[0] - $iWindowOffsetX
   $winNoOffset_Y = $aClientSize[1] - $iWindowOffsetY

   $relativeX = $x * $winNoOffset_X / 1920
   $relativeY = $y * $winNoOffset_Y / 1080

   If $bIncludeOffset Then
	  $relativeX += $iWindowOffsetX
	  $relativeY += $iWindowOffsetY

   EndIf


   Local $result = [$relativeX, $relativeY]

   Return $result

EndFunc