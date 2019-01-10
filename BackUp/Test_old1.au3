#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <Date.au3>

#include <OCR.au3>

#include <Utils.au3>




;~ #RequireAdmin

global const $DEBUG_DEFAULT = 3
global const $DEBUG_GRAPHIC = $DEBUG_DEFAULT + 4
global const $WINDOW_CLASS = "" ; CLASS of the target Window
global const $WINDOW_TITLE = "NoxPlayer4" ; TITLE of the target Window

global const $WINDOW_X_OFFSET = 1
global const $WINDOW_Y_OFFSET = 30

global const $gDebug = True

;~ ConsoleWrite('Hi')

;Opt("PixelCoordMode", 0)

Global $hWnd = WinGetHandle($WINDOW_TITLE)

ConsoleLog($hWnd)


; adb shell monkey -p com.nexon.maplem.global 1

While 1

  DetectWhichMenu()

   Sleep(2000)
WEnd


Func GetMenuName()
   Local $text_x = 28
   Local $text_y = 30
   Local $text_width = 1260
   Local $text_height = 70




   $ocr = OCR_GetTextFromWindow("Menu", $text_x + $WINDOW_X_OFFSET, $text_y + $WINDOW_Y_OFFSET, $text_x + $WINDOW_X_OFFSET + $text_width, $text_y + $WINDOW_Y_OFFSET + $text_height, $hWnd)

   ; Escape characters
   $ocr = StringRegExpReplace($ocr, "[^A-Za-z]", "")


   ConsoleLog($ocr)


EndFunc




Func GetCharacterLevel()
   Local $text_x = 28
   Local $text_y = 22
   Local $text_width = 85
   Local $text_height = 30




   $ocr = OCR_GetTextFromWindow("Level", $text_x + $WINDOW_X_OFFSET, $text_y + $WINDOW_Y_OFFSET, $text_x + $WINDOW_X_OFFSET + $text_width, $text_y + $WINDOW_Y_OFFSET + $text_height, $hWnd)


   ; Remove erroneous characters
   $ocr = StringRegExpReplace($ocr, "[^0-9]", "")


   ConsoleLog($ocr)


EndFunc





Func ConsoleLog($text, $withDateTime = True, $withCR = True)
   If $gDebug Then
	  If $withDateTime Then ConsoleWrite(_NowTime(5) & " ")
	  ConsoleWrite($text)
	  If $withCR Then ConsoleWrite(@CRLF)

	  ;If $withDateTime Then FileWrite("ClashBotLog.txt", _NowDate() & " " & _NowTime(5) & " ")
	  ;FileWrite("ClashBotLog.txt", $text)
	  ;If $withCR Then FileWrite("ClashBotLog.txt", @CRLF)
   EndIf
EndFunc