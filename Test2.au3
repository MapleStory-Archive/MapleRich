#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#AutoIt3Wrapper_UseX64=y

#include-once
;~ #include <ImageSearch.au3>
;~ #include <ImageSearch2015.au3>
#include <BmpSearch.au3>
#include <ScreenCapture.au3>

Local $x

Local $y

Global $hWnd = WinGetHandle("NoxPlayer2")

ConsoleWrite($hWnd & @CRLF)

_GDIPlus_Startup()


$result = findBMP($hWnd, "images\msm-icon.bmp", True)

_GDIPlus_Shutdown()

ConsoleWrite($result)



;~ $result = _ImageSearch(@ScriptDir & "\images\msm-icon.png", 1, $x, $y, 50)

;~ $result = _ImageSearchWindow($hWnd, @ScriptDir & "\images\msm-icon.png", 1, 50)

;~ ConsoleWrite("Result: " & $result & @CRLF)

;~ ConsoleWrite($result & @CRLF)

;~ ConsoleWrite($x & " " & $y & @CRLF)
;~ MouseMove($x, $y)

