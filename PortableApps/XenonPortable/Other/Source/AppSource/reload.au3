#cs

    Xenon File Manager - Open source, portable file manager
    Copyright (C) 2007-2008 www.mi3soft.info
	
	Licensed under the LGPL + exceptions.


#ce

Func LoadDir($pdir, $addToHistory = True)
	If $pdir <> $LANG_COMPUTER And DriveStatus(DriveOf($pdir)) <> "READY" Then
		DisableHotkeys();
		GUISetState(@SW_DISABLE, $window);
		MsgBox(0, "", $LANG_ERRORDRIVENOTREADY);
		GUISetState(@SW_ENABLE, $window);
		EnableHotkeys();
		Return False;
	EndIf
	If $pdir == "" Or Not IsDir($pdir) And $pdir <> $LANG_COMPUTER Then
		DisableHotkeys();
		GUISetState(@SW_DISABLE, $window);
		MsgBox(0, "", $LANG_ERRORDIRNOTEXIST);
		GUISetState(@SW_ENABLE, $window);
		EnableHotkeys();
		Return False;
	EndIf
	
	If Not $hasOverloaded Then Return False;
	If $disableTreeViewEvents Then Return False;
	
	_GUICtrlListView_BeginUpdate($listView);
	
	$hasOverloaded = False;
	
	Local $i;
	For $i = 1 To UBound($listViewItems) - 1;
		GUICtrlDelete($listViewItems[$i]);
	Next
	ReDim $listViewItems[1];
	_GUICtrlListView_DeleteAllItems($listView);
	
	If $addToHistory Then
		ReDim $history[UBound($history) + 1];
		$history[UBound($history) - 1] = $dir;
		ReDim $forward[1];
	EndIf
	If $pdir = $LANG_COMPUTER Then
		$dir = $LANG_COMPUTER;
		
		Local $drives = DriveGetDrive("ALL");
		If Not IsArray($drives) Then Return;
		Local $i;
		For $i = 1 To $drives[0]
			Local $lvItem = GUICtrlCreateListViewItem(StringUpper($drives[$i]) & "    " & StringReplace(IniRead($drives[$i] & "\autorun.inf", "autorun", "label", DriveGetLabel($drives[$i])), "|", "") & "    |" & Round(DriveSpaceFree($drives[$i]) / 1024, 2) & " GB|", $listView);
			Dim $iconFile;
			Dim $iconIndex;
			DriveLoadIcon($drives[$i], $iconFile, $iconIndex);
			GUICtrlSetImage($lvItem, $iconFile, $iconIndex);
			GUICtrlSetColor($lvItem, 0x000000);
			If $SETTINGS_ViewStyle = 0 Then GUICtrlSetBkColor($lvItem, 0xEFEFEF);
			ReDim $listViewItems[UBound($listViewItems)+1];
			$listViewItems[UBound($listViewItems) - 1] = $lvItem;
			If $hasOverloaded Then Return;
		Next
		
		_GUICtrlListView_SetHotItem($listView, 0);
		GUICtrlSetData($addressBar, $dir);
		_GUICtrlTab_SetItemText($tabset, $curtab, $LANG_COMPUTER);
		
		_GUICtrlListView_EndUpdate($listView);
		$hasOverloaded = True;
		Return True;
	EndIf
	
	$pdir = Pad(_PathFull($pdir));
	$dir = $pdir;
	
	Local $files = FileFindFirstFile($pdir & "*");
	
	Local $folderList[1] = [0];
	Local $filesList[1] = [0];
	If $files <> -1 Then
		While True
			Local $file = FileFindNextFile($files);
			If @error Then ExitLoop;
			If $SETTINGS_ShowHiddenFiles Or Not StringInStr(FileGetAttrib($pdir & $file), "H", 2) Then
				If IsDir($pdir & $file) Then
					ReDim $folderList[UBound($folderList)+1];
					$folderList[UBound($folderList)-1] = $file;
				Else
					ReDim $filesList[UBound($filesList)+1];
					$filesList[UBound($filesList)-1] = $file;
				EndIf
			EndIf
		WEnd
		FileClose($files);
		
		
		_Sort_Cocktail($folderList, True);
		_Sort_Cocktail($filesList, True);
	EndIf
	
	Local $numLvItems = UBound($folderList) + UBound($filesList);
	ReDim $listViewItems[$numLvItems];
	Local $lvItemsIndex = 1;
	
	If $SETTINGS_ShowDDItem Then
		Local $dditem = GUICtrlCreateListViewItem("..", $listView);
		GUICtrlSetImage($dditem, GetFolderIconForCurTheme(), 0);
		If $SETTINGS_ViewStyle = 0 Then GUICtrlSetBkColor($dditem, 0xEFEFEF);
		GUICtrlSetColor($dditem, 0x000000);
		_GUICtrlListView_SetHotItem($listView, 0);
		_GUICtrlListView_SetItemCount($listView, UBound($folderList) + UBound($filesList) - 1);
		$listViewItems[$lvItemsIndex] = $dditem;
		$lvItemsIndex += 1;
	EndIf
	
	Local $i;
	For $i = 1 To UBound($folderList) - 1
		Local $folder = $folderList[$i];
		Local $fullPath = $pdir & $folder;
		Local $icon;
		Local $index;
		FolderGetIcon($folder, $icon, $index);
		
		
		Local $sizeStr = "";
		If $SETTINGS_GetFolderSizes Then $sizeStr = AdjustFileSize(DirGetSize($pdir & $folder));
		
		Local $time = FileGetTime($pdir & $folder);
		
		Local $lvItem = GUICtrlCreateListViewItem(StringFormat("%s|%s|%s", $folder, $sizeStr, TimeFormat($time)), $listView);
		GUICtrlSetImage($lvItem, $icon, $index);
		GUICtrlSetColor($lvItem, 0x000000);
		If $SETTINGS_ViewStyle = 0 Then GUICtrlSetBkColor($lvItem, 0xEFEFEF);
		$listViewItems[$lvItemsIndex] = $lvItem;
		$lvItemsIndex += 1;
		
		If $hasOverloaded Then Return;
	Next
	
	Local $j;
	For $j = 1 To UBound($filesList) - 1
		Local $file = $filesList[$j];
		Local $fullPath = $pdir & $file;
		Local $time = FileGetTime($fullPath);
		
		Local $lvItem = GUICtrlCreateListViewItem(StringFormat("%s|%s|%s", $file, AdjustFileSize(FileGetSize($fullPath)), TimeFormat($time)), $listView);
		
		Local $iconFile;
		Local $iconIndex;
		GetIcon($fullPath, $iconFile, $iconIndex);
		GUICtrlSetImage($lvItem, $iconFile, $iconIndex);
		GUICtrlSetColor($lvItem, 0x000000);
		If $SETTINGS_ViewStyle = 0 Then GUICtrlSetBkColor($lvItem, 0xEFEFEF);
		$listViewItems[$lvItemsIndex] = $lvItem;
		$lvItemsIndex += 1;
		
		If $hasOverloaded Then Return;
	Next
	
	_GUICtrlListView_EndUpdate($listView);
	
	GUICtrlSetData($addressBar, $pdir);
	_GUICtrlTab_SetItemText($tabset, $curtab, DirName($pdir));
	$last_icon = 1;
	IconSelect(0);
	
	If ControlCommand($window, "", $treeView, "IsVisible") Then LoadTreeView($pdir);
	
	GUICtrlSetState($listView, $GUI_FOCUS);
	
	$hasOverloaded = True;
	
	Return True;
EndFunc

;; LoadTreeView loads a folder into the treeview.
;; @arg, name=$pdir, desc=The folder to load.
Func LoadTreeView($pdir)
	;MsgBox(0, StringLen($pdir), $pdir);
	If $disableTreeViewEvents Then Return False;
	;MsgBox(0, StringLen($pdir), $pdir);
	If $pdir = $LANG_COMPUTER Then
		If _GUICtrlTreeView_GetFirstItem($treeView) = 0 Then
			Local $parts[2] = [1, ""];
			_GUICtrlTreeView_BeginUpdate($treeView);
			$disableTreeViewEvents = True;
			__LoadTreeView_LoadDrives($parts, 0);
			$disableTreeViewEvents = False;
			_GUICtrlTreeView_EndUpdate($treeView);
		EndIf
		Return;
	EndIf
	If Not IsDir($pdir) Then Return;
	_GUICtrlTreeView_BeginUpdate($treeView)
	$disableTreeViewEvents = True;
	
	Local $splitstr = StringSplit(_PathFull($pdir), "/\");
	Local $item = __LoadTreeView_FindItem($splitstr, 1, 0);
	
	Local $index = @extended;
	
	Local $nextCallItem;
	If $item = 0 Then
		$nextCallItem = __LoadTreeView_LoadDrives($splitstr, 0);
	Else
		$nextCallItem = __LoadTreeView_LoadFolder($splitstr, $index, $item);
	EndIf
	
	While $nextCallItem <> 0
		$index += 1;
		$nextCallItem = __LoadTreeView_LoadFolder($splitstr, $index, $nextCallItem);
	WEnd
	
	$disableTreeViewEvents = False;
	_GUICtrlTreeView_EndUpdate($treeView);
EndFunc

;; __LoadTreeView_FindItem finds a folder preloaded in the treeview.
;; @arg, Const=True, ByRef=True, name=$splitstr, desc=The folder to load split by \ and /
;; @arg, name=$i, desc=The current index in $splitstr
;; @arg, name=$parent, desc=The parent of the level that is being searched.
Func __LoadTreeView_FindItem(Const ByRef $splitstr, $i, $parent)
	Local $cur = _Iif($parent = 0, _GUICtrlTreeView_GetFirstItem($treeView), _GUICtrlTreeView_GetFirstChild($treeView, $parent));
	While $cur <> 0
		If _GUICtrlTreeView_GetText($treeView, $cur) = $splitstr[$i] Then
			If $splitstr[0] = $i Then Return SetExtended($i, $cur);
			Local $ret = __LoadTreeView_FindItem($splitstr, $i + 1, $cur);
			Return SetExtended(@extended, $ret);
		EndIf
		
		$cur = _GUICtrlTreeView_GetNextSibling($treeView, $cur);
	WEnd
	Return SetExtended($i - 1, $parent);
EndFunc

;~ Func __LoadTreeView_FindItem($dir)
;~ 	$dir = StringReplace($dir, "\", "|")
;~ 	Local $item = _GUICtrlTreeView_FindItemEx($treeView, $dir);
;~ 	
;~ 	Local $i = 0;
;~ 	Local $curr = $item;
;~ 	While True
;~ 		$curr = _GUICtrlTreeView_GetParentHandle($treeView, $dir);
;~ 		If $curr = 0 Then ExitLoop;
;~ 		$i += 1;
;~ 	WEnd
;~ 	Return SetExtended($i, $item);
;~ EndFunc


Func __LoadTreeView_LoadDrives(Const ByRef $splitstr, $i)
	_GUICtrlTreeView_DeleteAll($treeView);
	
	Local $item = 0;
	Local $lastItem;
	Local $drives = DriveGetDrive("ALL");
	Local $j;
	For $j = 1 To $drives[0]
		Local $tmp = _GUICtrlTreeView_InsertItem($treeView, StringUpper($drives[$j]));
		;; SETIMAGE
		Local $iconFile, $iconIndex;
		DriveLoadIcon($drives[$j], $iconFile, $iconIndex);
		_GUICtrlTreeView_SetIcon($treeView, $tmp, $iconFile, $iconIndex);
		If $drives[$j] = $splitstr[$i+1] Then
			$item = $tmp;
		EndIf
	Next
	Return $item;
EndFunc

Func __LoadTreeView_LoadFolder(Const ByRef $splitstr, $i, $item)
	Local $folderstr = _ArrayToString($splitstr, "\", 1, $i);
	
	Local $curr = _GUICtrlTreeView_GetFirstChild($treeView, $item);
	While $curr <> 0
		Local $next = _GUICtrlTreeView_GetNextSibling($treeView, $curr);
		If Not IsDir($folderstr & "\" & _GUICtrlTreeView_GetText($treeView, $curr)) Then
			_GUICtrlTreeView_Delete($treeView, $curr);
		EndIf
		$curr = $next;
	WEnd
	
	
	Local $subitem = 0;
	Local $folders = _FileListToArray($folderstr, "*", 2);
	Local $curr = $TVI_FIRST;
	Local $last = $TVI_FIRST;
	If IsArray($folders) Then
		Local $j;
		For $j = 1 To $folders[0]
			If Not $SETTINGS_ShowHiddenFiles And StringInStr(FileGetAttrib($folderstr & "\" & $folders[$j]), "H", 2) Then
				ContinueLoop;
			EndIf
			
			Local $nextItem;
			If $curr = $TVI_FIRST Then
				$nextItem = _GUICtrlTreeView_GetFirstChild($treeView, $item);
			Else
				$nextItem = _GUICtrlTreeView_GetNextSibling($treeView, $curr);
			EndIf
			
			If $nextItem <> 0 Then
				Local $cmp = StringCompare($folders[$j], _GUICtrlTreeView_GetText($treeView, $nextItem), 1);
				If $cmp >= 0 Then
					$curr = $nextItem;
					If $cmp = 0 Then ContinueLoop;
				EndIf
			EndIf
			
			Local $tmp = _GUICtrlTreeView_InsertItem($treeView, $folders[$j], $item, $curr);
			
			$last = $curr;
			$curr = $tmp;
			
			Local $iconFile, $iconIndex;
			FolderGetIcon($folders[$j], $iconFile, $iconIndex, False);
			_GUICtrlTreeView_SetIcon($treeView, $tmp, $iconFile, $iconIndex);
			If $folders[$j] = $splitstr[$i+1] Then
				$subitem = $tmp;
			;Else
				;__LoadTreeView_PreloadFolder($tmp, $folderstr);
			EndIf
		Next
		_GUICtrlTreeView_Expand($treeView, $item);
		If $subitem = 0 Then _GUICtrlTreeView_SelectItem($treeView, $item);
		Return $subitem;
	EndIf
EndFunc

;~ Func __LoadTreeView_PreloadFolder($item, $path)
;~ 	If _GUICtrlTreeView_GetChildCount($treeView, $item) <> 0 Then
;~ 		Local $folders = _FileListToArray($path, "*", 2);
;~ 		If IsArray($folders) Then
;~ 			Local $j;
;~ 			For $j = 1 To $folders[0]
;~ 				Local $tmp = _GUICtrlTreeView_InsertItem($treeView, $folders[$j], $item);
;~ 				Local $iconFile, $iconIndex;
;~ 				FolderGetIcon($folders[$j], $iconFile, $iconIndex);
;~ 				_GUICtrlTreeView_SetIcon($treeView, $tmp, $iconFile, $iconIndex);
;~ 			Next
;~ 		EndIf
;~ 	EndIf
;~ EndFunc

Func SelectTab()
	If $curtab >= 0 Then
		$histories[$curtab+1] = $history;
		$forwards[$curtab+1] = $forward;
		$dirs[$curtab+1] = $dir;
	EndIf
	
	
	$history = $histories[_GUICtrlTab_GetCurSel($tabset)+1];
	$forward = $forwards[_GUICtrlTab_GetCurSel($tabset)+1];
	$dir = $dirs[_GUICtrlTab_GetCurSel($tabset)+1];
	
	$curtab = _GUICtrlTab_GetCurSel($tabset);
	Return LoadDir($dir, False);
EndFunc