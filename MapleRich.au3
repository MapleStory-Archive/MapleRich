#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#pragma compile(Out, MapleRich.exe)
#pragma compile(FileVersion, 0.4.3)
#pragma compile(Icon, msm.ico)

#AutoIt3Wrapper_Icon=msm.ico
#AutoIt3Wrapper_Res_HiDpi=Y

Opt("GUIOnEventMode", 1)
Opt("PixelCoordMode", 0)
;Opt("MouseCoordMode", 0)

#include-once

#Include <GuiEdit.au3>

#include <Date.au3>
#include <Globals.au3>
#include <GUI.au3>
#include <Login.au3>
#include <Nox.au3>
#include <Process.au3>
#include <Quest.au3>

Main()

Func Main()

   InitGUI()

   MainApplicationLoop()
EndFunc


Func MainApplicationLoop()
   Local $hDelayAutoQuestTimer = Null

   ; Milliseconds to wait before opening quest menu
   Local $iAutoQuestDelay = 2000

   While 1

	  ; Start button pressed
	  If $gRun Then

		 If $gBotStatus = "Login" Then

			If IsNoticesVisible() Then

			ElseIf IsTitleScreenVisible() Then
			   TouchToStart()
			ElseIf IsSelectServerVisible() Then

			ElseIf IsCharacterSelection() Then
			   Sleep(1000)
			   StartCharacter()
			   $gBotStatus = "Loading into world"
			EndIf

		 Else

			; Check if we're already auto questing
			If IsAutoQuesting() Then
			   $gBotStatus = "Auto Questing"
			   ;ConsoleLog("Auto questing.")

			   ; Clear timer if one is already running
			   If $hDelayAutoQuestTimer <> Null Then
				  $hDelayAutoQuestTimer = Null

				  ConsoleLog("Cleared wait timer.")
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

					 ConsoleLog("Started wait timer.")
				  Else
					 ; Wait for an extra 2 second because auto quest icon
					 ; turns off when quest is completed.

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
			   ElseIf IsQuestSkippable() Then
				  ; Check if we can skip quest
				  SkipQuestDialogue()
			   ElseIf IsQuestDialogVisible() Then
				  ; Check for the quest dialog screen
				  CompleteQuestDialogNew()
			   ElseIf IsClaimRewardVisible() Then
				  ; Check to claim quest reward
				  ClaimQuestReward()
			   ElseIf IsMapleMIconVisible() Or IsTitleScreenVisible() Or IsCharacterSelection() Then
				  $gBotStatus = "Login"
			   Else
				  ConsoleLog("We're somewhere completely unknown?? Maybe changing map??")
			   EndIf
			EndIf

		 EndIf

	  EndIf


	  ; Redraw the GUI. This should be the very last thing!
	  UpdateGUI()

	  ; Delay the script execution for 500 ms since the GUI does not have to be redrawn immediately
	  Sleep(750)
   WEnd
EndFunc


Func ConsoleLog($text, $withDateTime = True, $withCR = True)
   If $gDebug Then
	  If $withDateTime Then ConsoleWrite(_NowTime(5) & " ")
	  ConsoleWrite($text)
	  If $withCR Then ConsoleWrite(@CRLF)

	  If $withDateTime Then FileWrite("log.txt", _NowTime(5) & " ")
	  FileWrite("log.txt", $text)
	  If $withCR Then FileWrite("log.txt", @CRLF)
   EndIf

   If $withDateTime Then _GUICtrlEdit_AppendText($GUI_OutputLog, _NowTime(5) & " ")
   _GUICtrlEdit_AppendText($GUI_OutputLog, $text)
   If $withCR Then _GUICtrlEdit_AppendText($GUI_OutputLog, @CRLF)
EndFunc
