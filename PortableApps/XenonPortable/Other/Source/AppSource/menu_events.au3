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

Func NewTab()
	AddTab();
EndFunc

Func AddTab($folder = 0)
	If Not IsString($folder) Then
		$folder = DriveOf(@ScriptDir) & $SETTINGS_Homepage;
	EndIf
	
	$histories[_GUICtrlTab_GetCurSel($tabset)+1] = $history;
	$forwards[_GUICtrlTab_GetCurSel($tabset)+1] = $forward;
	$dirs[_GUICtrlTab_GetCurSel($tabset)+1] = $dir;
	
	Local $index = _GUICtrlTab_GetItemCount($tabset);
	_GUICtrlTab_InsertItem($tabset, $index, DirName($folder));
	;_GUICtrlTab_SetItemImage($tabset, $index, 0);
	
	ReDim $histories[_GUICtrlTab_GetItemCount($tabset)+1];
	ReDim $forwards[_GUICtrlTab_GetItemCount($tabset)+1];
	ReDim $history[1];
	ReDim $forward[1];
	
	ReDim $dirs[UBound($dirs)+1];
	
	_GUICtrlTab_SetCurSel($tabset, $index);
	$curtab = $index;
	LoadDir($folder, False);
EndFunc

Func CloseTab()
	If _GUICtrlTab_GetItemCount($tabset) <= 1 Then Return;
	Local $tab = _GUICtrlTab_GetCurSel($tabset);
	_ArrayDelete($dirs, $tab + 1);
	_ArrayDelete($histories, $tab + 1);
	_ArrayDelete($forwards, $tab + 1);
	_GUICtrlTab_DeleteItem($tabset, $tab);
	
	$curtab = -1;
	If _GUICtrlTab_GetCurSel($tabset) = -1 Then
		Local $newindex = $tab - 1;
		If $newindex = -1 Then $newindex = 0;
		_GUICtrlTab_SetCurSel($tabset, $newindex);
	EndIf
	If Not SelectTab() Then CloseTab();
EndFunc

Func NewFolder()
	GUISetState(@SW_DISABLE, $window);
	DisableHotkeys();
	Local $name = InputBox(" ", $LANG_ENTERTHENEWFILENAME, $LANG_NEWFOLDER_DIRNAME, " M");
	Local $error = @error;
	EnableHotkeys();
	GUISetState(@SW_ENABLE, $window);
	If $error Then Return;
	$name = _StrReplaceUnsupported($name);
	DirCreate($dir & $name);
	LoadDir($dir, False);
EndFunc

Func fileNewAddTemplateMenuItem_Click()
	GUISetState(@SW_DISABLE, $window);
	DisableHotkeys();
	Local $filename = FileOpenDialog("", DriveOf(@ScriptDir), $LANG_ALLFILES & " (*.*)", 1 + 4);
	EnableHotkeys();
	GUISetState(@SW_ENABLE, $window);
	If @error Then Return;
	
	;DisableHotkeys();
	;_ExplorerCopy($NEWFILES_DIR, $filename);
	;EnableHotkeys();
	SetXeDisablePrompt();
	ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & @ScriptDir & "\Shell.a3x"" /copy """ & $NEWFILES_DIR & """ """ & $filename & """");
EndFunc

Func fileNewItem_Click()
	If $dir = $LANG_COMPUTER Then Return;
	
	FileCopy($NEWFILES_DIR & GUICtrlRead(@GUI_CtrlId, 1), $dir);
	LoadDir($dir, False);
EndFunc

Func Rename()
	If $dir = $LANG_COMPUTER Then Return;
	
	Local $lvItems = _GUICtrlListView_GetSelectedIndices($listView, 1);
	If Not IsArray($lvItems) Then Return;
	If $lvItems[0] < 1 Then Return;
	
	Local $oldname = _GUICtrlListView_GetItemText($listView, $lvItems[1], 0);
	If $oldname == ".." Then Return;
	
	GUISetState(@SW_DISABLE, $window);
	DisableHotkeys();
	Local $name = InputBox($LANG_RENAMEFILEFOLDER, $LANG_ENTERTHENEWFILENAME, $oldname, " M");
	EnableHotkeys();
	GUISetState(@SW_ENABLE, $window);
	If @error Or $oldname = $name Then Return;
	$name = _StrReplaceUnsupported($name);
	If FileExists($dir & $name) Then Return;
	
	Local $success = False;
	If IsDir($dir & $oldname) Then
		$success = DirMove($dir & $oldname, $dir & $name, 1);
	Else
		$success = FileMove($dir & $oldname, $dir & $name, 1);
	EndIf
	
	If $success Then
		LoadDir($dir, False);
	Else
		DisableHotkeys();
		_MsgBox(16, $LANG_ERRORRENAMING, $LANG_THEFILEFOLDERCOULDNOTBERENAMED, $window);
		EnableHotkeys();
	EndIf
EndFunc

Func Delete()
	If $dir = $LANG_COMPUTER Then Return;
	
	Local $lvItems = _GUICtrlListView_GetSelectedIndices($listView, 1);
	If Not IsArray($lvItems) Then
		Return;
	EndIf
	
	Local $str = "";
	Local $i;
	For $i = 1 To $lvItems[0]
		Local $name = _GUICtrlListView_GetItemText($listView, $lvItems[$i], 0);
		If $name == ".." Then ContinueLoop;
		$str &= " """ & StringReplace($dir & $name, """", """""") & """";
	Next
	
	SetXeDisablePrompt();
	ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & @ScriptDir & "\Shell.a3x"" /delete" & $str);
EndFunc

Func Copy()
	If $dir = $LANG_COMPUTER Then Return;
	
	Local $lvItems = _GUICtrlListView_GetSelectedIndices($listView, 1);
	If Not IsArray($lvItems) Then
		Return;
	EndIf
	
	Local $files = "";
	Local $i;
	For $i = 1 To $lvItems[0]
		If _GUICtrlListView_GetItemText($listView, $lvItems[$i], 0) == ".." Then ContinueLoop;
		$files &= $dir & _GUICtrlListView_GetItemText($listView, $lvItems[$i], 0);
		If $i <> $lvItems[0] Then $files &= @LF;
	Next
	ClipPut($files);
	$cutting = 0;
EndFunc

Func Cut()
	If $dir = $LANG_COMPUTER Then Return;
	
	Local $lvItems = _GUICtrlListView_GetSelectedIndices($listView, 1);
	If Not IsArray($lvItems) Then
		Return;
	EndIf
	
	Local $files;
	Local $i;
	For $i = 1 To $lvItems[0]
		If _GUICtrlListView_GetItemText($listView, $lvItems[$i], 0) == ".." Then ContinueLoop;
		$files &= $dir & _GUICtrlListView_GetItemText($listView, $lvItems[$i], 0);
		If $i <> $lvItems[0] Then $files &= '|';
	Next
	ClipPut($files);
	$cutting = ClipGet();
EndFunc

Func Paste()
	If $dir = $LANG_COMPUTER Then Return;
	
	Local $files = ClipGet();
	If @error Then Return;
	
	$files = StringStripWS(StringReplace($files, "|", @LF, 0, 2), 3);
	Local $iscutting = (StringStripWS(StringReplace($cutting, "|", @LF, 0, 2), 3) = $files);
	
	$filesArr = StringSplit($files, @LF);
	
	If $iscutting Then
		Local $str = "";
		Local $i;
		For $i = 1 To $filesArr[0]
			Local $drive, $path, $file, $ext;
			_PathSplit(Depad($filesArr[$i]), $drive, $path, $file, $ext)
			$str &= " """ & _PathFull($filesArr[$i]) & """ """ & $dir & $file & $ext & """";
		Next
		
		SetXeDisablePrompt();
		ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & @ScriptDir & "\Shell.a3x"" /move" & $str);
		
	Else

		Local $copyStr = StringReplace($LANG_COPY, "&", "", 1);
		
		Local $str = "";
		Local $i;
		For $i = 1 To $filesArr[0]
			Local $drive, $path, $filename, $ext;
 			_PathSplit(Depad($filesArr[$i]), $drive, $path, $filename, $ext);
			Local $tostr = $dir;
 			If _PathFull($drive & $path) = _PathFull($dir) Then
				$filename = $filename & "-" & $copyStr;
				If FileExists($filename) Then
					Local $j = 1;
					While Not FileExists($drive & $path & $filename & "-" & $copyStr & $j & $ext)
						$j += 1;
					WEnd
					$filename = $filename & "-" & $copyStr & $j;
				EndIf
				$tostr = $dir & $filename & $ext;
			ElseIf IsDir($filesArr[$i]) Then
				$tostr &= $filename & $ext;
			EndIf
			$str &= " """ & StringReplace(_PathFull($filesArr[$i]), """", """""") & """ """ & $tostr & """";
			;ConsoleWrite($filesArr[$i] & @CRLF);
		Next
		
		SetXeDisablePrompt();
		ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & @ScriptDir & "\Shell.a3x"" /copy" & $str);
	EndIf
EndFunc

Func Paste2($item)
	Local $tvpath = _TreeViewItem_GetFullPath($item);
	
	Local $files = ClipGet();
	If @error Then Return;
	
	$files = StringStripWS(StringReplace($files, "|", @LF, 0, 2), 3);
	Local $iscutting = (StringStripWS(StringReplace($cutting, "|", @LF, 0, 2), 3) = $files);
	ConsoleWrite($files & @CRLF & StringStripWS(StringReplace($cutting, "|", @LF, 0, 2), 3))
	
	$filesArr = StringSplit($files, @LF);
	
	If $iscutting Then
		Local $str = "";
		Local $i;
		For $i = 1 To $filesArr[0]
			Local $drive, $path, $file, $ext;
			_PathSplit(Depad($filesArr[$i]), $drive, $path, $file, $ext)
			$str &= " """ & _PathFull($filesArr[$i]) & """ """ & $tvpath & "\" & $file & $ext & """";
		Next
		
		SetXeDisablePrompt();
		ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & @ScriptDir & "\Shell.a3x"" /move" & $str);
		
	Else

		Local $copyStr = StringReplace($LANG_COPY, "&", "", 1);
		
		Local $str = "";
		Local $i;
		For $i = 1 To $filesArr[0]
			Local $drive, $path, $filename, $ext;
 			_PathSplit(Depad($filesArr[$i]), $drive, $path, $filename, $ext);
			Local $tostr = $tvpath;
 			If _PathFull($drive & $path) = _PathFull($tvpath) Then
				$filename = $filename & "-" & $copyStr;
				If FileExists($filename) Then
					Local $j = 1;
					While Not FileExists($drive & $path & $filename & "-" & $copyStr & $j & $ext)
						$j += 1;
					WEnd
					$filename = $filename & "-" & $copyStr & $j;
				EndIf
				$tostr = $tvpath & "\" & $filename & $ext;
			ElseIf IsDir($filesArr[$i]) Then
				$tostr &= $filename & $ext;
			EndIf
			$str &= " """ & StringReplace(_PathFull($filesArr[$i]), """", """""") & """ """ & $tostr & """";
			;ConsoleWrite($filesArr[$i] & @CRLF);
		Next
		
		SetXeDisablePrompt();
		ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & @ScriptDir & "\Shell.a3x"" /copy" & $str);
	EndIf
EndFunc

Func SelectAll()
	_GUICtrlListView_BeginUpdate($listView);
	Local $i;
	For $i = 0 To _GUICtrlListView_GetItemCount($listview) - 1
		_GUICtrlListView_SetItemState($listView, $i, $LVIS_SELECTED, $LVIS_SELECTED);
	Next
	_GUICtrlListView_EndUpdate($listView);
EndFunc

Func SelectNone()
	_GUICtrlListView_BeginUpdate($listView);
	Local $i;
	For $i = 0 To _GUICtrlListView_GetItemCount($listview) - 1
		_GUICtrlListView_SetItemState($listView, $i, 0, $LVIS_SELECTED);
	Next
	_GUICtrlListView_EndUpdate($listView);
EndFunc

Func Refresh()
	LoadDir($dir, False);
EndFunc

Func ShowHideTreeView()
	If $SETTINGS_ShowTreeView Then
		GUICtrlSetState($viewShowTreeView, $GUI_UNCHECKED);
		GUICtrlSetState($treeView, $GUI_HIDE);
		$SETTINGS_ShowTreeView = 0;
	Else
		GUICtrlSetState($viewShowTreeView, $GUI_CHECKED);
		GUICtrlSetState($treeView, $GUI_SHOW);
		$SETTINGS_ShowTreeView = 1;
		LoadTreeView($dir);
	EndIf
	window_Resize();
EndFunc

Func ViewStyleDetials()
	GUICtrlSetState($viewStyleDetailsMenuItem, $GUI_CHECKED);
	GUICtrlSetState($viewStyleIconsMenuItem, $GUI_UNCHECKED);
	GUICtrlSetState($viewStyleSmallIconsMenuItem, $GUI_UNCHECKED);
	GUICtrlSetState($viewStyleTileMenuItem, $GUI_UNCHECKED);
	
	If @OSTYPE <> "WIN32_NT" Or @OSVersion = "WIN_NT4" Or @OSVersion = "WIN_2000" Then
		GUICtrlSetStyle($listView, $LVS_REPORT);
	Else
		_GUICtrlListView_SetView($listView, 0);
	EndIf
	$SETTINGS_ViewStyle = 0;
	LoadDir($dir);
EndFunc

Func ViewStyleIcons()
	GUICtrlSetState($viewStyleDetailsMenuItem, $GUI_UNCHECKED);
	GUICtrlSetState($viewStyleIconsMenuItem, $GUI_CHECKED);
	GUICtrlSetState($viewStyleSmallIconsMenuItem, $GUI_UNCHECKED);
	GUICtrlSetState($viewStyleTileMenuItem, $GUI_UNCHECKED);
	
	If @OSTYPE <> "WIN32_NT" Or @OSVersion = "WIN_NT4" Or @OSVersion = "WIN_2000" Then
		GUICtrlSetStyle($listView, $LVS_ICON);
	Else
		_GUICtrlListView_SetView($listView, 1);
	EndIf
	$SETTINGS_ViewStyle = 1;
	LoadDir($dir);
EndFunc

Func ViewStyleSmallIcons()
	GUICtrlSetState($viewStyleDetailsMenuItem, $GUI_UNCHECKED);
	GUICtrlSetState($viewStyleIconsMenuItem, $GUI_UNCHECKED);
	GUICtrlSetState($viewStyleSmallIconsMenuItem, $GUI_CHECKED);
	GUICtrlSetState($viewStyleTileMenuItem, $GUI_UNCHECKED);
	
	If @OSTYPE <> "WIN32_NT" Or @OSVersion = "WIN_NT4" Or @OSVersion = "WIN_2000" Then
		GUICtrlSetStyle($listView, $LVS_LIST);
	Else
		_GUICtrlListView_SetView($listView, 2);
	EndIf
	$SETTINGS_ViewStyle = 2;
	LoadDir($dir);
EndFunc

Func ViewStyleTile()
	GUICtrlSetState($viewStyleDetailsMenuItem, $GUI_UNCHECKED);
	GUICtrlSetState($viewStyleIconsMenuItem, $GUI_UNCHECKED);
	GUICtrlSetState($viewStyleSmallIconsMenuItem, $GUI_UNCHECKED);
	GUICtrlSetState($viewStyleTileMenuItem, $GUI_CHECKED);
	
	_GUICtrlListView_SetView($listView, 4);
	$SETTINGS_ViewStyle = 4;
	LoadDir($dir, False);
EndFunc

Func settingsFileAssocationEditorMenuItem_Click()
	ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & StringReplace(@ScriptDir, """", """""") & "\AssocationEditor.a3x""");
EndFunc

Func settingsHomepageMenuItem_Click()
	GUISetState(@SW_DISABLE, $window);
	DisableHotkeys();
	
	Local $path = FileSelectFolder($LANG_HOMEPAGE2, DriveOf(@ScriptDir), 2, DriveOf(@ScriptDir) & $SETTINGS_Homepage);
	If Not @error Then
		If DriveOf($path) = DriveOf(@ScriptDir) Then
			$SETTINGS_Homepage = StripDrive($path);
		EndIf
	EndIf
	EnableHotkeys();
	GUISetState(@SW_ENABLE, $window);
EndFunc

Func settingsChooseIconSetMenuItem_Click()
	ChooseIconSet($window);
EndFunc

Func ShowHiddenFilesMenuItem_Click()
	If BitAND(GUICtrlRead($settingsShowHiddenFilesMenuItem), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($settingsShowHiddenFilesMenuItem, $GUI_UNCHECKED);
		$SETTINGS_ShowHiddenFiles = 0;
	Else
		GUICtrlSetState($settingsShowHiddenFilesMenuItem, $GUI_CHECKED);
		$SETTINGS_ShowHiddenFiles = 1;
	EndIf
EndFunc

Func GetFolderSizesMenuItem_Click()
	If BitAND(GUICtrlRead($settingsGetFolderSizesMenuItem), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($settingsGetFolderSizesMenuItem, $GUI_UNCHECKED);
		$SETTINGS_GetFolderSizes = 0;
	Else
		GUICtrlSetState($settingsGetFolderSizesMenuItem, $GUI_CHECKED);
		$SETTINGS_GetFolderSizes = 1;
	EndIf
EndFunc

Func ShowDDItemMenuItem_Click()
	If BitAND(GUICtrlRead($settingsShowDDItemMenuItem), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($settingsShowDDItemMenuItem, $GUI_UNCHECKED);
		$SETTINGS_ShowDDItem = 0;
	Else
		GUICtrlSetState($settingsShowDDItemMenuItem, $GUI_CHECKED);
		$SETTINGS_ShowDDItem = 1;
	EndIf
	
	Refresh();
EndFunc

Func settingsPromptOnDeleteMenuItem_Click()
	If BitAND(GUICtrlRead($settingsPromptOnDeleteMenuItem), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($settingsPromptOnDeleteMenuItem, $GUI_UNCHECKED);
		$SETTINGS_PromptOnDelete = 0;
	Else
		GUICtrlSetState($settingsPromptOnDeleteMenuItem, $GUI_CHECKED);
		$SETTINGS_PromptOnDelete = 1;
	EndIf
EndFunc

Func bookmarksBookmarksEditorMenuItem_Click()
	EditBookmarks($window);
EndFunc

Func languageItem_Click()
	Dim $index = _ArraySearch($languageMenuItems, @GUI_CtrlId, 1);
	If $index <> -1 Then
		DisableHotkeys();
		_MsgBox(64, "", IniRead($LANG_DIR & "\" & $languageFileNames[$index], "TRANSLATION", "LANGUAGESETTINGSTAKEPLACEAFTERRESTART", ""), $window);
		EnableHotkeys();
	EndIf
EndFunc

Func Help()
	ShellExecute(@ScriptDir & "\help\index.html");
EndFunc

Func About()
	DisableHotkeys();
	_MsgBox(0, StringReplace($LANG_ABOUT, "&", "") & " Xenon " & $LANG_FILEMANAGER, "Xenon " & $LANG_FILEMANAGER & " version 1.5", $window);
	EnableHotkeys();
EndFunc

Func Properties()
	Local $lvItems = _GUICtrlListView_GetSelectedIndices($listView, 1);
	If Not IsArray($lvItems) Then Return;
	If $lvItems[0] < 1 Then Return;
	
	Local $i;
	For $i = 1 To $lvItems[0] 
		ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & StringReplace(@ScriptDir & "\Properties.a3x", """", """""") & """ """ & StringReplace(_GUICtrlListView_GetItemText($listView, $lvItems[$i], 0), """", """""") & """", $dir)
	Next
EndFunc