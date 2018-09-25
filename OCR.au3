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


Func OCR_SetTmpDir($dir)
   $gOcrTmpDir = $dir
EndFunc


Func OCR_GetTextFromWindow($left = 0, $top = 0, $right = 0, $bottom = 0, $hWnd = Null)
   $captureFileNameNoExt = "ocrtmp"
   $ocrFileNameNoExt = "ocr_result"

   $fullCaptureFileName = $gOcrTmpDir & "/" & $captureFileNameNoExt & ".bmp"
   $fullOCRFileName = $gOcrTmpDir & "/" & $ocrFileNameNoExt & ".txt"

   $savedResult = FFSaveBMP($gOcrTmpDir & "/" & $captureFileNameNoExt, True, $left, $top, $right, $bottom, $gOcrSnapShotNum, $hWnd)

   ShellExecuteWait($gTesseractPath, $fullCaptureFileName & " " & $gOcrTmpDir & "/" & $ocrFileNameNoExt, "", "", @SW_HIDE)

   $ocr = FileRead($fullOCRFileName)

   ; Clean up
   FileDelete($fullCaptureFileName)

   Return $ocr
EndFunc
