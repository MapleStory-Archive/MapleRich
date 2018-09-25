#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include-once

#include <WinAPI.au3>
#include <FastFind.au3>

#include <Globals.au3>
#include <Nox.au3>
#include <GUI.au3>
#include <OCR.au3>
#include <Utils.au3>

#AutoIt3Wrapper_Res_HiDpi=Y

global const $WINDOW_X_OFFSET = 1
global const $WINDOW_Y_OFFSET = 30

FFSetDebugMode(3)

;~ Func IsAutoQuesting()
;~ ;~    PixelSearch(440, 930, 575, 1070, $COLOR_AUTOQUESTING, 3, 1, GetNoxHwnd())

;~ ;~    If Not @error Then
;~ ;~ 	  $gBotStatus = "Auto Questing"
;~ ;~ 	  ConsoleLog("Auto questing.")
;~ ;~ 	  Return True
;~ ;~    EndIf

;~ ;~    Return False

;~    Local $x = 435
;~    Local $y = 930
;~    Local $width = 140
;~    Local $height = 140

;~    $goldPixels = FFColorCount(0xFAEEB5, 3, True, $x + $WINDOW_X_OFFSET, $y + $WINDOW_Y_OFFSET, $x + $WINDOW_X_OFFSET + $width, $y + $WINDOW_Y_OFFSET + $height, 0, GetNoxHwnd())

;~    ConsoleLog("Gold Pixels: " & $goldPixels)

;~    If ($goldPixels = 0) Then Return False

;~    $goldPixels2 = FFColorCount(0xF9D690, 3, True, $x + $WINDOW_X_OFFSET, $y + $WINDOW_Y_OFFSET, $x + $WINDOW_X_OFFSET + $width, $y + $WINDOW_Y_OFFSET + $height, 0, GetNoxHwnd())

;~    ConsoleLog("Gold Pixels 2: " & $goldPixels)

;~    If ($goldPixels2 = 0) Then Return False

;~    $whitePixels = FFColorCount(0xEDEDED, 3, True, $x + $WINDOW_X_OFFSET, $y + $WINDOW_Y_OFFSET, $x + $WINDOW_X_OFFSET + $width, $y + $WINDOW_Y_OFFSET + $height, 0, GetNoxHwnd())
;~    $darkGrayPixels = FFColorCount(0x6B6B6B, 1, True, $x + $WINDOW_X_OFFSET, $y + $WINDOW_Y_OFFSET, $x + $WINDOW_X_OFFSET + $width, $y + $WINDOW_Y_OFFSET + $height, 0, GetNoxHwnd())

;~    ; "Auto Quest" font color
;~    ConsoleLog("White Pixels: " & $whitePixels)

;~    ; "Auto" font color
;~    ConsoleLog("Dark Gray Pixels: " & $darkGrayPixels)

;~    If ($whitePixels = 0 And $darkGrayPixels = 0) Then
;~ 	  Return False
;~    EndIf


;~    $gBotStatus = "Auto Questing"
;~    ConsoleLog("Auto questing.")
;~    Return True
;~ EndFunc

Func IsAutoQuesting()
   Local $text_x = 465
   Local $text_y = 970
   Local $text_width = 80
   Local $text_height = 55

   Local $auto_x = 435
   Local $auto_y = 930
   Local $auto_width = 140
   Local $auto_height = 140

   Local $hWnd = GetNoxHwnd()


   $ocr = OCR_GetTextFromWindow($text_x + $WINDOW_X_OFFSET, $text_y + $WINDOW_Y_OFFSET, $text_x + $WINDOW_X_OFFSET + $text_width, $text_y + $WINDOW_Y_OFFSET + $text_height, $hWnd)

   ; Remove erroneous characters
   $ocr = StringReplace($ocr, ".", "")
   $ocr = StringReplace($ocr, "'", "")
   $ocr = StringReplace($ocr, ",", "")
   $ocr = StringStripWS($ocr, 8)

  ;~  ConsoleLog($ocr)

   If StringInStr($ocr, "Quest", 1) Then Return True

   ;If StringInStr($ocr, "Auto", 1) Then Return True
   ; End attempt at using OCR to check if we're autoquesting

   ; Begin checking for the auto quest pixel colors

;~    ConsoleWrite($ocr & @CRLF)
   $darkGrayPixels = FFColorCount(0x6B6B6B, 1, True, $auto_x + $WINDOW_X_OFFSET, $auto_y + $WINDOW_Y_OFFSET, $auto_x + $WINDOW_X_OFFSET + $auto_width, $auto_y + $WINDOW_Y_OFFSET + $auto_height, 0, $hWnd)

   If StringInStr($ocr, "AUTO", 1) And $darkGrayPixels < 5 Then Return False

   $goldPixels = FFColorCount(0xFAEEB5, 3, True, $auto_x + $WINDOW_X_OFFSET, $auto_y + $WINDOW_Y_OFFSET, $auto_x + $WINDOW_X_OFFSET + $auto_width, $auto_y + $WINDOW_Y_OFFSET + $auto_height, 0, $hWnd)

   $goldPixels2 = FFColorCount(0xF9D690, 3, True, $auto_x + $WINDOW_X_OFFSET, $auto_y + $WINDOW_Y_OFFSET, $auto_x + $WINDOW_X_OFFSET + $auto_width, $auto_y + $WINDOW_Y_OFFSET + $auto_height, 0, $hWnd)

   $whitePixels = FFColorCount(0xEDEDED, 3, True, $auto_x + $WINDOW_X_OFFSET, $auto_y + $WINDOW_Y_OFFSET, $auto_x + $WINDOW_X_OFFSET + $auto_width, $auto_y + $WINDOW_Y_OFFSET + $auto_height, 0, $hWnd)



;~    ConsoleLog("Gold Pixels: " & $goldPixels)

;~    If ($goldPixels = 0) Then Return False

;~    ConsoleLog("Gold Pixels 2: " & $goldPixels2)

;~    If ($goldPixels2 = 0) Then Return False

   ; "Auto Quest" font color
;~    ConsoleLog("White Pixels: " & $whitePixels)

   ; "Auto" font color
  ;~  ConsoleLog("Dark Gray Pixels: " & $darkGrayPixels)

;~    If ($whitePixels = 0 And $darkGrayPixels = 0) Then Return False

   If ($goldPixels > 0 And $goldPixels2 > 0 And ($whitePixels > 0 Or $darkGrayPixels > 0)) Then Return True

   ;$text = _TesseractWinCapture($WINDOW_TITLE, "", 0, "", 0, 2, $x + $WINDOW_X_OFFSET, $y + $WINDOW_Y_OFFSET, $x + $WINDOW_X_OFFSET + $width, $y + $WINDOW_Y_OFFSET + $height)
   Return False
EndFunc


Func IsQuestMenuIconVisible()
   ; Check if quest menu is visible
   PixelSearch(50, 310, 100, 360, $COLOR_WHITE, 0, 1, GetNoxHwnd())

   If Not @error Then
	  ConsoleLog("Quest menu icon is visible.")
	  Return True
   EndIf

    ConsoleLog("Couldn't find quest menu icon")
   Return False
EndFunc


Func IsQuestMenuIconVisibleNew()
   Local $iMenuIconX = 45
   Local $iMenuIconY = 285


   Local $hWnd = GetNoxHwnd()

   Local $aWinSizes = GetRelativeWindowSize($hWnd, True, $iMenuIconX, $iMenuIconY)

   Local $iWhiteCount = FFColorCount($COLOR_WHITE, 0, True, $aWinSizes[0], $aWinSizes[1], $aWinSizes[0] + 1, $aWinSizes[1] + 1, 0, $hWnd)
EndFunc


Func OpenQuestMenu()
   ; Open Quest Menu
   Local $questCoord = PixelSearch(50, 310, 100, 360, $COLOR_WHITE, 0, 1, GetNoxHwnd())

   If Not @error Then
	  ConsoleLog("opening quest menu. Position: " & $questCoord[0] & " " & $questCoord[1])
	  ControlClick($gNoxTitle, "", "", "left", 2, $questCoord[0], $questCoord[1])
   Else
	  ConsoleLog("Couldnt find quest icon")
   EndIf
EndFunc


Func IsQuestMenuVisible()
   ; Check if quest menu is visible
   PixelSearch(0, 0, 30, 30, $COLOR_MENU_HEADER, 0, 1, GetNoxHwnd())

   If Not @error Then
	  ConsoleLog("Quest menu is visible.")
	  Return True
   EndIf

   Return False
EndFunc


Func StartAutoQuest()
   ; Select the first quest on the list
   ControlClick("NoxPlayer", "", "", "left", 1, 650, 200)

   ; Check if the "Auto Play" button is there
   Local $storyQuestCoord = PixelSearch(25, 150, 70, 200, $COLOR_ORANGE, 0, 1, GetNoxHwnd())

   If Not @error Then
	  ; Click the "Auto Play" button
	  ConsoleLog("Starting Auto Quest")
	  ControlClick($gNoxTitle, "", "", "left", 1, 1750, 1000)
   EndIf

   Sleep(250)

   ; Check if the quest menu is still visible
   PixelSearch(0, 0, 30, 30, $COLOR_MENU_HEADER, 0, 1, GetNoxHwnd())

   If Not @error Then
	  ConsoleLog("Quest menu is still visible after starting auto quest. Attempting to close.")
	  ControlClick($gNoxTitle, "", "", "left", 1, 1865, 65)
	  Return True
   EndIf

EndFunc


Func IsQuestDialogVisible()
   ; Check if we are in the quest dialog
   PixelSearch(1750, 40, 1760, 60, $COLOR_BLACK_DIALOG_OVERLAY, 1, 1, GetNoxHwnd())

   If Not @error Then
	  ConsoleLog("Quest dialog is visible.")
	  Return True
   EndIf

   PixelSearch(1750, 40, 1760, 60, $COLOR_BLACK_DIALOG_IN_MENU_OVERLAY, 1, 1, GetNoxHwnd())

   If Not @error Then
	  ConsoleLog("Quest dialog is visible.")
	  Return True
   EndIf

   ConsoleLog("Not in quest dialog")
   Return False
EndFunc


Func CompleteQuestDialog()
   ; Search for Green Complete button first
   Local $greenCompleteCoord = PixelSearch(430, 780, 1900, 1050, $COLOR_TEAL, 0, 1, GetNoxHwnd())

   If Not @error Then
	  ConsoleLog("Clicking on completion! Position: " & $greenCompleteCoord[0] & " " & $greenCompleteCoord[1])
	  ControlClick($gNoxTitle, "", "", "left", 1, $greenCompleteCoord[0], $greenCompleteCoord[1])
	  Return
   EndIf

   ; Search for Complete button
   Local $completeCoord = PixelSearch(430, 780, 1900, 1050, $COLOR_ORANGE, 0, 1, GetNoxHwnd())

   If Not @error Then
	  ConsoleLog("Clicking on completion! Position: " & $completeCoord[0] & " " & $completeCoord[1])
	  ControlClick($gNoxTitle, "", "", "left", 1, $completeCoord[0], $completeCoord[1])
   Else
	  ConsoleLog("Attempting to skip dialog")
	  ControlClick($gNoxTitle, "", "", "left", 1, 200, 90)
   EndIf
EndFunc


Func IsQuestRewardVisible()
   ; Check if we are in the quest dialog
   PixelSearch(1750, 40, 1760, 60, $COLOR_BLACK_REWARD_OVERLAY, 1, 1, GetNoxHwnd())

   If Not @error Then
	  ConsoleLog("Quest reward is visible.")
	  Return True
   EndIf

   ; Check if we are in the quest dialog
   PixelSearch(1750, 40, 1760, 60, $COLOR_BLACK_REWARD_IN_MENU_OVERLAY, 1, 1, GetNoxHwnd())

   If Not @error Then
	  ConsoleLog("Quest reward is visible.")
	  Return True
   EndIf

   ConsoleLog("Not in quest reward")
   Return False
EndFunc

Func ClaimQuestReward()
   ; Search for Claim Reward button
   Local $claimCoord = PixelSearch(800, 930, 1150, 1000, $COLOR_ORANGE, 0, 1, GetNoxHwnd())

   If Not @error Then
	  ConsoleLog("Clicking on Claim Reward! Position: " & $claimCoord[0] & " " & $claimCoord[1])
	  ControlClick($gNoxTitle, "", "", "left", 1, $claimCoord[0], $claimCoord[1])
   EndIf
EndFunc


Func IsTeleportAvailable()
   If IsChecked($GUI_AutoTeleportCheckbox) Then
	  ; Check if teleporting is available
	  PixelSearch(1000, 300, 1170, 350, $COLOR_ORANGE, 0, 1, GetNoxHwnd())

	  If Not @error Then
		 ConsoleLog("We can teleport.")
		 Return True
	  EndIf
   EndIf

   Return False
EndFunc

Func Teleport()
   Local $teleportCoord = PixelSearch(1000, 300, 1170, 350, $COLOR_ORANGE, 0, 1, GetNoxHwnd())

   If Not @error Then
	  ConsoleLog("Attempting to teleport!")
	  ControlClick($gNoxTitle, "", "", "left", 1, $teleportCoord[0], $teleportCoord[1])
   EndIf
EndFunc

Func IsReviveVisible()
  Local $BLUE = 0x548FBA
  Local $GREEN = 0x59B0A8
  Local $ORANGE = 0xFF7B50

  Local $reviveInTown_X = 435
  Local $reviveInTown_Y = 750

  Local $respawnToken_X = 910
  Local $respawnToken_Y = 750

  Local $reviveExaltation_X = 1270
  Local $reviveExaltation_Y = 750

  Local $hWnd = GetNoxHwnd()

  Local $blueCount = FFColorCount($BLUE, 0, True, $reviveInTown_X + $WINDOW_X_OFFSET, $reviveInTown_Y + $WINDOW_Y_OFFSET, $reviveInTown_X + $WINDOW_X_OFFSET + 1, $reviveInTown_Y + $WINDOW_Y_OFFSET + 1, 0, $hWnd)
  Local $greenCount = FFColorCount($GREEN, 0, True, $respawnToken_X + $WINDOW_X_OFFSET, $respawnToken_Y + $WINDOW_Y_OFFSET, $respawnToken_X + $WINDOW_X_OFFSET + 1, $respawnToken_Y + $WINDOW_Y_OFFSET + 1, 0, $hWnd)
  Local $orangeCount = FFColorCount($ORANGE, 0, True, $reviveExaltation_X + $WINDOW_X_OFFSET, $reviveExaltation_Y + $WINDOW_Y_OFFSET, $reviveExaltation_X + $WINDOW_X_OFFSET + 1, $reviveExaltation_Y + $WINDOW_Y_OFFSET + 1, 0, $hWnd)

  If ($blueCount = 0 And $greenCount = 0 And $orangeCount = 0) Then Return False

  Return True
EndFunc

Func ReviveInTown()
  Local $BLUE = 0x548FBA

  Local $reviveInTown_X = 435
  Local $reviveInTown_Y = 750

  Local $hWnd = GetNoxHwnd()

  Local $blueCount = FFColorCount($BLUE, 0, True, $reviveInTown_X + $WINDOW_X_OFFSET, $reviveInTown_Y + $WINDOW_Y_OFFSET, $reviveInTown_X + $WINDOW_X_OFFSET + 1, $reviveInTown_Y + $WINDOW_Y_OFFSET + 1, 0, $hWnd)

  If ($blueCount > 0) Then
    ControlClick($gNoxTitle, "", "", "left", 1, $reviveInTown_X + $WINDOW_X_OFFSET, $reviveInTown_Y + $WINDOW_Y_OFFSET)

    ConsoleLog("Reviving in town")
  EndIf
EndFunc