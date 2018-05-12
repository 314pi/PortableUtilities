#cs

    Xenon File Manager - Open source, portable file manager
    Copyright (C) 2007-2008 www.mi3soft.info
	
	Licensed under the Ms-PL.


#ce

Func Pad($dir)
	Local $lastChar = StringRight($dir, 1);
	If  $lastChar <> '/' And $lastChar <> '\' Then
		Return $dir & '\';
	EndIf
	Return $dir;
EndFunc

Func Depad($dir)
	If StringInStr("\/", StringRight($dir, 1)) Then Return StringTrimRight($dir, 1);
	Return $dir;
EndFunc

;Func IsDir($dir)
;	Return StringInStr(FileGetAttrib($dir), "D");
;EndFunc

Func Larger($n1, $n2)
	If $n1 > $n2 Then Return $n1;
	Return $n2;
EndFunc

Func DirName($adir)
	Local $dir = Depad($adir);
	Local $drive, $folder, $fileName, $ext;
	_PathSplit($dir, $drive, $folder, $fileName, $ext);
	Local $ret = $fileName & $ext;
	If $ret = "" Then $ret = $drive;
	Return $ret;
EndFunc

Func TimeFormat(ByRef $arr)
	If Not IsArray($arr) Then Return "";
	Return StringFormat("%s-%s-%s %s:%s:%s", $arr[0], $arr[1], $arr[2], $arr[3], $arr[4], $arr[5]);
EndFunc

Func AddImageToMenu($ParentMenu, $IndexType, $MenuIndex, $BitmapMenu)

#cs
    $hBmpMenu = DllCall("user32.dll", "hwnd", "LoadImage", "hwnd", 0, _
                                                           "str", $BitmapMenu, _
                                                           "int", $IMAGE_BITMAP, _
                                                           "int", 0, _
                                                           "int", 0, _
                                                           "int", BitOR($LR_LOADFROMFILE, $LR_LOADMAP3DCOLORS))
    $hBmpMenu = $hBmpMenu[0]
    DllCall("user32.dll", "int", "SetMenuItemBitmaps", "hwnd", GUICtrlGetHandle($ParentMenu), _
                                                       "int",  $MenuIndex, _
                                                       "int",  $IndexType, _
                                                       "hwnd", $hBmpMenu, _
                                                       "hwnd", $hBmpMenu)
#ce
	
	Local $hBmpMenu = _WinAPI_LoadImage(0, $BitmapMenu, $IMAGE_BITMAP, 0, 0, BitOR($LR_LOADFROMFILE, $LR_LOADMAP3DCOLORS));
	;_GUICtrlMenu_SetItemBitmaps(GUICtrlGetHandle($ParentMenu), $MenuIndex, $hBmpMenu, $hBmpMenu, True);
	DllCall("user32.dll", "int", "SetMenuItemBitmaps", "hwnd", GUICtrlGetHandle($ParentMenu), _
                                                       "int",  $MenuIndex, _
                                                       "int",  $IndexType, _
                                                       "hwnd", $hBmpMenu, _
                                                       "hwnd", $hBmpMenu)
EndFunc

Func _StrReplaceUnsupported($String, $Patern='[*?\\/|:<>"]', $Replace="_")
    If StringLen($String) = 0 Then Return $String
    $rString = StringRegExpReplace($String, $Patern, $Replace)
	If $rString == $String Then Return $String;
    $rString = StringRegExpReplace($rString, '(' & $Replace & '+)', $Replace)
    Return $rString
EndFunc

Func _OpenWeb($url)
	Local $exe = IniRead($DATA_DIR & "\assoc.ini", "html", "exe", "")
	If $exe == "" Then $exe = "iexplore.exe";
	ShellExecute($exe, """" & StringReplace($url, """", """""") & """");
EndFunc

Func _TreeViewItem_GetFullPath($item)
	Local $path = "";
	Local $curr = $item;
	While $item <> 0
		$path = _GUICtrlTreeView_GetText($treeView, $item) & "\" & $path;
		$item = _GUICtrlTreeView_GetParentHandle($treeView, $item);
	WEnd
	Return $path;
EndFunc

Func FileHasIcons($file)
	Return _WinAPI_ExtractIconEx($file, -1, 0, 0, 0) <> 0;
EndFunc

Func AdjustFileSize($size)
	$size = $size / 1024;
	If $size > 1024 Then
		$size = $size / 1024;
		If $size > 1024 Then
			$size = Round($size / 1024, 2) & " GB";
		Else
			$size = Round($size, 2) & " MB";
		EndIf
	Else
		$size = Round($size, 2) & " KB";
	EndIf
	Return $size;
EndFunc

Func ConvertViewFormat($style, $fromUdf = True)
	If $fromUdf Then
		Switch $style
			Case 1 ; Large Icon
				Return $LVS_ICON;
				
			Case 3 ; Small Icon
				Return $LVS_SMALLICON;
				
			Case Else ; Details
				Return $LVS_REPORT;
		EndSwitch
	Else
		Switch $style
			Case $LVS_ICON
				Return 1;
				
			Case $LVS_SMALLICON
				Return 3;
				
			Case Else
				Return 0;
		EndSwitch
	EndIf
EndFunc

;~ Func MoveTab($origin, $dst)
;~ 	_GUICtrlTab_InsertItem($tabset, $dst, DirName($folder));
;~ 	
;~ 	_ArrayInsert($histories, $dst + 1, $history);
;~ 	_ArrayInsert($forwards, $dst + 1, $forward);
;~ 	_ArrayInsert($dirs, $dst + 1, $dir);
;~ 	
;~ 	If $origin <> _GUICtrlTab_GetCurSel($tabset) Then
;~ 		_GUICtrlTab_SetCurSel($tabset, $origin);
;~ 		SelectTab();
;~ 	EndIf
;~ 	CloseTab();
;~ 	
;~ 	_GUICtrlTab_SetCurSel($tabset, $dst);
;~ 	SelectTab();
;~ EndFunc

Func SetXeDisablePrompt()
	If $SETTINGS_PromptOnDelete Then
		EnvSet("XeDisablePrompt", "0");
	Else
		EnvSet("XeDisablePrompt", "1");
	EndIf
EndFunc