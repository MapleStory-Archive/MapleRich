#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.14.5
	Author:         myName

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#AutoIt3Wrapper_Res_HiDpi=Y
#AutoIt3Wrapper_UseX64=n

#include <Date.au3>
#include <OCR.au3>
#include <Utils.au3>


Opt("PixelCoordMode", 0)
Opt("WinTitleMatchMode", 3) ; Window Title exact match mode


Global Const $DEBUG_DEFAULT = 3
Global Const $DEBUG_GRAPHIC = $DEBUG_DEFAULT + 4
Global Const $WINDOW_CLASS = "" ; CLASS of the target Window
Global Const $WINDOW_TITLE = "NoxPlayer4" ; TITLE of the target Window

Global Const $WINDOW_X_OFFSET = 1
Global Const $WINDOW_Y_OFFSET = 30

Global Const $gDebug = True

;~ ConsoleWrite('Hi')

;Opt("PixelCoordMode", 0)

Global $hWnd = WinGetHandle($WINDOW_TITLE)

ConsoleLog($hWnd)


; adb shell monkey -p com.nexon.maplem.global 1

While 1

	CloseAd()

	Sleep(2000)
WEnd

Func CloseAd()
	Local $aText = ['Do', 'not', 'show', 'for', 'today']
   Local $iDoNotShow_X = 335
	Local $iDoNotShow_Y = 925
	Local $iDoNotShow_Width = 275
	Local $iDoNotShow_Height = 35

   Local $iCloseAd_X = 1655
   Local $iCloseAd_Y = 110

   Local $aDoNotShowTopLeft = GetRelativeCoords($hWnd, True, $iDoNotShow_X, $iDoNotShow_Y)
   Local $aDoNotShowBottomRight = GetRelativeCoords($hWnd, True, $iDoNotShow_X + $iDoNotShow_Width, $iDoNotShow_Y + $iDoNotShow_Height)

	$ocr = OCR_GetTextFromWindow("Ad", $aDoNotShowTopLeft[0], $aDoNotShowTopLeft[1], $aDoNotShowBottomRight[0], $aDoNotShowBottomRight[1], $hWnd)

   ConsoleLog($ocr)

   ; Trim leading and trailing spaces
   $ocr = StringStripWS($ocr, 3)
   ;~ $ocr = StringRegExpReplace($ocr, "[^a-zA-Z\d\s:]", "")

   $bFound = false


   For $vText in $aText
     If StringInStr($ocr, $vText) Then
	 	$bFound = True
		ExitLoop
	 EndIf
   Next

	If Not $bFound Then
		$ocr = OCR_GetTextFromWindow("Ad", $aDoNotShowTopLeft[0], $aDoNotShowTopLeft[1], $aDoNotShowBottomRight[0], $aDoNotShowBottomRight[1], $hWnd, False)
		ConsoleLog($ocr)
	EndIf

	For $vText in $aText
     If StringInStr($ocr, $vText) Then
	 	$bFound = True
		ExitLoop
	 EndIf
   Next

   If $bFound Then
      Local $aCloseAdButton = GetRelativeCoords($hWnd, True, $iCloseAd_X, $iCloseAd_Y)

       ControlClick($hWnd, "", "", "left", 1, $aCloseAdButton[0], $aCloseAdButton[1])

       ConsoleLog("Closing ad.")
   EndIf
	
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


EndFunc   ;==>GetCharacterLevel





Func ConsoleLog($text, $withDateTime = True, $withCR = True)
	If $gDebug Then
		If $withDateTime Then ConsoleWrite(_NowTime(5) & " ")
		ConsoleWrite($text)
		If $withCR Then ConsoleWrite(@CRLF)

		;If $withDateTime Then FileWrite("ClashBotLog.txt", _NowDate() & " " & _NowTime(5) & " ")
		;FileWrite("ClashBotLog.txt", $text)
		;If $withCR Then FileWrite("ClashBotLog.txt", @CRLF)
	EndIf
EndFunc   ;==>ConsoleLog
