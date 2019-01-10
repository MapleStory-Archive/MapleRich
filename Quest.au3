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


FFSetDebugMode(0)


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

   Local $aTextTopLeft = GetRelativeCoords($hWnd, True, $text_x, $text_y)
   Local $aTextBottomRight = GetRelativeCoords($hWnd, True, $text_x + $text_width, $text_y + $text_height)

   ; Attempt at using OCR to check if we're autoquesting
   $ocr = OCR_GetTextFromWindow("AutoQuest-" & $gNoxTitle, $aTextTopLeft[0], $aTextTopLeft[1], $aTextBottomRight[0], $aTextBottomRight[1], $hWnd)

   ; Remove erroneous characters
   $ocr = StringReplace($ocr, ".", "")
   $ocr = StringReplace($ocr, "'", "")
   $ocr = StringReplace($ocr, ",", "")
   $ocr = StringStripWS($ocr, 8)

  ;~  ConsoleLog($ocr)

   If StringInStr($ocr, "Quest", 1) Then Return True

   ;If StringInStr($ocr, "Auto", 1) Then Return True


   ; Checking for the auto quest pixel colors

   Local $aAutoTopLeft = GetRelativeCoords($hWnd, True, $auto_x, $auto_y)
   Local $aAutoBottomRight = GetRelativeCoords($hWnd, True, $auto_x + $auto_width, $auto_y + $auto_height)

   $darkGrayPixels = FFColorCount(0x6B6B6B, 1, True, $aAutoTopLeft[0], $aAutoTopLeft[1], $aAutoBottomRight[0], $aAutoBottomRight[1], 0, $hWnd)

   If StringInStr($ocr, "AUTO", 1) And $darkGrayPixels < 5 Then Return False

   $goldPixels = FFColorCount(0xFAEEB5, 3, True, $aAutoTopLeft[0], $aAutoTopLeft[1], $aAutoBottomRight[0], $aAutoBottomRight[1], 0, $hWnd)

   $goldPixels2 = FFColorCount(0xF9D690, 3, True, $aAutoTopLeft[0], $aAutoTopLeft[1], $aAutoBottomRight[0], $aAutoBottomRight[1], 0, $hWnd)

   $whitePixels = FFColorCount(0xEDEDED, 3, True, $aAutoTopLeft[0], $aAutoTopLeft[1], $aAutoBottomRight[0], $aAutoBottomRight[1], 0, $hWnd)



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

   Return False
EndFunc


Func IsQuestMenuIconVisible()
   Local $iMenuIconX = 45
   Local $iMenuIconY = 285

   Local $iMenuExpandIconX = 32
   Local $iMenuExpandIconY = 296


   Local $hWnd = GetNoxHwnd()

   ; Check if menu expansion button is available
   Local $aMenuExpandSizes = GetRelativeCoords($hWnd, True, $iMenuExpandIconX, $iMenuExpandIconY)

   Local $iMenuExpandCount = FFColorCount($COLOR_WHITE, 0, True, $aMenuExpandSizes[0], $aMenuExpandSizes[1], $aMenuExpandSizes[0] + 1, $aMenuExpandSizes[1] + 1, 0, $hWnd)


   ; If available, click to expand
   If $iMenuExpandCount > 0 Then
	  ConsoleLog("Expanding quick menu.")

	  ControlClick($hWnd, "", "", "left", 1, $aMenuExpandSizes[0], $aMenuExpandSizes[1])
   EndIf


   ; Check if quest menu icon is available
   Local $aMenuIconSizes = GetRelativeCoords($hWnd, True, $iMenuIconX, $iMenuIconY)

   Local $iWhiteCount = FFColorCount($COLOR_WHITE, 0, True, $aMenuIconSizes[0], $aMenuIconSizes[1], $aMenuIconSizes[0] + 1, $aMenuIconSizes[1] + 1, 0, $hWnd)

   If $iWhiteCount > 0 Then
	  ConsoleLog("Quest menu icon is visible.")
	  Return True
   EndIf

   Return False
EndFunc


Func OpenQuestMenu()
   Local $iMenuIconX = 45
   Local $iMenuIconY = 285

   Local $hWnd = GetNoxHwnd()

   ; Check if quest menu icon is available
   Local $aMenuIconSizes = GetRelativeCoords($hWnd, True, $iMenuIconX, $iMenuIconY)

   Local $iWhiteCount = FFColorCount($COLOR_WHITE, 0, True, $aMenuIconSizes[0], $aMenuIconSizes[1], $aMenuIconSizes[0] + 1, $aMenuIconSizes[1] + 1, 0, $hWnd)

   If $iWhiteCount > 0 Then
	  ConsoleLog("Opening quest menu.")
	  ControlClick($hWnd, "", "", "left", 1, $aMenuIconSizes[0], $aMenuIconSizes[1])
   Else
	  ConsoleLog("Couldn't find quest icon in quick menu.")
   EndIf
EndFunc


Func IsQuestMenuVisible()
   ; Check if quest menu is visible
   Local $iMenuX = 30
   Local $iMenuY = 30

   Local $hWnd = GetNoxHwnd()

   ; Check if quest menu is available
   Local $aMenu = GetRelativeCoords($hWnd, True, $iMenuX, $iMenuY)

   Local $iMenuCount = FFColorCount($COLOR_MENU_HEADER, 0, True, $aMenu[0], $aMenu[1], $aMenu[0] + 1, $aMenu[1] + 1, 0, $hWnd)

   If $iMenuCount > 0 Then
	  ConsoleLog("Quest menu is visible.")
	  Return True
   EndIf

   Return False
EndFunc


Func StartAutoQuest()
   Local $hWnd = GetNoxHwnd()

   Local $iAutoPlayBtnX = 1750
   Local $iAutoPlayBtnY = 970

   Local $iMenuCloseBtnX = 1865
   Local $iMenuCloseBtnY = 60

   ; Select the first quest on the list
   ControlClick($hWnd, "", "", "left", 1, 650, 200)

   ; Check if the "Auto Play" button is there
   Local $aAutoPlayBtn = GetRelativeCoords($hWnd, True, $iAutoPlayBtnX, $iAutoPlayBtnY)

   Local $iOrangeCount = FFColorCount($COLOR_ORANGE, 0, True, $aAutoPlayBtn[0], $aAutoPlayBtn[1], $aAutoPlayBtn[0] + 1, $aAutoPlayBtn[1] + 1, 0, $hWnd)

   If $iOrangeCount > 0 Then
	  ; Click the "Auto Play" button
	  ControlClick($hWnd, "", "", "left", 1, $aAutoPlayBtn[0], $aAutoPlayBtn[1])

	  ConsoleLog("Starting Auto Quest")
   EndIf

   Sleep(1000)

   ; Check if the quest menu is still visible
   If IsQuestMenuVisible() Then
	  Local $aCloseBtn = GetRelativeCoords($hWnd, True, $iMenuCloseBtnX, $iMenuCloseBtnY)
	  ControlClick($hWnd, "", "", "left", 1, $aCloseBtn[0], $aCloseBtn[1])

	  ConsoleLog("Quest menu is still visible after starting auto quest. Attempting to close.")
   EndIf


EndFunc


Func IsQuestSkippable()
   Local $hWnd = GetNoxHwnd()

   Local $iSkipX = 190
   Local $iSkipY = 84

   Local $aSkipBtn = GetRelativeCoords($hWnd, True, $iSkipX, $iSkipY)

   Local $iWhiteCount = FFColorCount($COLOR_WHITE, 0, True, $aSkipBtn[0], $aSkipBtn[1], $aSkipBtn[0] + 1, $aSkipBtn[1] + 1, 0, $hWnd)

   If $iWhiteCount > 0 Then
	  ConsoleLog("Skipping available.")
	  Return True
   EndIf

   Return False
EndFunc


Func SkipQuestDialogue()
   Local $hWnd = GetNoxHwnd()

   Local $iSkipX = 190
   Local $iSkipY = 84

   Local $aSkipBtn = GetRelativeCoords($hWnd, True, $iSkipX, $iSkipY)

   ControlClick($hWnd, "", "", "left", 1, $aSkipBtn[0], $aSkipBtn[1])
EndFunc


Func IsQuestDialogVisible()
   Local $hWnd = GetNoxHwnd()

   Local $iBagX = 1750
   Local $iBagY = 40

   Local $aBagBtn = GetRelativeCoords($hWnd, True, $iBagX, $iBagY)

   ; Check if we are in the quest dialog
   Local $iBlackOverlayCount = FFColorCount($COLOR_BLACK_DIALOG_OVERLAY, 0, True, $aBagBtn[0], $aBagBtn[1], $aBagBtn[0] + 1, $aBagBtn[1] + 1, 0, $hWnd)
   Local $iBlackOverlayCount2 = FFColorCount($COLOR_BLACK_DIALOG_IN_MENU_OVERLAY, 0, True, $aBagBtn[0], $aBagBtn[1], $aBagBtn[0] + 1, $aBagBtn[1] + 1, 0, $hWnd)

   If $iBlackOverlayCount > 0 Or $iBlackOverlayCount2 > 0 Then
	  ConsoleLog("Quest dialog is visible.")
	  Return True
   EndIf

   Return False
EndFunc


Func CompleteQuestDialog()
   Local $hWnd = GetNoxHwnd()

   ; Search for Green Complete button first
   Local $greenCompleteCoord = PixelSearch(430, 780, 1900, 1050, $COLOR_TEAL, 0, 1, $hWnd)

   If Not @error Then
	  ConsoleLog("Clicking on completion! Position: " & $greenCompleteCoord[0] & " " & $greenCompleteCoord[1])
	  ControlClick($hWnd, "", "", "left", 1, $greenCompleteCoord[0], $greenCompleteCoord[1])
	  Return
   EndIf

   ; Search for Complete button
   Local $completeCoord = PixelSearch(430, 780, 1900, 1050, $COLOR_ORANGE, 0, 1, $hWnd)

   If Not @error Then
	  ConsoleLog("Clicking on completion! Position: " & $completeCoord[0] & " " & $completeCoord[1])
	  ControlClick($hWnd, "", "", "left", 1, $completeCoord[0], $completeCoord[1])
   EndIf
EndFunc

Func CompleteQuestDialogNew()
   Local $hWnd = GetNoxHwnd()

   Local $iQuestDialogLeft = 1500
   Local $iQuestDialogTop = 850
   Local $iQuestDialogRight = 1900
   Local $iQuestDialogBottom = 1050

   Local $aQuestDialogTopLeft = GetRelativeCoords($hWnd, True, $iQuestDialogLeft, $iQuestDialogTop)
   Local $aQuestDialogBottomRight = GetRelativeCoords($hWnd, True, $iQuestDialogRight, $iQuestDialogBottom)

   ; Search for Green Complete button first
   Local $greenCoord = FFNearestPixel($aQuestDialogTopLeft[0], $aQuestDialogTopLeft[1], $COLOR_TEAL, True, $aQuestDialogTopLeft[0], $aQuestDialogTopLeft[1], $aQuestDialogBottomRight[0], $aQuestDialogBottomRight[1], 0, $hWnd)

   If IsArray($greenCoord) Then
	  ControlClick($hWnd, "", "", "left", 1, $greenCoord[0] + 10, $greenCoord[1] + 10)

	  ConsoleLog("Completing quest! Green")
	  Return
   EndIf

   ; Search for Complete button
   Local $completeCoord = FFNearestPixel($aQuestDialogTopLeft[0], $aQuestDialogTopLeft[1], $COLOR_ORANGE, True, $aQuestDialogTopLeft[0], $aQuestDialogTopLeft[1], $aQuestDialogBottomRight[0], $aQuestDialogBottomRight[1], 0, $hWnd)

   If IsArray($completeCoord) Then
	  ControlClick($hWnd, "", "", "left", 1, $completeCoord[0] + 10, $completeCoord[1] + 10)
	  ConsoleLog($completeCoord[0] & " " & $completeCoord[1])

	  ConsoleLog("Completing quest! Orange")
   EndIf


   Local $iQuestDialogLeft2 = 430
   Local $iQuestDialogTop2 = 780
   Local $iQuestDialogRight2 = 640
   Local $iQuestDialogBottom2 = 950

   Local $aQuestDialogTopLeft2 = GetRelativeCoords($hWnd, True, $iQuestDialogLeft2, $iQuestDialogTop2)
   Local $aQuestDialogBottomRight2 = GetRelativeCoords($hWnd, True, $iQuestDialogRight2, $iQuestDialogBottom2)

   ; Search for Green Complete button first
   Local $greenCoord2 = FFNearestPixel($aQuestDialogTopLeft2[0], $aQuestDialogTopLeft2[1], $COLOR_TEAL, True, $aQuestDialogTopLeft2[0], $aQuestDialogTopLeft2[1], $aQuestDialogBottomRight2[0], $aQuestDialogBottomRight2[1], 0, $hWnd)

   If IsArray($greenCoord2) Then
	  ControlClick($hWnd, "", "", "left", 1, $greenCoord2[0] + 10, $greenCoord2[1] + 10)

	  ConsoleLog("Completing quest! Green")
	  Return
   EndIf

   ; Search for Complete button
   Local $completeCoord2 = FFNearestPixel($aQuestDialogTopLeft2[0], $aQuestDialogTopLeft2[1], $COLOR_ORANGE, True, $aQuestDialogTopLeft2[0], $aQuestDialogTopLeft2[1], $aQuestDialogBottomRight2[0], $aQuestDialogBottomRight2[1], 0, $hWnd)

   If IsArray($completeCoord2) Then
	  ControlClick($hWnd, "", "", "left", 1, $completeCoord2[0] + 10, $completeCoord2[1] + 10)

	  ConsoleLog("Completing quest! Orange")
   EndIf


EndFunc


Func IsQuestRewardVisible()
   Local $hWnd = GetNoxHwnd()

   ; Check if we are in the quest dialog
   PixelSearch(1750, 40, 1760, 60, $COLOR_BLACK_REWARD_OVERLAY, 1, 1, $hWnd)

   If Not @error Then
	  ConsoleLog("Quest reward is visible.")
	  Return True
   EndIf

   ; Check if we are in the quest dialog
   PixelSearch(1750, 40, 1760, 60, $COLOR_BLACK_REWARD_IN_MENU_OVERLAY, 1, 1, $hWnd)

   If Not @error Then
	  ConsoleLog("Quest reward is visible.")
	  Return True
   EndIf

   ConsoleLog("Not in quest reward")
   Return False
EndFunc


Func IsClaimRewardVisible()
   Local $hWnd = GetNoxHwnd()

   Local $iClaimX = 850
   Local $iClaimY = 950
   Local $iClaimWidth = 225
   Local $iClaimHeight = 30

   Local $aClaimTopLeft = GetRelativeCoords($hWnd, True, $iClaimX, $iClaimY)
   Local $aClaimBottomRight = GetRelativeCoords($hWnd, True, $iClaimX + $iClaimWidth, $iClaimY + $iClaimHeight)

   ; Check for an orange button first
   Local $iOrangeCount = FFColorCount($COLOR_ORANGE, 0, True, $aClaimTopLeft[0], $aClaimTopLeft[1], $aClaimTopLeft[0] + 1, $aClaimTopLeft[1] + 1, 0, $hWnd)

   If $iOrangeCount = 0 Then Return False

   ; Attempt at using OCR to check if "Claim Reward" is available
   $ocr = OCR_GetTextFromWindow("ClaimReward-" & $gNoxTitle, $aClaimTopLeft[0], $aClaimTopLeft[1], $aClaimBottomRight[0], $aClaimBottomRight[1], $hWnd)

   ; Remove erroneous characters
   $ocr = StringReplace($ocr, ".", "")
   $ocr = StringReplace($ocr, "'", "")
   $ocr = StringReplace($ocr, ",", "")
   $ocr = StringStripWS($ocr, 8)

;~   ConsoleLog($ocr)

   If StringInStr($ocr, "ClaimReward", 1) Then
	  ConsoleLog("Claim reward is visible.")
	  Return True
   EndIf

   Return False
EndFunc


Func ClaimQuestReward()
   Local $hWnd = GetNoxHwnd()

   Local $iClaimX = 850
   Local $iClaimY = 950

   Local $aClaimTopLeft = GetRelativeCoords($hWnd, True, $iClaimX, $iClaimY)

   ControlClick($hWnd, "", "", "left", 1, $aClaimTopLeft[0], $aClaimTopLeft[1])
   ConsoleLog("Claiming reward!")
EndFunc


Func IsTeleportAvailable()
   Local $hWnd = GetNoxHwnd()

   Local $iTeleportX = 1000
   Local $iTeleportY = 300

   If IsChecked($GUI_AutoTeleportCheckbox) Then
	  ; Check if teleporting is available
	  Local $aTeleport = GetRelativeCoords($hWnd, True, $iTeleportX, $iTeleportY)

	  Local $iOrangeCount = FFColorCount($COLOR_ORANGE, 0, True, $aTeleport[0], $aTeleport[1], $aTeleport[0] + 1, $aTeleport[1] + 1, 0, $hWnd)

	  If $iOrangeCount > 0 Then
		 ConsoleLog("We can teleport.")
		 Return True
	  EndIf
   EndIf

   Return False
EndFunc


Func Teleport()
   Local $hWnd = GetNoxHwnd()

   Local $iTeleportX = 1000
   Local $iTeleportY = 300

   Local $aTeleport = GetRelativeCoords($hWnd, True, $iTeleportX, $iTeleportY)

   ControlClick($hWnd, "", "", "left", 1, $aTeleport[0], $aTeleport[1])

   ConsoleLog("Attempting to teleport!")
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

  Local $aReviveInTown = GetRelativeCoords($hWnd, True, $reviveInTown_X, $reviveInTown_Y)

  Local $aRespawnToken = GetRelativeCoords($hWnd, True, $respawnToken_X, $respawnToken_Y)

  Local $aReviveExaltation = GetRelativeCoords($hWnd, True, $reviveExaltation_X, $reviveExaltation_Y)


  Local $blueCount = FFColorCount($BLUE, 0, True, $aReviveInTown[0], $aReviveInTown[1], $aReviveInTown[0] + 1, $aReviveInTown[1] + 1, 0, $hWnd)
  Local $greenCount = FFColorCount($GREEN, 0, True, $aRespawnToken[0], $aRespawnToken[1], $aRespawnToken[0] + 1, $aRespawnToken[1] + 1, 0, $hWnd)
  Local $orangeCount = FFColorCount($ORANGE, 0, True, $aReviveExaltation[0], $aReviveExaltation[1], $aReviveExaltation[0] + 1, $aReviveExaltation[1] + 1, 0, $hWnd)

  If ($blueCount = 0 And $greenCount = 0 And $orangeCount = 0) Then Return False

  Return True
EndFunc


Func ReviveInTown()
  Local $BLUE = 0x548FBA

  Local $reviveInTown_X = 435
  Local $reviveInTown_Y = 750

  Local $hWnd = GetNoxHwnd()

  Local $aReviveInTown = GetRelativeCoords($hWnd, True, $reviveInTown_X, $reviveInTown_Y)

  Local $blueCount = FFColorCount($BLUE, 0, True, $aReviveInTown[0], $aReviveInTown[1], $aReviveInTown[0] + 1, $aReviveInTown[1] + 1, 0, $hWnd)

  If ($blueCount > 0) Then
    ControlClick($hWnd, "", "", "left", 1, $aReviveInTown[0], $aReviveInTown[1])

    ConsoleLog("Reviving in town.")
  EndIf
EndFunc


Func CloseAd()
   Local $aText = ['Do', 'not', 'show', 'for', 'today']

   Local $iDoNotShow_X = 335
	Local $iDoNotShow_Y = 925
	Local $iDoNotShow_Width = 275
	Local $iDoNotShow_Height = 35

   Local $iCloseAd_X = 1655
   Local $iCloseAd_Y = 110

   Local $hWnd = GetNoxHwnd()

   Local $aDoNotShowTopLeft = GetRelativeCoords($hWnd, True, $iDoNotShow_X, $iDoNotShow_Y)
   Local $aDoNotShowBottomRight = GetRelativeCoords($hWnd, True, $iDoNotShow_X + $iDoNotShow_Width, $iDoNotShow_Y + $iDoNotShow_Height)

	$ocr = OCR_GetTextFromWindow("Ad-" & $gNoxTitle, $aDoNotShowTopLeft[0], $aDoNotShowTopLeft[1], $aDoNotShowBottomRight[0], $aDoNotShowBottomRight[1], $hWnd)

   ; Trim leading and trailing spaces
   $ocr = StringStripWS($ocr, 3)

   $bFound = false

   For $vText in $aText
     If StringInStr($ocr, $vText) Then
	 	$bFound = True
		ExitLoop
	 EndIf
   Next

	If Not $bFound Then
		$ocr = OCR_GetTextFromWindow("Ad-" & $gNoxTitle, $aDoNotShowTopLeft[0], $aDoNotShowTopLeft[1], $aDoNotShowBottomRight[0], $aDoNotShowBottomRight[1], $hWnd, False)
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


Func CloseForfeitQuestModal()
   Local $iTitle_X = 810
	Local $iTitle_Y = 240
	Local $iTitle_Width = 305
	Local $iTitle_Height = 55

   Local $iConfirm_X = 968
   Local $iConfirm_Y = 800

   Local $hWnd = GetNoxHwnd()

   Local $aDoNotShowTopLeft = GetRelativeCoords($hWnd, True, $iTitle_X, $iTitle_Y)
   Local $aDoNotShowBottomRight = GetRelativeCoords($hWnd, True, $iTitle_X + $iTitle_Width, $iTitle_Y + $iTitle_Height)

	$ocr = OCR_GetTextFromWindow("Ad-" & $gNoxTitle, $aDoNotShowTopLeft[0], $aDoNotShowTopLeft[1], $aDoNotShowBottomRight[0], $aDoNotShowBottomRight[1], $hWnd)

   ; Trim leading and trailing spaces
   $ocr = StringStripWS($ocr, 3)

   If StringInStr($ocr, "Forfeit") Then
      Local $aCloseAdButton = GetRelativeCoords($hWnd, True, $iConfirm_X, $iConfirm_Y)

       ControlClick($hWnd, "", "", "left", 1, $aCloseAdButton[0], $aCloseAdButton[1])

       ConsoleLog("Closing 'Forfeit Quest' modal.")
   EndIf
EndFunc