#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include-once
#include <Globals.au3>

Func UpdateProcessList()
   Local $finalProcessList

   Local $aProcessList = ProcessList("Nox.exe")

   For $i = 1 To $aProcessList[0][0]
	  ConsoleLog("PID: " & $aProcessList[$i][1] & " " & $aProcessList[$i][0])
   Next

EndFunc
