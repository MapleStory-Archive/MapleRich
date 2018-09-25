#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <FastFind.au3>
#include <Date.au3>

#include <OCR.au3>

#include <ImageSearch2015.au3>




;~ #RequireAdmin

global const $DEBUG_DEFAULT = 3
global const $DEBUG_GRAPHIC = $DEBUG_DEFAULT + 4
global const $WINDOW_CLASS = "" ; CLASS of the target Window
global const $WINDOW_TITLE = "NoxPlayer1" ; TITLE of the target Window

global const $WINDOW_X_OFFSET = 1
global const $WINDOW_Y_OFFSET = 30

global const $gDebug = True

;~ ConsoleWrite('Hi')

;Opt("PixelCoordMode", 0)

Global $hWnd = WinGetHandle($WINDOW_TITLE)

FFSetDebugMode($DEBUG_GRAPHIC) 	 ; Enable advanced (graphical) debug mode, so you will have traces + graphical feedback
FFSetDefaultSnapShot(0)
FFSetWnd($hWnd)

; adb shell monkey -p com.nexon.maplem.global 1

While 1

;~    Local $aList = WinList('NoxPlayer')
;~    For $i = 1 To UBound($aList) - 1
;~ 	  If $aList[$i][0] <> "" Then ConsoleWrite($aList[$i][0] & ";" & $aList[$i][1] & @CRLF)

;~ 	  Local $winTitle = $aList[$i][0]
;~ 	  Local $hWnd = $aList[$i][1]

;~ 	  GetColor(1755, 45, $hWnd)

;~ 	  ConsoleWrite($result & @CRLF)
;~ 	  ;MouseMove(1570, 950, 10)
;~    Next

   ;Detect()
   ;SaveJpg(435, 930, 140, 140)
   ;ConsoleWrite(IsAutoQuesting() & @CRLF)
;~    ConsoleWrite("Testing" & @CRLF)
;~    IsDead()
;~    If IsAutoQuestingOCR() Then
;~ 	  ConsoleLog("We're auto questing!")
;~    Else
;~ 	  ConsoleLog("Not autoquesting")
;~    EndIf
;~    $aClientSize = WinGetClientSize($hWnd)
;~    ConsoleLog($aClientSize[0] & " " & $aClientSize[1])
   OpenTreasureBoxes()

   Sleep(2000)
WEnd

Func GetRelativeWindowSize($hWnd, $includeOffset, $left, $top, $right = 0, $bottom = 0)
   $aClientSize = WinGetClientSize($hWnd)

   $winNoOffset_X = $aClientSize[0] - $WINDOW_X_OFFSET
   $winNoOffset_Y = $aClientSize[1] - $WINDOW_Y_OFFSET

   $relativeLeft = $left * $winNoOffset_X / 1920
   $relativeTop = $top * $winNoOffset_Y / 1080

   If $right > 0
	  $relativeRight = $right * $winNoOffset_X / 1920
   EndIf

   If $bottom > 0
	  $relativeBottom = $bottom * $winNoOffset_Y / 1080
   EndIf

   Return [$relativeLeft, $relativeTop, $relativeRight, $relativeBottom]

EndFunc

Func OpenTreasureBoxes

EndFunc


Func IsAutoQuestingOCR()
   Local $text_x = 465
   Local $text_y = 970
   Local $text_width = 80
   Local $text_height = 55

   Local $auto_x = 435
   Local $auto_y = 930
   Local $auto_width = 140
   Local $auto_height = 140


   $ocr = OCR_GetTextFromWindow($text_x + $WINDOW_X_OFFSET, $text_y + $WINDOW_Y_OFFSET, $text_x + $WINDOW_X_OFFSET + $text_width, $text_y + $WINDOW_Y_OFFSET + $text_height, $hWnd)


   ; Remove erroneous characters
   $ocr = StringReplace($ocr, ".", "")
   $ocr = StringReplace($ocr, "'", "")
   $ocr = StringReplace($ocr, ",", "")
   $ocr = StringStripWS($ocr, 8)


   ConsoleWrite($ocr & @CRLF)

   If StringInStr($ocr, "Quest", 1) Then Return True

   If StringInStr($ocr, "Auto", 1) Then Return True

   ; End attempt at using OCR to check if we're autoquesting

   ; Begin checking for the auto quest pixel colors

;~    ConsoleWrite($ocr & @CRLF)

   $darkGrayPixels = FFColorCount(0x6B6B6B, 0, True, $auto_x + $WINDOW_X_OFFSET, $auto_y + $WINDOW_Y_OFFSET, $auto_x + $WINDOW_X_OFFSET + $auto_width, $auto_y + $WINDOW_Y_OFFSET + $auto_height, 0, $hWnd)

   If StringInStr($ocr, "AUTO", 1) And $darkGrayPixels = 0 Then Return False


   $goldPixels = FFColorCount(0xFAEEB5, 3, True, $auto_x + $WINDOW_X_OFFSET, $auto_y + $WINDOW_Y_OFFSET, $auto_x + $WINDOW_X_OFFSET + $auto_width, $auto_y + $WINDOW_Y_OFFSET + $auto_height, 0, $hWnd)

   $goldPixels2 = FFColorCount(0xF9D690, 3, True, $auto_x + $WINDOW_X_OFFSET, $auto_y + $WINDOW_Y_OFFSET, $auto_x + $WINDOW_X_OFFSET + $auto_width, $auto_y + $WINDOW_Y_OFFSET + $auto_height, 0, $hWnd)

   $whitePixels = FFColorCount(0xEDEDED, 3, True, $auto_x + $WINDOW_X_OFFSET, $auto_y + $WINDOW_Y_OFFSET, $auto_x + $WINDOW_X_OFFSET + $auto_width, $auto_y + $WINDOW_Y_OFFSET + $auto_height, 0, $hWnd)



   ConsoleLog("Gold Pixels: " & $goldPixels)

;~    If ($goldPixels = 0) Then Return False

   ConsoleLog("Gold Pixels 2: " & $goldPixels2)

;~    If ($goldPixels2 = 0) Then Return False

   ; "Auto Quest" font color
   ConsoleLog("White Pixels: " & $whitePixels)

   ; "Auto" font color
   ConsoleLog("Dark Gray Pixels: " & $darkGrayPixels)

;~    If ($whitePixels = 0 And $darkGrayPixels = 0) Then Return False

   If ($goldPixels > 0 And $goldPixels2 > 0 And ($whitePixels > 0 Or $darkGrayPixels > 0)) Then Return True

   Return False
   ;$text = _TesseractWinCapture($WINDOW_TITLE, "", 0, "", 0, 2, $x + $WINDOW_X_OFFSET, $y + $WINDOW_Y_OFFSET, $x + $WINDOW_X_OFFSET + $width, $y + $WINDOW_Y_OFFSET + $height)
EndFunc

Func IsDead()
   $picture = "./images/revive.png"

   $result = _ImageSearch($picture, 1, 0, 0, 0, 0)

   If ($result = 1) Then
	  ConsoleWrite('Character is dead' & @CRLF)
   Else
	  ConsoleWrite('Character is not dead.' & @CRLF)
   EndIf
EndFunc

Func IsAutoQuesting()
   Local $x = 435
   Local $y = 930
   Local $width = 140
   Local $height = 140

   $result = FFColorCount(0xFAEEB5, 3, True, $x + $WINDOW_X_OFFSET, $y + $WINDOW_Y_OFFSET, $x + $WINDOW_X_OFFSET + $width, $y + $WINDOW_Y_OFFSET + $height, 0, $hWnd)

   Return $result > 0
EndFunc

Func SaveJpg($x, $y, $width, $height)
   FFSaveJPG("Test", 100, True, $x + $WINDOW_X_OFFSET, $y + $WINDOW_Y_OFFSET, $x + $WINDOW_X_OFFSET + $width, $y + $WINDOW_Y_OFFSET + $height, 0, $hWnd)
   ;FFSaveJPG("Test", 85, True, 0, 0, 0, 0, 0, $hWnd)
EndFunc

Func Detect()
   FFSetDebugMode($DEBUG_GRAPHIC)
;~    FFTrace(@lf&"   ** Detection of blue area"&@lf&"") ; Put this in the different debugging channels (tracer.txt, console...) as set with FFSetDebugMode
   $aCoords = FFNearestSpot(140, 5, 505, 995, 0xFAEEB5, 3, true, 0, 0, 0, 0)

   If IsArray($aCoords) Then
	  ConsoleWrite("Auto questing. Found at " & $aCoords[0] & ", " & $aCoords[1] & @CRLF)
   Else
	  ConsoleWrite("Not auto questing." & @CRLF)
   EndIf



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