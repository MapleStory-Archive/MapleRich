#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include-once

; 1 pixel border from left
Local Const $iWindowOffsetX = 1

; 30 pixel top toolbar
Local Const $iWindowOffsetY = 30


Func GetRelativeWindowSize($hWnd, $bIncludeOffset, $left, $top, $right = 0, $bottom = 0)
   $aClientSize = WinGetClientSize($hWnd)

   $winNoOffset_X = $aClientSize[0] - $iWindowOffsetX
   $winNoOffset_Y = $aClientSize[1] - $iWindowOffsetY

   $relativeLeft = $left * $winNoOffset_X / 1920
   $relativeTop = $top * $winNoOffset_Y / 1080

   If $right > 0 Then
	  $relativeRight = $right * $winNoOffset_X / 1920
   EndIf

   If $bottom > 0 Then
	  $relativeBottom = $bottom * $winNoOffset_Y / 1080
   EndIf

   If $bIncludeOffset Then
	  $relativeLeft += $iWindowOffsetX
	  $relativeTop += $iWindowOffsetY

	  If $right > 0 Then
		 $relativeRight += $iWindowOffsetX
	  EndIf

	  If $bottom > 0 Then
		 $relativeBottom += $iWindowOffsetY
	  EndIf
   EndIf

   Return [$relativeLeft, $relativeTop, $relativeRight, $relativeBottom]

EndFunc