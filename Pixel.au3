#include <GDIPlus.au3>

;===================================================================================================================================
;
; Description:      Gets the Color Value from a Pixel (possible in background windows [not hidden!])
; Syntax:           GetColor()
; Parameter(s):
;                   $iX - X Coordinate (In the Window, not whole Screen), get it by using the Autoit Window Info tool!
;                   $iY - Y Coordinate (In the Window, not whole Screen), get it by using the Autoit Window Info tool!
;                   $WinHandle - Handle obtained by WinGetHandle
;                   $iWidth - Width of the Window to Capture
;                   $iHeight - Height of the Window to Capture
;
; Return Value(s):  Hex of Color Value
;
; Requirements:
; #RequireAdmin Braucht Adminrechte falls ihr auf ein Programm mit Adminrechten zugreifen wollt!
;#include <WinAPI.au3>
;#include <WindowsConstants.au3>
;#include <GDIPlus.au3>
;#include <ScreenCapture.au3>
; #include <Array.au3>
;
; Note: Does NOT work on hidden or minimized windows as Windows stops rendering them.
;       If you do not want to put in the $WinHandle all the time, replace the $WinHandle Parameter
;       with $WinHandle = $hwnd (if $hwnd is your Handle obtained by WinGetHandle)
;
;       Tested only on Windows 10 Professional 64 Bit
;
;===================================================================================================================================

Func GetColor($iX,$iY,$WinHandle)

    _GDIPlus_Startup()

    Local $aPos = WinGetPos($WinHandle)
    $iWidth = $aPos[2]
    $iHeight = $aPos[3]
    Local $hDDC = _WinAPI_GetDC($WinHandle)
    Local $hCDC = _WinAPI_CreateCompatibleDC($hDDC)

    $hBMP = _WinAPI_CreateCompatibleBitmap($hDDC, $iWidth, $iHeight)


    _WinAPI_SelectObject($hCDC, $hBMP)
    DllCall("User32.dll", "int", "PrintWindow", "hwnd", $WinHandle, "hwnd", $hCDC, "int", 0)
    _WinAPI_BitBlt($hCDC, 0, 0, $iWidth, $iHeight, $hDDC, 0, 0, $__SCREENCAPTURECONSTANT_SRCCOPY)


     $BMP = _GDIPlus_BitmapCreateFromHBITMAP($hBMP)
     Local $aPixelColor = _GDIPlus_BitmapGetPixel($BMP, $iX, $iY)

    _WinAPI_ReleaseDC($WinHandle, $hDDC)
    _WinAPI_DeleteDC($hCDC)
    _WinAPI_DeleteObject($hBMP)
   _GDIPlus_ImageDispose($BMP)
    _GDIPlus_Shutdown()

    Return Hex($aPixelColor, 6)
EndFunc   ;==>GetColor