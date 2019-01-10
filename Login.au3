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

Func LaunchMapleStoryM()
   Local $hWnd = GetNoxHwnd()

   ;~ Local $mushroomOrange = 0xffa13e
   ;~ Local $mushroomLightOrange = 0xffe182
   ;~ Local $skyBlue = 0xb4e0e0
   ;~ Local $maplemDarkOrange = 0xf47920

   Local $mushroomOrange = 0xf47920
   Local $christmasRed = 0xff3a3a
   Local $iceBlue = 0xbbe4fc
   Local $maplemDarkOrange = 0xf47920

   Local $minX, $maxX
   Local $minY, $maxY

   $iceBlueResult = FFNearestSpot(50, 10, 0, 0, $iceBlue, 0, True, 0, 0, 0, 0, 0, $hWnd)

   If $iceBlueResult = 0 Then Return False

   ;~ ConsoleLog("iceBlue: " &  $iceBlueResult[0] & " " & $iceBlueResult[1] & " " & $iceBlueResult[2])


   $mushroomOrangeResult = FFNearestSpot(50, 10, 0, 0, $mushroomOrange, 1, True, 0, 0, 0, 0, 0, $hWnd)

   If $mushroomOrangeResult = 0 Then Return False

   ;~ ConsoleLog("Mushroom orange: " &  $mushroomOrangeResult[0] & " " & $mushroomOrangeResult[1] & " "  & $mushroomOrangeResult[2])


   ;~ $christmasRedResult = FFNearestSpot(50, 10, 0, 0, $christmasRed, 0, True, 0, 0, 0, 0, 0, $hWnd)

   ;~ If $christmasRedResult = 0 Then Return False

   ;~ ConsoleLog("Christmas red: "  &  $christmasRedResult[0] & " " & $christmasRedResult[1] & " "  & $christmasRedResult[2])


   $maplemDarkOrangeResult = FFNearestSpot(50, 10, 0, 0, $maplemDarkOrange, 1, True, 0, 0, 0, 0, 0, $hWnd)

   If $maplemDarkOrangeResult = 0 Then Return False


   ;~ ConsoleLog("Maple M Dark orange: " &  $maplemDarkOrangeResult[0] & " " & $maplemDarkOrangeResult[1] & " "  & $maplemDarkOrangeResult[2])


   Local $resultColors = [$iceBlueResult, $mushroomOrangeResult, $maplemDarkOrangeResult]


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

   ;~ ConsoleLog($rangeX & " " & $rangeY)

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


Func TouchToStart()
   Local $hWnd = GetNoxHwnd()

   Local $mapleOrange = 0xf5791f

   Local $green = 0xa1ba5f
   Local $sky = 0xb5dfdf
   Local $yellow = 0xe8bb00

   Local $aM = GetRelativeCoords($hWnd, True, 1313, 310)
   Local $aRegion = GetRelativeCoords($hWnd, True, 150, 970)

   Local $iM = FFColorCount($mapleOrange, 0, True, $aM[0], $aM[1], $aM[0] + 1, $aM[1] + 1, 0, $hWnd)
   Local $iRegion = FFColorCount($yellow, 0, True, $aRegion[0], $aRegion[1], $aRegion[0] + 1, $aRegion[1] + 1, 0, $hWnd)

   Local $screen = GetRelativeCoords($hWnd, True, 960, 540)

   

   If $iM > 0 And $iRegion > 0 Then
	  ConsoleLog("Title screen is visible.")
     ConsoleLog("Touching to start.")
     ControlClick($hWnd, "", "", "left", 1, $screen[0], $screen[1])
   EndIf

EndFunc



Func SelectRecentServer()
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

Func IsMenuVisible()
   Local $hWnd = GetNoxHwnd()

   Local $white = 0xffffff

   Local $menu = GetRelativeCoords($hWnd, True, 1858, 31)

   Local $iMenu = FFColorCount($white, 0, True, $menu[0], $menu[1], $menu[0] + 1, $menu[1] + 1, 0, $hWnd)

   If $iMenu > 0 Then
      ConsoleLog("Menu is visible.")
      Return True
   EndIf
EndFunc

Func OpenMenu()
   Local $hWnd = GetNoxHwnd()

   Local $menu = GetRelativeCoords($hWnd, True, 1858, 31)

   ControlClick($hWnd, "", "", "left", 1, $menu[0], $menu[1])
EndFunc

Func OpenOptions()
   Local $hWnd = GetNoxHwnd()

   Local $options = GetRelativeCoords($hWnd, True, 1670, 950)

   ControlClick($hWnd, "", "", "left", 1, $options[0], $options[1])
EndFunc

Func IsOptionsMenuVisible()
   Local $hWnd = GetNoxHwnd()

   Local $BLUE = 0x548FBA

   Local $menuHeader = GetRelativeCoords($hWnd, True, 780, 100)
   Local $selectCharacterButton = GetRelativeCoords($hWnd, True, 955, 935)

   Local $iMenuHeader = FFColorCount($COLOR_MENU_HEADER, 0, True, $menuHeader[0], $menuHeader[1], $menuHeader[0] + 1, $menuHeader[1] + 1, 0, $hWnd)
   Local $iSelectCharButton = FFColorCount($BLUE, 0, True, $selectCharacterButton[0], $selectCharacterButton[1], $selectCharacterButton[0] + 1, $selectCharacterButton[1] + 1, 0, $hWnd)

   If $iMenuHeader > 0 And $iSelectCharButton > 0 Then
      ConsoleLog("Options Menu is visible.")
      Return True
   EndIf
EndFunc

Func ReselectCharacter()
   Local $hWnd = GetNoxHwnd()

   Local $selectCharacter = GetRelativeCoords($hWnd, True, 955, 935)

   ControlClick($hWnd, "", "", "left", 1, $selectCharacter[0], $selectCharacter[1])
EndFunc

Func CloseAnnouncements()
   Local $hWnd = GetNoxHwnd()

   Local $DARK_GRAY = 0x212124

   Local $iClose_X = 1868
   Local $iClose_Y = 50

   Local $grayNoticeUpdates1 = GetRelativeCoords($hWnd, True, 896, 60)
   Local $grayNoticeUpdates2 = GetRelativeCoords($hWnd, True, 1326, 60)
   Local $grayNoticeUpdates3 = GetRelativeCoords($hWnd, True, 1780, 60)

	Local $iGrayNotices1 = FFColorCount($DARK_GRAY, 5, True, $grayNoticeUpdates1[0], $grayNoticeUpdates1[1], $grayNoticeUpdates1[0] + 1, $grayNoticeUpdates1[1] + 1, 0, $hWnd)
   Local $iGrayNotices2 = FFColorCount($DARK_GRAY, 5, True, $grayNoticeUpdates2[0], $grayNoticeUpdates2[1], $grayNoticeUpdates2[0] + 1, $grayNoticeUpdates2[1] + 1, 0, $hWnd)
   Local $iGrayNotices3 = FFColorCount($DARK_GRAY, 5, True, $grayNoticeUpdates3[0], $grayNoticeUpdates3[1], $grayNoticeUpdates3[0] + 1, $grayNoticeUpdates3[1] + 1, 0, $hWnd)

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

       ConsoleLog("Closing announcements.")
   EndIf
EndFunc

Func CloseMonthlyAttendance()
   Local $s_menuName = GetMenuName()

   If $s_menuName == "Monthly Attendance Event" Then
      ConsoleLog("Monthly Attendance Event menu is visible. Closing...")
      CloseMenu()
   EndIf

EndFunc