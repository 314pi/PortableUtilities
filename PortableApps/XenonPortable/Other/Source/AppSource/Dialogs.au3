#cs

    Xenon File Manager - Open source, portable file manager
    Copyright (C) 2007-2008 www.mi3soft.info
	
	Xenon File Manager is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
	
	One Exeception:
		Small snippets of code may be used from Xenon withouth subjecting
		your code to the GNU Lesser General Public License if
			a) The code borrowed does not include more than four (4) functions.
			and
			b) The application that this code will be used in is not a file browser.
	
#ce

Func _MsgBox($flag=0, $title="", $text="", $parent="")
    DllCall("user32.dll", _        ; dll mother
            "int", "MessageBox", _ ; dll function
            "hwnd", $parent, _     ; maingui to bind msgbox to (if any)
            "str", $text , _       ; msgbox text
            "str", $title, _       ; msgbox title
            "int", $flag)          ; msgbox type
EndFunc

Func _FileOpenDialog($sTitle, $sInitDir, $sFilter = "All (*.*)", $iOpt = 0, $sDefaultFile = "", $sDefaultExt = "", $hWnd = 0)
    ; API flags prepare
    Local $iFlag = BitOR( _
    BitShift(BitAND($iOpt, 1), -12), _
    BitShift(BitAND($iOpt, 2), -10), _
    BitShift(BitAND($iOpt, 4), -7 ), _
    BitShift(BitAND($iOpt, 8), -10), _
    BitShift(BitAND($iOpt, 4), -17) _
    )

    ; Call API function
    Local $usPath = __FileOSDialogHelper("GetOpenFileName", $iFlag, $sTitle, $sInitDir, $sFilter, $iOpt, $sDefaultFile, $sDefaultExt, $hWnd)

    If Not @error Then
    If BitAND($iOpt, 4) Then
    $i = 1
    While 1
    If DllStructGetData($usPath, 1, $i) = 0 Then
    If DllStructGetData($usPath, 1, $i+1) Then
    DllStructSetData($usPath, 1, 124, $i)
    Else
    ExitLoop
    EndIf
    EndIf
    $i += 1
    Wend
    EndIf
    Return DllStructGetData($usPath, 1)
    EndIf
    Return SetError(1, 0, "")
EndFunc

;-------------------------------------------------------------------------------
; File Open/Save Dialog Helper Function (originally written by amel27)
;-------------------------------------------------------------------------------
Func __FileOSDialogHelper($sFunction, $iFlag, $sTitle, $sInitDir, $sFilter, $iOpt, $sDefaultFile, $sDefaultExt, $hWnd)
    Local $iPathLen = 256 ; Max chars in returned string

    ; Filter string to array conversion
    Local $asFLines = StringSplit($sFilter, "|"), $asFilter[$asFLines[0]*2+1]
    Local $i, $iStart, $iFinal, $suFilter
    $asFilter[0] = $asFLines[0]*2
    For $i = 1 To $asFLines[0]
    $iStart = StringInStr($asFLines[$i], "(", 0, 1)
    $iFinal = StringInStr($asFLines[$i], ")", 0,-1)
    $asFilter[$i*2-1] = StringStripWS(StringLeft($asFLines[$i], $iStart-1), 3)
    $asFilter[$i*2] = StringStripWS(StringTrimRight(StringTrimLeft($asFLines[$i], $iStart), StringLen($asFLines[$i]) -$iFinal+1), 3)
    $suFilter &= "char[" & StringLen($asFilter[$i*2-1])+1 & "];char[" & StringLen($asFilter[$i*2])+1 & "];"
    Next

    ; Create API structures
    Local $uOFN = DllStructCreate("dword;int;int;ptr;ptr;dword;dword;ptr;dword;ptr;int;ptr;ptr;dword;short;short;ptr;ptr;ptr;ptr;ptr;dword;dword")
    Local $usTitle = DllStructCreate("char[" & StringLen($sTitle)+1 & "]")
    Local $usInitDir = DllStructCreate("char[" & StringLen($sInitDir)+1 & "]")
    Local $usFilter = DllStructCreate($suFilter & "char")
    Local $usPath = DllStructCreate("char[" & $iPathLen & "]")
    Local $usExtn = DllStructCreate("charchar[" & StringLen($sDefaultExt)+1 & "]")
    For $i=1 To $asFilter[0]
    DllStructSetData($usFilter, $i, $asFilter[$i])
    Next

    ; Set Data of API structures
    DllStructSetData($usTitle, 1, $sTitle)
    DllStructSetData($usInitDir, 1, $sInitDir)
    DllStructSetData($usPath, 1, $sDefaultFile)
    DllStructSetData($usExtn, 1, $sDefaultExt)
    DllStructSetData($uOFN, 1, DllStructGetSize($uOFN))
    DllStructSetData($uOFN, 2, $hWnd)
    DllStructSetData($uOFN, 4, DllStructGetPtr($usFilter))
    DllStructSetData($uOFN, 7, 1)
    DllStructSetData($uOFN, 8, DllStructGetPtr($usPath))
    DllStructSetData($uOFN, 9, $iPathLen)
    DllStructSetData($uOFN, 12, DllStructGetPtr($usInitDir))
    DllStructSetData($uOFN, 13, DllStructGetPtr($usTitle))
    DllStructSetData($uOFN, 14, BitOR($iFlag, 4))
    DllStructSetData($uOFN, 17, DllStructGetPtr($usExtn))
    DllStructSetData($uOFN, 23, BitShift(BitAND($iOpt, 32), 5))

    ; Call API function
    Local $aiCall = DllCall("comdlg32.dll", "int", $sFunction, "ptr", DllStructGetPtr($uOFN))

    If $aiCall[0] Then Return $usPath
    Return SetError(1, 0, "")
EndFunc