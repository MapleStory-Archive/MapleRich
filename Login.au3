#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include-once

#include <Math.au3>
#include <FastFind.au3>

#include <Nox.au3>
#include <OCR.au3>
#include <Utils.au3>

Func IsMapleMIconVisible()
   Local $hWnd = GetNoxHwnd()

   Local $mushroomOrange = 0xffa13e
   Local $mushroomLightOrange = 0xffe182
   Local $skyBlue = 0xb4e0e0
   Local $maplemDarkOrange = 0xf47920

   Local $minX, $maxX
   Local $minY, $maxY

   $skyBlueResult = FFNearestSpot(50, 10, 0, 0, $skyBlue, 0, True, 0, 0, 0, 0, 0, $hWnd)

   If $skyBlueResult = 0 Then Return False

   ;ConsoleLog("Skyblue: " &  $skyBlueResult[0] & " " & $skyBlueResult[1] & " " & $skyBlueResult[2])


   $mushroomOrangeResult = FFNearestSpot(50, 10, 0, 0, $mushroomOrange, 1, True, 0, 0, 0, 0, 0, $hWnd)

   If $mushroomOrangeResult = 0 Then Return False

   ;ConsoleLog("Mushroom orange: " &  $mushroomOrangeResult[0] & " " & $mushroomOrangeResult[1] & " "  & $mushroomOrangeResult[2])


   $mushroomLightOrangeResult = FFNearestSpot(50, 10, 0, 0, $mushroomLightOrange, 0, True, 0, 0, 0, 0, 0, $hWnd)

   If $mushroomLightOrangeResult = 0 Then Return False

   ;ConsoleLog("Mushroom light orange: "  &  $mushroomLightOrangeResult[0] & " " & $mushroomLightOrangeResult[1] & " "  & $mushroomLightOrangeResult[2])


   $maplemDarkOrangeResult = FFNearestSpot(50, 10, 0, 0, $maplemDarkOrange, 1, True, 0, 0, 0, 0, 0, $hWnd)

   If $maplemDarkOrangeResult = 0 Then Return False


   ;ConsoleLog("Maple M Dark orange: " &  $maplemDarkOrangeResult[0] & " " & $maplemDarkOrangeResult[1] & " "  & $maplemDarkOrangeResult[2])


   Local $resultColors = [$skyBlueResult, $mushroomOrangeResult, $mushroomLightOrangeResult, $maplemDarkOrangeResult]


   For $i = 0 to UBound($resultColors) - 1
	  Local $colorResult = $resultColors[$i]
	  If $i = 0 Then
		 $minX = $colorResult[0]
		 $maxX = $colorResult[0]

		 $minY = $colorResult[1]
		 $maxY = $colorResult[1]
		 ContinueLoop
	  EndIf

	  $minX = _Min($colorResult[0], $minX)
	  $maxX = _Max($colorResult[0], $maxX)

	  $minY = _Min($colorResult[1], $minY)
	  $maxY = _Max($colorResult[1], $maxY)
   Next

   Local $rangeX = ($maxX - $minX)
   Local $rangeY = ($maxY - $minY)

   ConsoleLog($rangeX & " " & $rangeY)

   Local $aRelativeRange = GetRelativeCoords($hWnd, True, 30, 20)

   If ($rangeX < $aRelativeRange[0]) And ($rangeY < $aRelativeRange[1]) Then
	  ConsoleLog("We're on the home screen.")
	  ControlClick($hWnd, "", "", "left", 1, ($minX + $maxX) / 2, ($minY + $maxY) / 2)

	  ConsoleLog("Launching MapleStory M.")
	  Return True
   EndIf

   Return False
EndFunc


Func IsNoticesVisible()
   Local $hWnd = GetNoxHwnd()

   Local $closeBtnX = 1900
   Local $closeBtnY = 20

   Local $blackOverlayColor = 0x121616

   Local $aCloseBtn = GetRelativeCoords($hWnd, True, $closeBtnX, $closeBtnY)

   Local $iCloseBtnCount = FFColorCount($blackOverlayColor, 2, True, $aCloseBtn[0], $aCloseBtn[1], $aCloseBtn[0] + 1, $aCloseBtn[1] + 1, 0, $hWnd)

   ; If available, click to close
   If $iCloseBtnCount > 0 Then
	  ControlClick($hWnd, "", "", "left", 1, $aCloseBtn[0], $aCloseBtn[1])

	  ConsoleLog("Closed notices.")
   EndIf
EndFunc


Func IsTitleScreenVisible()
   Local $hWnd = GetNoxHwnd()

   Local $green = 0xa1ba5f
   Local $sky = 0xb5dfdf
   Local $yellow = 0xe8bb00

   Local $aTreeLeft = GetRelativeCoords($hWnd, True, 90, 200)
   Local $aTreeRight = GetRelativeCoords($hWnd, True, 1800, 100)
   Local $aSky = GetRelativeCoords($hWnd, True, 1000, 100)
   Local $aRegion = GetRelativeCoords($hWnd, True, 150, 970)

   Local $iTreeLeft = FFColorCount($green, 0, True, $aTreeLeft[0], $aTreeLeft[1], $aTreeLeft[0] + 1, $aTreeLeft[1] + 1, 0, $hWnd)
   Local $iTreeRight = FFColorCount($green, 0, True, $aTreeRight[0], $aTreeRight[1], $aTreeRight[0] + 1, $aTreeRight[1] + 1, 0, $hWnd)
   Local $iSky = FFColorCount($sky, 0, True, $aSky[0], $aSky[1], $aSky[0] + 1, $aSky[1] + 1, 0, $hWnd)
   Local $iRegion = FFColorCount($yellow, 0, True, $aRegion[0], $aRegion[1], $aRegion[0] + 1, $aRegion[1] + 1, 0, $hWnd)

   If $iTreeLeft > 0 And $iTreeRight > 0 And $iSky > 0 And $iRegion > 0 Then
	  ConsoleLog("Title screen is visible.")
	  Return True
   EndIf

   Return False
EndFunc


Func TouchToStart()
   Local $hWnd = GetNoxHwnd()
   Local $screen = GetRelativeCoords($hWnd, True, 960, 540)

   ControlClick($hWnd, "", "", "left", 1, $screen[0], $screen[1])

   ConsoleLog("Touching to start.")
EndFunc


Func IsSelectServerVisible()
   Local $hWnd = GetNoxHwnd()

   Local $menu = 0x515f6e
   Local $menuBody = 0xf2f2f2

   Local $aMenu = GetRelativeCoords($hWnd, True, 700, 90)
   Local $aMenuBody = GetRelativeCoords($hWnd, True, 700, 900)
   Local $aRecentServer = GetRelativeCoords($hWnd, True, 700, 320)

   Local $iMenu = FFColorCount($menu, 0, True, $aMenu[0], $aMenu[1], $aMenu[0] + 1, $aMenu[1] + 1, 0, $hWnd)
   Local $iMenuBody = FFColorCount($menuBody, 0, True, $aMenuBody[0], $aMenuBody[1], $aMenuBody[0] + 1, $aMenuBody[1] + 1, 0, $hWnd)
   Local $iRecentServer = FFColorCount($COLOR_WHITE, 0, True, $aRecentServer[0], $aRecentServer[1], $aRecentServer[0] + 1, $aRecentServer[1] + 1, 0, $hWnd)

   If $iMenu > 0 And $iMenuBody > 0 And $iRecentServer > 0 Then
	  ControlClick($hWnd, "", "", "left", 1, $aRecentServer[0], $aRecentServer[1])

	  ConsoleLog("Selecting recent server.")
	  Return True
   EndIf

   Return False
EndFunc


Func IsCharacterSelection()
   Local $hWnd = GetNoxHwnd()

   Local $brown = 0xe6c58c
   Local $lightBrown = 0xf7e7c6

   Local $charSelectA = GetRelativeCoords($hWnd, True, 1765, 200)
   Local $charSelectB = GetRelativeCoords($hWnd, True, 1815, 200)
   Local $charSelectC = GetRelativeCoords($hWnd, True, 1660, 600)

   Local $iCharSelectA = FFColorCount($brown, 0, True, $charSelectA[0], $charSelectA[1], $charSelectA[0] + 1, $charSelectA[1] + 1, 0, $hWnd)
   Local $iCharSelectB = FFColorCount($lightBrown, 0, True, $charSelectB[0], $charSelectB[1], $charSelectB[0] + 1, $charSelectB[1] + 1, 0, $hWnd)
   Local $iCharSelectC = FFColorCount($lightBrown, 0, True, $charSelectC[0], $charSelectC[1], $charSelectC[0] + 1, $charSelectC[1] + 1, 0, $hWnd)

   If $iCharSelectA > 0 And $iCharSelectB > 0 And $iCharSelectC > 0 Then
	  ConsoleLog("Character selection is visible.")
	  Return True
   EndIf

   Return False
EndFunc

Func StartCharacter()
   Local $hWnd = GetNoxHwnd()

   Local $start = GetRelativeCoords($hWnd, True, 1615, 925)

   ControlClick($hWnd, "", "", "left", 1, $start[0], $start[1])
EndFunc