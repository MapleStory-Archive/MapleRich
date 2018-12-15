#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include-once
#include <FastFind.au3>
#include <WinAPI.au3>
#include <WinAPIFiles.au3>


Global $gOcrSnapShotNum = 1023

Global $gOcrTmpDir = "tmp"

Global $gTesseractPath = @ProgramFilesDir & "\Tesseract-OCR\tesseract.exe"

;Global $gTesseractPath =  "lib\tesseract\tesseract.exe"


Func OCR_SetTmpDir($dir)
   $gOcrTmpDir = $dir
EndFunc


Func OCR_GetTextFromWindow($name, $left = 0, $top = 0, $right = 0, $bottom = 0, $hWnd = Null)
   $fullCaptureFileName = $gOcrTmpDir & "/" & $name & ".bmp"
   $fullOCRFileName = $gOcrTmpDir & "/" & $name & ".txt"

   $savedResult = FFSaveBMP($gOcrTmpDir & "/" & $name, True, $left, $top, $right, $bottom, $gOcrSnapShotNum, $hWnd)

   ShellExecuteWait($gTesseractPath, $fullCaptureFileName & " " & $gOcrTmpDir & "/" & $name, "", "", @SW_HIDE)

   $ocr = FileRead($fullOCRFileName)

   ; Clean up
   FileDelete($fullCaptureFileName)
   FileDelete($fullOCRFileName)

   Return $ocr
EndFunc
