#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#pragma compile(Out, MapleMQuest.exe)

Opt("GUIOnEventMode", 1)
Opt("PixelCoordMode", 0)
;Opt("MouseCoordMode", 0)

#include-once

#include <Date.au3>
#include <Globals.au3>
#include <GUI.au3>
#include <Nox.au3>
#include <Pixel.au3>
#include <Process.au3>
#include <Quest.au3>

Main()

Func Main()

   InitGUI()

   MainApplicationLoop()
EndFunc


Func MainApplicationLoop()
   Local $hDelayAutoQuestTimer = Null
   Local $iAutoQuestDelay = 2000

   While 1

	  ; Check if NoxPlayer is has started
	  If IsNoxRunning() Then
		 ; TODO: Check if Maple M is running
		 ; $gNoxHwnd = GetNoxHwnd()

		 ; Start button pressed
		 If $gRun Then

			; Check if we're already auto questing
			If IsAutoQuesting() Then
			   $gBotStatus = "Auto Questing"
			   ConsoleLog("Auto questing.")

			   ; Clear timer if one is already running
			   If $hDelayAutoQuestTimer <> Null Then
				  $hDelayAutoQuestTimer = Null

				  ConsoleLog("Cleared timer.")
			   EndIf

			   If IsTeleportAvailable() Then
				  Teleport()
			   EndIf
			Else
			   $gBotStatus = "Not Auto Questing"

			   ; if not auto questing, start
			   If IsQuestMenuIconVisible() Then
				  If $hDelayAutoQuestTimer = Null Then
					 ; Start timer, we'll check it again later
					 $hDelayAutoQuestTimer = TimerInit()

					 ConsoleLog("Started timer.")
				  Else
					 ; Sleep for an extra 2 second because auto quest icon
					 ; turns off when quest is completed.
					 ;Sleep(2000)

					 ; If after 2 seconds we're still not autoquesting, then open menu
					 $timeDiff = TimerDiff($hDelayAutoQuestTimer)
					 ConsoleLog("Timer diff: " & $timeDiff)
					 If $timeDiff > $iAutoQuestDelay Then
						OpenQuestMenu()
					 EndIf
				  EndIf

			   ElseIf IsQuestMenuVisible() Then
				  StartAutoQuest()
			   ElseIf IsReviveVisible() Then
				  ; Check if revive buttons are visible
				  ReviveInTown()
			   ElseIf IsQuestDialogVisible() Then
				  ; Check for the quest dialog screen
				  CompleteQuestDialog()
			   ElseIf IsQuestRewardVisible() Then
				  ; Check to claim quest reward
				  ClaimQuestReward()
			   Else
				  ConsoleLog("We're somewhere completely unknown?? Maybe changing map??")
			   EndIf
			EndIf

		 EndIf

	  Else
		 ; TODO: Start up Nox and MapleM
	  EndIf


	  ; Redraw the GUI. This should be the very last thing!
	  UpdateGUI()

	  ; Delay the script execution for 500 ms since the GUI does not have to be redrawn immediately
	  Sleep(1000)
   WEnd
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
