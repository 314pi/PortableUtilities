#cs

    Xenon File Manager - Open source, portable file manager
    Copyright (C) 2007-2008 www.mi3soft.info
	
	Licensed under the Ms-PL.


#ce

Func WM_NOTIFY($hWndGUI, $MsgID, $wParam, $lParam)
    #forceref $hWndGUI, $MsgID, $wParam
    Local $tNMHDR, $event
    
    If $wParam = GUICtrlGetHandle($listView) And Not $disableTreeViewEvents Then
        $tNMHDR = DllStructCreate("int;int;int", $lParam)
        If @error Then Return
        $event = DllStructGetData($tNMHDR, 3)
        
		If $event = $NM_DBLCLK Then
			$msgLvDblClk = True;
		EndIf
	EndIf
		
	If $wParam = $treeView And Not $disableTreeViewEvents Then
		$tNMHDR = DllStructCreate("int;int;int", $lParam)
        If @error Then Return
        $event = DllStructGetData($tNMHDR, 3)
		
		If $event = $TVN_SELCHANGED Or $event = $TVN_SELCHANGEDW Then
			Local $item = _GUICtrlTreeView_GetSelection($treeView);
			If $item <> 0 Then
				Local $path = _TreeViewItem_GetFullPath($item)
				If $path <> "" Then
					$path = Pad(_PathFull($path));
					If $path <> $dir Then
						$msgTvClkAddToHistory = True;
						$msgTvClk = $path;
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	
	$tNMHDR = DllStructCreate($tagNMHDR, $lParam);
	$event = DllStructGetData($tNMHDR, "Code");
	If DllStructGetData($tNMHDR, "hWndFrom") = $tabset Then
		If $event = $TCN_SELCHANGE Then
			SelectTab();
;~ 		ElseIf $event = $NM_CLICK Then
;~ 			Local $oldOpt = Opt("MouseCoordMode", 2);
;~ 			Local $tabsetSize = ControlGetPos($window, "", $tabset);
;~ 			Local $hittest = _GUICtrlTab_HitTest($tabset, MouseGetPos(0) - $tabsetSize[0], MouseGetPos(1) - $tabsetSize[1]);
;~ 			If IsArray($hittest) Then
;~ 				If $hittest[0] <> -1 And $hittest[1] = 2 Then
;~ 					_GUICtrlTab_SetCurSel($tabset, $hittest[0]);
;~ 					SelectTab();
;~ 					CloseTab();
;~ 				EndIf
;~ 			EndIf
;~ 			Opt("MouseCoordMode", $oldOpt);
		EndIf
	EndIf
EndFunc

Func WM_CONTEXTMENU($hwnd, $msg, $wParam, $lParam)
	
	If $wParam = $tabset Then
		Local $menu = _GUICtrlMenu_CreatePopup();
		_GUICtrlMenu_InsertMenuItem($menu, 0, $LANG_DUPLICATETAB, 1);
		_GUICtrlMenu_InsertMenuItem($menu, 1, $LANG_CLOSETAB & @TAB & "Ctrl+F4", 2);
		Switch _GUICtrlMenu_TrackPopupMenu($menu, $wParam, MouseGetPos(0) + 1, MouseGetPos(1) + 1, 1, 1, 3)
			
			Case 1
				; Duplicate Tab
				AddTab($dir);
			
			Case 2
				; Close Tab
				
				CloseTab();
			
		EndSwitch
		Return True;
		
	ElseIf $wParam = GUICtrlGetHandle($treeView) Then
		
		$disableTreeViewEvents = True;
		
		Local $tvSize = ControlGetPos($window, "", $treeView);
		Local $crdOpt = Opt("MouseCoordMode", 2);
		Local $hittest = _GUICtrlTreeView_HitTestItem($treeView, MouseGetPos(0) - $tvSize[0], MouseGetPos(1) - $tvSize[1]);
		Opt("MouseCoordMode", $crdOpt);
		
		If $hittest = 0 Then
			$disableTreeViewEvents = False;
			Return False;
		EndIf
		
		Local $menu = _GUICtrlMenu_CreatePopup();
		_GUICtrlMenu_AddMenuItem($menu, $LANG_OPEN, 1);
		_GUICtrlMenu_AddMenuItem($menu, $LANG_START, 2);
		_GUICtrlMenu_AddMenuItem($menu, "");
		_GUICtrlMenu_AddMenuItem($menu, $LANG_COPY, 3);
		_GUICtrlMenu_AddMenuItem($menu, $LANG_CUT, 4);
		_GUICtrlMenu_AddMenuItem($menu, $LANG_PASTE, 5);
		_GUICtrlMenu_AddMenuItem($menu, $LANG_DELETE, 6)
		Switch _GUICtrlMenu_TrackPopupMenu($menu, $wParam, -1, -1, 1, 1, 3)
			
			Case 1
				LoadDir(_TreeViewItem_GetFullPath($hittest));
				
			Case 2
				AddTab(_TreeViewItem_GetFullPath($hittest));
				
			Case 3
				ClipPut(_TreeViewItem_GetFullPath($hittest));
				$cutting = 0;
				
			Case 4
				Local $path = _TreeViewItem_GetFullPath($hittest);
				ClipPut($path);
				$cutting = $path;
				
			Case 5
				Paste2($hittest);
				
			Case 6
				SetXeDisablePrompt();
				ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & @ScriptDir & "\Shell.a3x"" /Delete """ & _TreeViewItem_GetFullPath($hittest) & """")
			
		EndSwitch
		$disableTreeViewEvents = False;
		Return True;
		
	EndIf
	
	
EndFunc

Func WM_DROPFILES($hWnd, $msgID, $wParam, $lParam)
	If $hWnd <> $window Then Return 0;
	
    Local $nSize, $pFileName
    Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
    For $i = 0 To $nAmt[0] - 1
        $nSize = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
        $nSize = $nSize[0] + 1
        $pFileName = DllStructCreate("char[" & $nSize & "]")
        DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", DllStructGetPtr($pFileName), "int", $nSize)
        ReDim $gaDropFiles[$i + 1]
        $gaDropFiles[$i] = DllStructGetData($pFileName, 1)
        $pFileName = 0
    Next
EndFunc

Func WM_GETMINMAXINFO($hWnd, $MsgID, $wParam, $lParam)
	#forceref $MsgID, $wParam
	If $hWnd = $window Then
		Local $minmaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)
		DllStructSetData($minmaxinfo, 7, 515); min width
		DllStructSetData($minmaxinfo, 8, 400); min height
		Return 0
	Else
		Return 0
	EndIf
EndFunc

Func WM_ACTIVATEAPP($hWnd, $msgID, $wParam, $lParam)
	If WinActive($window) Then
		EnableHotkeys();
	Else
		DisableHotkeys();
	EndIf
	Return 0;
EndFunc