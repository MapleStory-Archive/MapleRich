#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

Global $programTitle = "MapleRich"
Global $gVersion = "0.2"

Global $gDebug = true

Global $gRun = false

Global $gBotStatus = "Inactive"

Global $gLog = ""

Global $gNoxIsRunning = false
Global $gNoxHwnd
Global $gNoxTitle

Global $COLOR_ORANGE = 0xFF7B50
Global $COLOR_TEAL = 0x59B0A8
Global $COLOR_WHITE = 0xFFFFFF
Global $COLOR_AUTOQUESTING = 0xFAEEB5
Global $COLOR_BLACK_DIALOG_OVERLAY = 0x808080
Global $COLOR_BLACK_DIALOG_IN_MENU_OVERLAY = 0x293037
Global $COLOR_BLACK_REWARD_OVERLAY = 0x484848
Global $COLOR_BLACK_REWARD_IN_MENU_OVERLAY = 0x171B1F
Global $COLOR_MENU_HEADER = 0x515F6E