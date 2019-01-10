#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Name:			 MapleRich
 Author:         Richard

#ce ----------------------------------------------------------------------------

#NoTrayIcon
#RequireAdmin

#AutoIt3Wrapper_Icon=msm.ico
#AutoIt3Wrapper_Res_HiDpi=Y
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/rsln /MI=3

#pragma compile(FileVersion, 0.6.1)
#pragma compile(Icon, msm.ico)
#pragma compile(Out, MapleRich.exe)

Opt("GUIOnEventMode", 1)
Opt("PixelCoordMode", 0)
Opt("GUICloseOnESC", 0) ; Don't send the $GUI_EVENT_CLOSE message when ESC is pressed.

#include-once

#include <GuiEdit.au3>

#include <Date.au3>
#include <Globals.au3>
#include <GUI.au3>
#include <Login.au3>
#include <Nox.au3>
#include <Process.au3>
#include <Quest.au3>


; Initialize the GUI
InitGUI()

; Run the main application loop
MainApplicationLoop()


Func MainApplicationLoop()
   Local $hDelayAutoQuestTimer = Null
   Local $iAutoQuestAttempt = 0

   While 1

	  ; Start button pressed
	  If $gRun Then

		 If $gBotStatus = "Login" Then
		 	$iAutoQuestAttempt = 0
			$hDelayAutoQuestTimer = Null

			If IsNoticesVisible() Then

			ElseIf IsTitleScreenVisible() Then
			   TouchToStart()
			ElseIf IsSelectServerVisible() Then

			ElseIf IsCharacterSelection() Then
			   Sleep(1000)
			   StartCharacter()
			   $gBotStatus = "Loading into world"
			EndIf
		 ElseIf $gBotStatus = "Relogin" Then
		 	If IsMenuVisible() Then
			 	OpenMenu()

				Sleep(500)

				OpenOptions()

				Sleep(500)

				If IsOptionsMenuVisible() Then
					ReselectCharacter()
					$gBotStatus = "Login"
				EndIf
			EndIf
		 Else

			; Check if we're already auto questing
			If IsAutoQuesting() Then
			   $gBotStatus = "Auto Questing"
			   ;ConsoleLog("Auto questing.")

				; Set attempts to 0
			   $iAutoQuestAttempt = 0

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

			   If $iAutoQuestAttempt > 20 Then
			      ConsoleLog("Attempted to open auto quest 20 times. We're possibly stuck. We'll attempt to relog.")

				  $gBotStatus = "Relogin"
				  ContinueLoop
				EndIf

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
					 If $timeDiff > $gQuestDelay Then
						OpenQuestMenu()
					 EndIf
				  EndIf

			   ElseIf IsQuestMenuVisible() Then
			      ; Increment attempt by 1
			      $iAutoQuestAttempt += 1
				  ConsoleLog("Attempting to start auto quest " & $iAutoQuestAttempt)
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

	  Else
		 $iAutoQuestAttempt = 0
		 $hDelayAutoQuestTimer = Null
	  EndIf


	  ; Redraw the GUI. This should be the very last thing!
	  UpdateGUI()

	  ; Delay the loop execution since the GUI does not have to be redrawn immediately
	  Sleep($gLoopDelay)
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

	; Clear the output log when char length reaches over 20000
   If (StringLen(GUICtrlRead($GUI_OutputLog)) > 20000) Then
	   GUICtrlSetData($GUI_OutputLog, "")
   EndIf

   If $withDateTime Then _GUICtrlEdit_AppendText($GUI_OutputLog, _NowTime(5) & " ")
   _GUICtrlEdit_AppendText($GUI_OutputLog, $text)
   If $withCR Then _GUICtrlEdit_AppendText($GUI_OutputLog, @CRLF)
EndFunc