#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>

#include <Globals.au3>

Global $GUI
Global $GUI_Width = 685, $GUI_Height = 400
Global $GUI_GameStatus, $GUI_PlayerStatus, $GUI_BotStatus
Global $GUI_AutoTeleportCheckbox
Global $GUI_StartStopButton
Global $GUI_ProcessList
Global $GUI_OutputLog

Global $aProcessList


Func InitGUI()
   $GUI = GUICreate($programTitle, $GUI_Width, $GUI_Height)

   Local $x=5, $y=10, $groupWidth=275, $groupHeight=90
   Local $groupItemOffset = 10

   GUICtrlCreateLabel("Select a process", $x, $y, $groupWidth, 17)

   GUICtrlCreateLabel("Output Log", $x + $groupWidth + 20, $y, $groupWidth, 17)

   $y += 15

   $GUI_ProcessList = GUICtrlCreateCombo("", $x, $y, $groupWidth, 40)
   $aProcessList = WinList($NOX_TITLE)
   For $i = 1 To UBound($aProcessList) - 1
	  If $aProcessList[$i][0] <> "" Then GUICtrlSetData($GUI_ProcessList, $i & "; " & $aProcessList[$i][0] & "; " & $aProcessList[$i][1])
   Next

   $GUI_OutputLog = GUICtrlCreateEdit($gLog, $x + $groupWidth + 20, $y, $GUI_Width - $groupWidth - 30, $GUI_Height - $y - 10, BitOR($ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY))

   $y += 30

   GUICtrlCreateGroup("Status", $x, $y, $groupWidth, $groupHeight)

   $y += 15
   GUICtrlCreateLabel("Bot:", $x + $groupItemOffset, $y, 40, 17)
   $GUI_BotStatus = GUICtrlCreateLabel($gBotStatus, $x + 50, $y, 100, 17)

   $y += $groupHeight
   GUICtrlCreateGroup("Options", $x, $y, $groupWidth, $groupHeight)

   $y += 15
   $GUI_AutoTeleportCheckbox = GUICtrlCreateCheckbox("Auto Teleport", $x + $groupItemOffset, $y, 185, 25)

   $y += $groupHeight

   $GUI_StartStopButton = GUICtrlCreateButton($gRun ? "Stop" : "Start", $x, $y, $groupWidth, 30)

   $y += 100

   GUICtrlCreateLabel("Version " & FileGetVersion(@AutoItExe), $x, $y, $groupWidth, 17, $SS_CENTER)



   ; Sets the callback function for when user selects a process
   GUICtrlSetOnEvent($GUI_ProcessList, "GUISelectProcess")

   ; Sets the callback function for when user toggles auto quest
   GUICtrlSetOnEvent($GUI_StartStopButton, "GUIToggleAutoQuest")

   ; Set callback function for when user exits the application
   GUISetOnEvent($GUI_EVENT_CLOSE, "GUICloseButton")

   ; Shows the GUI
   ; This code should always be the last line after generating the GUI
   GUISetState(@SW_SHOW)
EndFunc


Func UpdateGUI()
   ; Update the Bot Status
   GUICtrlSetData($GUI_BotStatus, $gBotStatus)

   ; Update the Start/Stop button
   GUICtrlSetData($GUI_StartStopButton, $gRun ? "Stop" : "Start")

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

   If $gRun = False Then
	  $gBotStatus = "Inactive"
   EndIf

   Return $gRun
EndFunc

Func IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc