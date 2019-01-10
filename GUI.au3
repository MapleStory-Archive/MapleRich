#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#include <Globals.au3>

Global $GUI
Global $GUI_Width = 685, $GUI_Height = 450
Global $GUI_GameStatus, $GUI_PlayerStatus, $GUI_BotStatus
Global $GUI_AutoTeleportCheckbox
Global $GUI_StartStopButton
Global $GUI_ProcessList
Global $GUI_OutputLog
Global $GUI_LoopDelay, $GUI_QuestDelay, $GUI_ApplySettings

Global $aProcessList


Func InitGUI()
   $GUI = GUICreate($programTitle, 697, 451, -1, -1)

   ; Process
   $GUI_SelectProcessLabel = GUICtrlCreateLabel("Select a process", 8, 8, 83, 17)
   $GUI_ProcessList = GUICtrlCreateCombo("", 8, 24, 275, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))

   $aProcessList = WinList($NOX_TITLE)
   For $i = 1 To UBound($aProcessList) - 1
	  If $aProcessList[$i][0] <> "" Then GUICtrlSetData($GUI_ProcessList, $i & "; " & $aProcessList[$i][0] & "; " & $aProcessList[$i][1])
   Next


   $Label2 = GUICtrlCreateLabel("Bot Status:", 8, 56, 56, 17)
   $GUI_BotStatus = GUICtrlCreateLabel($gBotStatus, 72, 56, 210, 17)

   $Settings = GUICtrlCreateGroup("Settings", 8, 80, 275, 129)
   $GUI_LoopDelay = GUICtrlCreateInput($gLoopDelay, 18, 120, 110, 21)
   GUICtrlCreateLabel("Loop Delay (ms)", 18, 103, 80, 17)
   $GUI_QuestDelay = GUICtrlCreateInput($gQuestDelay, 153, 120, 110, 21)
   GUICtrlCreateLabel("Quest Delay (ms)", 154, 103, 84, 17)
   $GUI_ApplySettings = GUICtrlCreateButton("Apply", 16, 168, 250, 25)
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   $Options = GUICtrlCreateGroup("Bot Options", 8, 224, 275, 89)
   $GUI_AutoTeleportCheckbox = GUICtrlCreateCheckbox("Auto Teleport", 16, 248, 97, 17)
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   $GUI_StartStopButton = GUICtrlCreateButton("Start", 8, 344, 275, 33)
   GUICtrlSetCursor (-1, 0)

   $GUI_VersionLabel = GUICtrlCreateLabel("Version " & FileGetVersion(@AutoItExe), 8, 416, 275, 17, $SS_CENTER)

   $GUI_OutputLogLabel = GUICtrlCreateLabel("Output Log", 304, 8, 57, 17)
   $GUI_OutputLog = GUICtrlCreateEdit("", 305, 24, 389, 425, BitOR($GUI_SS_DEFAULT_EDIT,$ES_READONLY))
   GUICtrlSetData(-1, $gLog)

   ; Sets the callback function for when user selects a process
   GUICtrlSetOnEvent($GUI_ProcessList, "GUISelectProcess")

   ; Sets the callback function for when user toggles auto quest
   GUICtrlSetOnEvent($GUI_StartStopButton, "GUIToggleAutoQuest")

   ; Sets the callback function for when user applies settings
   GUICtrlSetOnEvent($GUI_ApplySettings, "GUIApplySettings")

   ; Set callback function for when user exits the application
   GUISetOnEvent($GUI_EVENT_CLOSE, "GUICloseButton")

   ; Shows the GUI
   ; This code should always be the last line after generating the GUI
   GUISetState(@SW_SHOW)
EndFunc


Func UpdateGUI()
   ; Update the Bot Status
   GUICtrlSetData($GUI_BotStatus, $gBotStatus)

   ; Update the output log
   ;GUICtrlSetData($GUI_OutputLog, $gLog)
EndFunc


Func ExitGUI()
   GUIDelete($GUI)
EndFunc


Func GUICloseButton()
   ConsoleLog("Close button has been clicked.")
   ExitGUI()

   Exit
EndFunc


Func GUISelectProcess()
   Local $sName = GUICtrlRead($GUI_ProcessList)

   Local $aProcess = StringSplit($sName, "; ")

   Local $iProcessIndex = $aProcess[1]

   $gNoxHwnd = $aProcessList[$iProcessIndex][1]

   $gNoxTitle = $aProcessList[$iProcessIndex][0]

   ConsoleLog("Selected process: " & $gNoxTitle)
EndFunc


Func GUIToggleAutoQuest()
   ConsoleLog($gRun ? "Stopping bot." : "Starting bot.")
   $gRun = $gRun ? False : True

   ; Update the Start/Stop button
   GUICtrlSetData($GUI_StartStopButton, $gRun ? "Stop" : "Start")

   If $gRun = False Then
	  $gBotStatus = "Inactive"
   EndIf

   Return $gRun
EndFunc

Func GUIApplySettings()
   $loopDelay = GUICtrlRead($GUI_LoopDelay)
   $questDelay = GUICtrlRead($GUI_QuestDelay)

   $gLoopDelay = $loopDelay
   $gQuestDelay = $questDelay

   ConsoleLog("Applied settings.")
EndFunc

Func IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc