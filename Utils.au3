#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include-once

#include <FastFind.au3>
#include <OCR.au3>

; 2 pixel border from left
Local Const $iWindowOffsetX = 2

; 30 pixel top toolbar
Local Const $iWindowOffsetY = 30


Func GetRelativeCoords($hWnd, $bIncludeOffset, $x, $y)
   $aClientSize = WinGetClientSize($hWnd)

   If @error Then
	;~   ConsoleLog("Couldn't get window size.")
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


Func GetMenuName()
	Local $text_x = 28
	Local $text_y = 30
	Local $text_width = 1260
	Local $text_height = 70

   Local $hWnd = GetNoxHwnd()

   Local $aDoNotShowTopLeft = GetRelativeCoords($hWnd, True, $text_x, $text_y)
   Local $aDoNotShowBottomRight = GetRelativeCoords($hWnd, True, $text_x + $text_width, $text_y + $text_height)

   

	$ocr = OCR_GetTextFromWindow("Menu", $aDoNotShowTopLeft[0], $aDoNotShowTopLeft[1], $aDoNotShowBottomRight[0], $aDoNotShowBottomRight[1], $hWnd)

	; Escape characters
	$ocr = StringRegExpReplace($ocr, "[^A-Za-z]", "")

   Return $ocr

EndFunc   ;==>GetMenuName

Func CloseMenu()
 Local $hWnd = GetNoxHwnd()

   Local $HEADER_GRAY = 0x515f6e

   Local $iClose_X = 1865
   Local $iClose_Y = 60

   Local $grayMenu1 = GetRelativeCoords($hWnd, True, 40, 10)
   Local $grayMenu2 = GetRelativeCoords($hWnd, True, 950, 10)
   Local $grayMenu3 = GetRelativeCoords($hWnd, True, 1780, 10)

	Local $iGrayNotices1 = FFColorCount($HEADER_GRAY, 5, True, $grayMenu1[0], $grayMenu1[1], $grayMenu1[0] + 1, $grayMenu1[1] + 1, 0, $hWnd)
   Local $iGrayNotices2 = FFColorCount($HEADER_GRAY, 5, True, $grayMenu2[0], $grayMenu2[1], $grayMenu2[0] + 1, $grayMenu2[1] + 1, 0, $hWnd)
   Local $iGrayNotices3 = FFColorCount($HEADER_GRAY, 5, True, $grayMenu3[0], $grayMenu3[1], $grayMenu3[0] + 1, $grayMenu3[1] + 1, 0, $hWnd)

   Local $totalMatch = 0

   If $iGrayNotices1 > 0 Then
      $totalMatch += 1
   EndIf

   If $iGrayNotices2 > 0 Then
      $totalMatch += 1
   EndIf

   If $iGrayNotices3 > 0 Then
      $totalMatch += 1
   EndIf

   If $totalMatch >= 2 Then
      Local $aCloseAdButton = GetRelativeCoords($hWnd, True, $iClose_X, $iClose_Y)

       ControlClick($hWnd, "", "", "left", 1, $aCloseAdButton[0], $aCloseAdButton[1])

       ConsoleLog("Closing menu.")
   EndIf
EndFunc