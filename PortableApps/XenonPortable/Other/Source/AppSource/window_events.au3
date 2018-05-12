#cs

    Xenon File Manager - Open source, portable file manager
    Copyright (C) 2007-2008 www.mi3soft.info
	
	Licensed under the Ms-PL.


#ce

Func window_Close()
	DllClose($user32);
	
	
	If Int(IniRead($DATA_DIR & "\settings.ini", "Xenon", "ShowHiddenFiles", "JLKJKLFDLKJKLDFS")) <> $SETTINGS_ShowHiddenFiles Or @error Then
		IniWrite($DATA_DIR & "\settings.ini", "Xenon", "ShowHiddenFiles", $SETTINGS_ShowHiddenFiles);
	EndIf
	
	If Int(IniRead($DATA_DIR & "\settings.ini", "Xenon", "GetFolderSizes", "JLKJKLFDLKJKLDFS")) <> $SETTINGS_GetFolderSizes Or @error Then
		IniWrite($DATA_DIR & "\settings.ini", "Xenon", "GetFolderSizes", $SETTINGS_GetFolderSizes);
	EndIf
	
	Local $i;
	For $i = 1 To UBound($languageMenuItems) - 1
		If BitAND(GUICtrlRead($languageMenuItems[$i]), $GUI_CHECKED) = $GUI_CHECKED Then
			If IniRead($DATA_DIR & "\settings.ini", "Xenon", "language", "RTYUJIK") <> $languageFileNames[$i] Then
				IniWrite($DATA_DIR & "\settings.ini", "Xenon", "language", $languageFileNames[$i]);
			EndIf
			ExitLoop;
		EndIf
	Next
	
	If Int(IniRead($DATA_DIR & "\settings.ini", "Xenon", "ViewStyle", "RTYUIOVJHB")) <> $SETTINGS_ViewStyle Or @error Then
		IniWrite($DATA_DIR & "\settings.ini", "Xenon", "ViewStyle", $SETTINGS_ViewStyle);
	EndIf
	
	If Int(IniRead($DATA_DIR & "\settings.ini", "Xenon", "ShowTreeView", "TYUIJKML")) <> $SETTINGS_ShowTreeView Or @error Then
		IniWrite($DATA_DIR & "\settings.ini", "Xenon", "ShowTreeView", $SETTINGS_ShowTreeView);
	EndIf
	
	If Int(IniRead($DATA_DIR & "\settings.ini", "Xenon", "ShowDDItem", "UKLEJMEEF")) <> $SETTINGS_ShowDDItem Or @error Then
		IniWrite($DATA_DIR & "\settings.ini", "Xenon", "ShowDDItem", $SETTINGS_ShowDDItem);
	EndIf
	
	If IniRead($DATA_DIR & "\settings.ini", "Xenon", "IconSet", "sdfjkdflsklfdkljsdfkljdsfljkdsfklj") <> $SETTINGS_IconSet Then
		IniWrite($DATA_DIR & "\settings.ini", "Xenon", "IconSet", $SETTINGS_IconSet);
	EndIf
	
	If IniRead($DATA_DIR & "\settings.ini", "Xenon", "Homepage", "HUEJKFKLKLJFDJKLKLJDFSKLJDSFKLJSDFLJK") <> $SETTINGS_Homepage Then
		IniWrite($DATA_DIR & "\settings.ini", "Xenon", "Homepage", $SETTINGS_Homepage);
	EndIf
	
	If IniRead($DATA_DIR & "\settings.ini", "Xenon", "PromptOnDelete", "ERFJKLDFGHJKL:FGHJKL:VB)") <> $SETTINGS_PromptOnDelete Then
		IniWrite($DATA_DIR & "\settings.ini", "Xenon", "PromptOnDelete", $SETTINGS_PromptOnDelete);
	EndIf
	
	Local $hasEditedBookmarks = False;
	Local $i;
	For $i = 1 To UBound($SETTINGS_Bookmarks) - 1
		If IniRead($DATA_DIR & "\settings.ini", "Bookmarks", $i, "ERTYJKBKJKJHHHKJJHDKSHFJDSKJHJDFKJDFSHJDSFJKKDF") <> $SETTINGS_Bookmarks[$i][0] Or _
			IniRead($DATA_DIR & "\settings.ini", "Bookmarks", "cap" & $i, "ERTYJKBKJKJHHHKJJHDKSHFJDSKJHJDFKJDFSHJDSFJKKDF") <> $SETTINGS_Bookmarks[$i][1] Then
			$hasEditedBookmarks = True;
			ExitLoop;
		EndIf
	Next
	If Not $hasEditedBookmarks And IniRead($DATA_DIR & "\settings.ini", "Bookmarks", _
		UBound($SETTINGS_Bookmarks), "CVBNM<^|") <> "CVBNM<^|" Then $hasEditedBookmarks = True;
	
	If $hasEditedBookmarks Then
		Dim $currDrive = DriveOf(@ScriptDir);
		Local $i;
		For $i = 1 To UBound($SETTINGS_Bookmarks) - 1
			IniWrite($DATA_DIR & "\settings.ini", "Bookmarks", $i, StringReplace($SETTINGS_Bookmarks[$i][0], $currDrive, "?:"));
			IniWrite($DATA_DIR & "\settings.ini", "Bookmarks", "cap" & $i, $SETTINGS_Bookmarks[$i][1]);
		Next
		
		$i = UBound($SETTINGS_Bookmarks);
		While True
			If IniRead($DATA_DIR & "\settings.ini", "Bookmarks", $i, "CVBNM<^|") == "CVBNM<^|" Then ExitLoop;
			IniDelete($DATA_DIR & "\settings.ini", "Bookmarks", $i);
			IniDelete($DATA_DIR & "\settings.ini", "Bookmarks", "cap" & $i);
			$i += 1;
		WEnd
	EndIf
	Exit(0);
EndFunc

Func window_Click()
	Local $Info =  GUIGetCursorInfo($window)
	
;~ 	Local $oldOpt = Opt("MouseCoordMode", 2);
;~ 	Local $tabsetSize = ControlGetPos($window, "", $tabset);
;~ 	Local $hittest = _GUICtrlTab_HitTest($tabset, MouseGetPos(0) - $tabsetSize[0], MouseGetPos(1) - $tabsetSize[1]);
;~ 	Opt("MouseCoordMode", $oldOpt);
	
    If $Info[4] = $listView Then;if it was over the listview
        If _IsPressed(1) Then;if the left mouse button pressed(must be really or how did we get here)
            Local $noSel = _GUICtrlListView_GetSelectedCount($listView);the number of selected items being dragged
            If $noSel < 1 Then Return
            Local $SelItems = _GUICtrlListView_GetSelectedIndices($listView, 1);the list of the items 
			
			Local $lastItemInfo = -1;
            While _IsPressed(0x01, $user32)
            WEnd
            
			;where is the cursor now?
            $Info =  GUIGetCursorInfo($window)
			
			Local $oldOpt = Opt("MouseCoordMode", 2);
			Local $tabsetSize = ControlGetPos($window, "", $tabset);
			Local $hittest = _GUICtrlTab_HitTest($tabset, MouseGetPos(0) - $tabsetSize[0], MouseGetPos(1) - $tabsetSize[1]);
			Opt("MouseCoordMode", $oldOpt);
			
            If $Info[4] = $listView Then;if it's still over the listview
                MouseClick("primary");click to select the target item
                Local $ToItem = _GUICtrlListView_GetSelectedIndices($listView);
                Local $ToItemText = _GUICtrlListView_GetItemText($listView, Int($ToItem));
				
				
				If $ToItem <> $LV_ERR And IsDir($dir & $ToItemText) Then
					
					Local $str = "";
					
					Local $i;
					For $i = 1 To $SelItems[0]
						Local $CurrentSelItemText = _GUICtrlListView_GetItemText($listView, $SelItems[$i]);
						
						If $CurrentSelItemText == ".." Then
							ContinueLoop;
						EndIf
						
						;ConsoleWrite(_PathFull($dir & $ToItemText) & " = " & _PathFull($dir) & @CRLF & _PathFull($dir & $ToItemText) & " = " & _PathFull($dir & $CurrentSelItemText) & @CRLF);
						;ConsoleWrite(_GUICtrlListView_GetItemText($listView, 15, 1) & @CRLF);
						If _PathFull($dir & $ToItemText) = _PathFull($dir) Or _PathFull($dir & $ToItemText) = _PathFull($dir & $CurrentSelItemText) Then ContinueLoop;
						;ConsoleWrite("Hey" & @CRLF);
						
						If FileExists($dir & $CurrentSelItemText) And FileExists($dir & $ToItemText) Then
							$str &= " """ & $dir & $CurrentSelItemText & """ """ & $dir & $ToItemText & "\" & $CurrentSelItemText & """";
						EndIf
					Next
					
					If $str <> "" Then
						SetXeDisablePrompt();
						ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & @ScriptDir & "\Shell.a3x"" /move " & $str);
					EndIf
					
				EndIf
                
			ElseIf $Info[4] = $treeView Then
				Local $tvSize = ControlGetPos($window, "", $treeView);
				Local $crdOpt = Opt("MouseCoordMode", 2);
				Local $hittest = _GUICtrlTreeView_HitTestItem($treeView, MouseGetPos(0) - $tvSize[0], MouseGetPos(1) - $tvSize[1]);
				Opt("MouseCoordMode", $crdOpt);
				
				Local $fullPath = _TreeViewItem_GetFullPath($hittest);
				If IsDir($fullPath) Then
					
					Local $str;
					
					Local $i;
					For $i = 1 To $SelItems[0]
						Local $CurrentSelItemText = _GUICtrlListView_GetItemText($listView, $SelItems[$i]);
						
						If $CurrentSelItemText == ".." Then
							ContinueLoop;
						EndIf
						
						If _PathFull($dir) = _PathFull($fullPath) Or _PathFull($dir & $CurrentSelItemText) = _PathFull($fullPath) Then ContinueLoop;
						
						$str &= " """ & $dir & $CurrentSelItemText & """ """ & $fullPath & "\" & $CurrentSelItemText & """";
					Next
					
					SetXeDisablePrompt();
					If $str <> "" Then ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & @ScriptDir & "\Shell.a3x"" /move" & $str);
				
				EndIf
			ElseIf $hittest[0] <> -1 Then
				Local $fullPath = $dirs[$hittest[0] + 1];
				If IsDir($fullPath) Then
					
					Local $str;
					
					Local $i;
					For $i = 1 To $SelItems[0]
						Local $CurrentSelItemText = _GUICtrlListView_GetItemText($listView, $SelItems[$i]);
						
						If $CurrentSelItemText == ".." Then
							ContinueLoop;
						EndIf
						
						If _PathFull($dir) = _PathFull($fullPath) Or _PathFull($dir & $CurrentSelItemText) = _PathFull($fullPath) Then ContinueLoop;
						
						$str &= " """ & $dir & $CurrentSelItemText & """ """ & $fullPath & "\" & $CurrentSelItemText & """";
					Next
					
					SetXeDisablePrompt();
					If $str <> "" Then ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & @ScriptDir & "\Shell.a3x"" /move" & $str);
				EndIf
            EndIf
        EndIf
	ElseIf $Info[4] = $treeView Then
		If _IsPressed(0x01) Then
			Local $tvSize = ControlGetPos($window, "", $treeView);
			Local $crdOpt = Opt("MouseCoordMode", 2);
			Local $hittest = _GUICtrlTreeView_HitTestItem($treeView, MouseGetPos(0) - $tvSize[0], MouseGetPos(1) - $tvSize[1]);
			Opt("MouseCoordMode", $crdOpt);
			
			While _IsPressed(1, $user32)
			WEnd
			
			$Info = GUIGetCursorInfo($window);
			If $Info[4] = $treeView Then
				Local $crdOpt = Opt("MouseCoordMode", 2);
				Local $hittest2 = _GUICtrlTreeView_HitTestItem($treeView, MouseGetPos(0) - $tvSize[0], MouseGetPos(1) - $tvSize[1]);
				Opt("MouseCoordMode", $crdOpt);
				
				Local $pathSrc = _PathFull(_TreeViewItem_GetFullPath($hittest));
				Local $pathDst = _PathFull(_TreeViewItem_GetFullPath($hittest2));
				Local $fullPathDst = _PathFull($pathDst & _GUICtrlTreeView_GetText($treeView, $hittest));
				
				If $pathSrc = $pathDst Or $pathSrc = $fullPathDst Then Return;
				
				SetXeDisablePrompt();
				ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & @ScriptDir & "\Shell.a3x"" /move """ & $pathSrc & """ """ & $fullPathDst & """");
				LoadDir($fullPathDst);
				
			ElseIf $Info[4] = $listView Then
				MouseClick("primary");click to select the target item
                Local $ToItem = _GUICtrlListView_GetSelectedIndices($listView)
                Local $ToItemText = _GUICtrlListView_GetItemText($listView, Int($ToItem));
				
				If $ToItem <> $LV_ERR And IsDir($dir & _GUICtrlListView_GetItemText($listView, $ToItem)) Then
					SetXeDisablePrompt();
					ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & @ScriptDir & "\Shell.a3x"" /move """ & _TreeViewItem_GetFullPath($hittest) & """ """ & $dir & $ToItemText & "\" & _GUICtrlTreeView_GetText($treeView, $hittest) & """");
					LoadDir($dir & $ToItemText);
				EndIf
			EndIf
		EndIf
;~ 	ElseIf $hittest[0] <> -1 Then
;~ 		While _IsPressed(1, $user32)
;~ 		WEnd
;~ 		
;~ 		Local $mousePos = MouseGetPos();
;~ 		
;~ 		Local $oldOpt = Opt("MouseCoordMode", 2);
;~ 		Local $tabsetSize = ControlGetPos($window, "", $tabset);
;~ 		Local $hittest2 = _GUICtrlTab_HitTest($tabset, $mousePos[0] - $tabsetSize[0], $mousePos[1] - $tabsetSize[1]);
;~ 		Opt("MouseCoordMode", $oldOpt);
;~ 		
;~ 		If $hittest2[0] <> -1 And $hittest[0] <> $hittest2[0] Then
;~ 			Local $swapTabRect = _GUICtrlTab_GetItemRect($tabset, $hittest2[0]);
;~ 			If ($mousePos[1] - $tabsetSize[1] - $swapTabRect[1]) > (($swapTabRect[3] - $swapTabRect[1]) / 2) Then
;~ 				MoveTab($hittest[0], $hittest2[0] + 1);
;~ 			Else
;~ 				MoveTab($hittest[0], $hittest2[0]);
;~ 			EndIf
;~ 		EndIf
    EndIf
EndFunc

Func window_Resize()
	Local $clientSize = WinGetClientSize($window);
	Local $tvPos = ControlGetPos($window, "", $treeView);
	Local $lvPos = ControlGetPos($window, "", $listView);
	
	If ControlCommand($window, "", $treeView, "IsVisible") Then
		ControlMove($window, "", $treeView, Default, Default, $clientSize[0] * 0.3, $clientSize[1] - $tvPos[1]);
		ControlMove($window, "", $tabset, $clientSize[0] * 0.3 + 2, Default, $clientSize[0] * 0.7 - 1 - 20, 20);
		ControlMove($window, "", $listView, $clientSize[0] * 0.3 + 2, Default, $clientSize[0] * 0.7 - 1, $clientSize[1] - $lvPos[1]);
	Else
 		ControlMove($window, "", $tabset, 0, Default, $clientSize[0] - 20, 20);
 		ControlMove($window, "", $listView, 0, Default, $clientSize[0], $clientSize[1] - $lvPos[1]);
	EndIf
	
EndFunc

Func window_Dropped()
	If $dir = $LANG_COMPUTER Then Return;
	
	If @GUI_DropId = $listView Then
		Local $i;
		For $i = 0 To UBound($gaDropFiles) - 1
			Local $drive, $path, $filename, $ext;
			_PathSplit($gaDropFiles[$i], $drive, $path, $filename, $ext);
			
			If _PathFull($gaDropFiles[$i]) = _PathFull($dir & $filename & $ext) Then
				ContinueLoop;
			EndIf
			
			SetXeDisablePrompt();
 			If $drive = StringLeft($dir, 2) Then
				ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & @ScriptDir & "\Shell.a3x"" /move """ & $gaDropFiles[$i] & """ """ & $dir & $filename & $ext & """", 1);
			Else
				ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & @ScriptDir & "\Shell.a3x"" /copy """ & $gaDropFiles[$i] & """ """ & $dir & $filename & $ext & """", 1);
			EndIf
			
		Next
		
	EndIf
EndFunc

Func window_MouseMove()
	Local $mouseInfo = GUIGetCursorInfo($window)
	Switch $mouseInfo[4]
		Case $backButton, $backButtonHover, $backButtonDis
			IconSelect($backButton);
			
		Case $forwardButton, $forwardButtonHover, $forwardButtonDis
			IconSelect($forwardButton);
			
		Case $upButton, $upButtonHover, $upButtonDis
			IconSelect($upButton);
			
		Case $computerButton, $computerButtonHover
			IconSelect($computerButton);
			
		Case $homeButton, $homeButtonHover
			IconSelect($homeButton);
			
		Case $refreshButton, $refreshButtonHover
			IconSelect($refreshButton);
			
		Case $copyButton, $copyButtonHover
			IconSelect($copyButton);
			
		Case $cutButton, $cutButtonHover
			IconSelect($cutButton);
			
		Case $pasteButton, $pasteButtonHover
			IconSelect($pasteButton);
			
		Case $searchButton, $searchButtonHover
			IconSelect($searchButton);
			
		Case $goButton, $goButtonHover
			IconSelect($goButton);
			
		Case Else
			IconSelect(0);
	EndSwitch
	
EndFunc

Func IconSelect($item)
	If $last_icon = $item Then Return;
	
	If UBound($history) <> 1 Then
		If $item <> $backButton Then
			GUICtrlSetState($backButton, $GUI_SHOW);
			GUICtrlSetState($backButtonHover, $GUI_HIDE);
			GUICtrlSetState($backButtonDis, $GUI_HIDE);
		Else
			GUICtrlSetState($backButton, $GUI_HIDE);
			GUICtrlSetState($backButtonHover, $GUI_SHOW);
			GUICtrlSetState($backButtonDis, $GUI_HIDE);
		EndIf
	Else
		GUICtrlSetState($backButton, $GUI_HIDE);
		GUICtrlSetState($backButtonHover, $GUI_HIDE);
		GUICtrlSetState($backButtonDis, $GUI_SHOW);
	EndIf
	
	If UBound($forward) <> 1 Then
		If $item <> $forwardButton Then
			GUICtrlSetState($forwardButton, $GUI_SHOW);
			GUICtrlSetState($forwardButtonHover, $GUI_HIDE);
			GUICtrlSetState($forwardButtonDis, $GUI_HIDE);
		Else
			GUICtrlSetState($forwardButton, $GUI_HIDE);
			GUICtrlSetState($forwardButtonHover, $GUI_SHOW);
			GUICtrlSetState($forwardButtonDis, $GUI_HIDE);
		EndIf
	Else
		GUICtrlSetState($forwardButton, $GUI_HIDE);
		GUICtrlSetState($forwardButtonHover, $GUI_HIDE);
		GUICtrlSetState($forwardButtonDis, $GUI_SHOW);
	EndIf
	
	If $dir <> $LANG_COMPUTER Then
		If $item <> $upButton Then
			GUICtrlSetState($upButton, $GUI_SHOW);
			GUICtrlSetState($upButtonHover, $GUI_HIDE);
			GUICtrlSetState($upButtonDis, $GUI_HIDE);
		Else
			GUICtrlSetState($upButton, $GUI_HIDE);
			GUICtrlSetState($upButtonHover, $GUI_SHOW);
			GUICtrlSetState($upButtonDis, $GUI_HIDE);
		EndIf
	Else
		GUICtrlSetState($upButton, $GUI_HIDE);
		GUICtrlSetState($upButtonHover, $GUI_HIDE);
		GUICtrlSetState($upButtonDis, $GUI_SHOW);
	EndIf
	
	
	If $item <> $computerButton Then
		GUICtrlSetState($computerButton, $GUI_SHOW);
		GUICtrlSetState($computerButtonHover, $GUI_HIDE);
	Else
		GUICtrlSetState($computerButton, $GUI_HIDE);
		GUICtrlSetState($computerButtonHover, $GUI_SHOW);
	EndIf
	
	If $item <> $homeButton Then
		GUICtrlSetState($homeButton, $GUI_SHOW);
		GUICtrlSetState($homeButtonHover, $GUI_HIDE);
	Else
		GUICtrlSetState($homeButton, $GUI_HIDE);
		GUICtrlSetState($homeButtonHover, $GUI_SHOW);
	EndIf
	
	If $item <> $refreshButton Then
		GUICtrlSetState($refreshButton, $GUI_SHOW);
		GUICtrlSetState($refreshButtonHover, $GUI_HIDE);
	Else
		GUICtrlSetState($refreshButton, $GUI_HIDE);
		GUICtrlSetState($refreshButtonHover, $GUI_SHOW);
	EndIf
	
	If $item <> $copyButton Then
		GUICtrlSetState($copyButton, $GUI_SHOW);
		GUICtrlSetState($copyButtonHover, $GUI_HIDE);
	Else
		GUICtrlSetState($copyButton, $GUI_HIDE);
		GUICtrlSetState($copyButtonHover, $GUI_SHOW);
	EndIf
	
	If $item <> $cutButton Then
		GUICtrlSetState($cutButton, $GUI_SHOW);
		GUICtrlSetState($cutButtonHover, $GUI_HIDE);
	Else
		GUICtrlSetState($cutButton, $GUI_HIDE);
		GUICtrlSetState($cutButtonHover, $GUI_SHOW);
	EndIf
	
	If $item <> $pasteButton Then
		GUICtrlSetState($pasteButton, $GUI_SHOW);
		GUICtrlSetState($pasteButtonHover, $GUI_HIDE);
	Else
		GUICtrlSetState($pasteButton, $GUI_HIDE);
		GUICtrlSetState($pasteButtonHover, $GUI_SHOW);
	EndIf
	
	If $item <> $searchButton Then
		GUICtrlSetState($searchButton, $GUI_SHOW);
		GUICtrlSetState($searchButtonHover, $GUI_HIDE);
	Else
		GUICtrlSetState($searchButton, $GUI_HIDE);
		GUICtrlSetState($searchButtonHover, $GUI_SHOW);
	EndIf
	
	If $item <> $goButton Then
		GUICtrlSetState($goButton, $GUI_SHOW);
		GUICtrlSetState($goButtonHover, $GUI_HIDE);
	Else
		GUICtrlSetState($goButton, $GUI_HIDE);
		GUICtrlSetState($goButtonHover, $GUI_SHOW);
	EndIf
	$last_icon = $item;
EndFunc

Func mouseMiddleButton_Clicked()
	Local $oldOpt = Opt("MouseCoordMode", 2);
	
	#Region Tab
		Local $tabsetSize = ControlGetPos($window, "", $tabset);
		Local $hittest = _GUICtrlTab_HitTest($tabset, MouseGetPos(0) - $tabsetSize[0], MouseGetPos(1) - $tabsetSize[1]);
		If IsArray($hittest) Then
			If $hittest[0] <> -1 And $hittest[1] <> 1 Then
				_GUICtrlTab_SetCurSel($tabset, $hittest[0]);
				CloseTab();
			EndIf
		EndIf
	#EndRegion
	
	#Region ListView
		Local $listViewSize = ControlGetPos($window, "", $listView);
		MouseClick("primary");
		Local $items = _GUICtrlListView_GetSelectedIndices($listView);
		If String(Int($items)) = $items Then
			SelectNone();
			_GUICtrlListView_SetItemSelected($listView, Int($items));
			Start();
		EndIf
	#EndRegion
	

	Opt("MouseCoordMode", $oldOpt);
EndFunc