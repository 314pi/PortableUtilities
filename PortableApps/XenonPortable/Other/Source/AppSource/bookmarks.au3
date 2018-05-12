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

Func EditBookmarks($parent)
	DisableHotKeys();
	GUISetState(@SW_DISABLE, $parent);
	Local $optOnEvent = Opt("GUIOnEventMode", 0);
	
	Local $bookmarkWin = GUICreate(StringReplace($LANG_BOOKMARKEDITOR, "&", ""), 300, 214);
	Local $bookmarkList = GUICtrlCreateList("", 0, 0, 180, 220);
	Local $addBtn = GUICtrlCreateButton($LANG_ADD, 200, 20, 90);
	Local $remBtn = GUICtrlCreateButton($LANG_REMOVE, 200, 50, 90);
	Local $editBtn = GUICtrlCreateButton($LANG_EDIT, 200, 80, 90);
	Local $captionBtn = GUICtrlCreateButton($LANG_BOOKMARKCAPTION, 200, 110, 90);
	Local $upBtn = GUICtrlCreateButton($LANG_UP, 200, 140, 90);
	Local $dnBtn = GUICtrlCreateButton($LANG_DOWN, 200, 170, 90);
	
	Local $i;
	For $i = 1 To UBound($SETTINGS_Bookmarks) - 1
		Local $str = $SETTINGS_Bookmarks[$i][1];
		If $str = "" Then $str = $SETTINGS_Bookmarks[$i][0];
		_GUICtrlListBox_InsertString($bookmarkList, $str);
	Next
	
	GUISetState(@SW_SHOW, $bookmarkWin);
	While True
		Local $msg = GUIGetMsg();
		Switch $msg
			Case $GUI_EVENT_CLOSE
				ExitLoop;
				
			Case $addBtn
				Local $newDir = BrowseForBookmark($bookmarkWin);
				If $newDir <> Default Then
					_GUICtrlListBox_InsertString($bookmarkList, $newDir);
					ReDim $SETTINGS_Bookmarks[UBound($SETTINGS_Bookmarks) + 1][2];
					$SETTINGS_Bookmarks[UBound($SETTINGS_Bookmarks) - 1][0] = $newDir;
					$SETTINGS_Bookmarks[UBound($SETTINGS_Bookmarks) - 1][1] = "";
				EndIf
				WinActivate($parent);
				WinActivate($bookmarkWin);
				
			Case $remBtn
				Local $index = _GUICtrlListBox_GetCurSel($bookmarkList);
				If $index <> -1 Then
					_GUICtrlListBox_DeleteString($bookmarkList, $index);
					;_ArrayDelete($SETTINGS_Bookmarks, $index + 1);
					Local $i;
					For $i = $index + 1 To UBound($SETTINGS_Bookmarks) - 2
						_ArraySwap($SETTINGS_Bookmarks[$i][0], $SETTINGS_Bookmarks[$i+1][0]);
						_ArraySwap($SETTINGS_Bookmarks[$i][1], $SETTINGS_Bookmarks[$i+1][1]);
					Next
					ReDim $SETTINGS_Bookmarks[UBound($SETTINGS_Bookmarks) - 1][2];
					Local $newIndex = $index - 1;
					If $newIndex = 0 Then $newIndex = 1;
					_GUICtrlListBox_SetCurSel($bookmarkList, $newIndex);
				EndIf
				
			Case $editBtn
				Local $index = _GUICtrlListBox_GetCurSel($bookmarkList);
				If $index <> -1 Then
					Local $newValue = BrowseForBookmark($bookmarkWin, $SETTINGS_Bookmarks[$index+1][0]);
					If $newValue <> Default Then
						$SETTINGS_Bookmarks[$index+1][0] = $newValue;
						If _GUICtrlListBox_GetText($bookmarkList, $index) <> $SETTINGS_Bookmarks[$index + 1][1] Then
							_GUICtrlListBox_ReplaceString($bookmarkList, $index, $newValue);
						EndIf
					EndIf
					WinActivate($parent);
					WinActivate($bookmarkWin);
				EndIf
				
			Case $captionBtn
				Local $index = _GUICtrlListBox_GetCurSel($bookmarkList);
				If $index <> -1 Then
					GUISetState(@SW_DISABLE, $bookmarkWin);
					Local $caption = InputBox($LANG_BOOKMARKCAPTION, $LANG_BOOKMARKCAPTIONMSG, String($SETTINGS_Bookmarks[$index+1][1]));
					If Not @error Then
						$SETTINGS_Bookmarks[$index+1][1] = $caption;
						_GUICtrlListBox_ReplaceString($bookmarkList, $index, $caption);
					EndIf
					GUISetState(@SW_ENABLE, $bookmarkWin);
				EndIf
				
			Case $upBtn
				Local $index = _GUICtrlListBox_GetCurSel($bookmarkList);
				If $index > 0 Then
					Local $text = _GUICtrlListBox_GetText($bookmarkList, $index);
					_GUICtrlListBox_ReplaceString($bookmarkList, $index, _GUICtrlListBox_GetText($bookmarkList, $index - 1));
					_GUICtrlListBox_ReplaceString($bookmarkList, $index - 1, $text);
					_GUICtrlListBox_SetCurSel($bookmarkList, $index - 1);
					
					Local $path = $SETTINGS_Bookmarks[$index+1][0];
					$SETTINGS_Bookmarks[$index+1][0] = $SETTINGS_Bookmarks[$index][0];
					$SETTINGS_Bookmarks[$index][0] = $path;
					
					Local $text = $SETTINGS_Bookmarks[$index+1][1];
					$SETTINGS_Bookmarks[$index+1][1] = $SETTINGS_Bookmarks[$index][1];
					$SETTINGS_Bookmarks[$index][1] = $text;
				EndIf
				
			Case $dnBtn
				Local $index = _GUICtrlListBox_GetCurSel($bookmarkList);
				If $index < _GUICtrlListBox_GetCount($bookmarkList) - 1 And $index > -1 Then
					Local $text = _GUICtrlListBox_GetText($bookmarkList, $index);
					_GUICtrlListBox_ReplaceString($bookmarkList, $index, _GUICtrlListBox_GetText($bookmarkList, $index + 1));
					_GUICtrlListBox_ReplaceString($bookmarkList, $index + 1, $text);
					_GUICtrlListBox_SetCurSel($bookmarkList, $index + 1);
					
					Local $path = $SETTINGS_Bookmarks[$index+1][0];
					$SETTINGS_Bookmarks[$index+1][0] = $SETTINGS_Bookmarks[$index+2][0];
					$SETTINGS_Bookmarks[$index+2][0] = $path;
					
					Local $text = $SETTINGS_Bookmarks[$index+1][1];
					$SETTINGS_Bookmarks[$index+1][1] = $SETTINGS_Bookmarks[$index+2][1];
					$SETTINGS_Bookmarks[$index+2][1] = $text;
				EndIf
				
		EndSwitch
	WEnd
	
	GUIDelete($bookmarkWin);
	RecreateBookmarks();
	
	Opt("GUIOnEventMode", $optOnEvent);
	GUISetState(@SW_ENABLE, $parent);
	EnableHotKeys();
EndFunc

Func BrowseForBookmark($parent, $dir = Default)
	GUISetState(@SW_DISABLE, $parent);
	
	If $dir = Default Then
		$dir = DriveOf(@ScriptDir);
	EndIf
	
	Local $ret = FileSelectFolder("", "", 3, $dir);
	If @error Then $ret = Default;
	
	GUISetState(@SW_ENABLE, $parent);
	Return $ret;
EndFunc

Func RecreateBookmarks()
	Local $i;
	For $i = 1 To UBound($bookmarksMenuItems) - 1
		GUICtrlDelete($bookmarksMenuItems[$i]);
	Next
	
	ReDim $bookmarksMenuItems[1];
	For $i = 1 To UBound($SETTINGS_Bookmarks) - 1
		Local $item = GUICtrlCreateMenuItem(StringReplace(_Iif($SETTINGS_Bookmarks[$i][1] = "", $SETTINGS_Bookmarks[$i][0], $SETTINGS_Bookmarks[$i][1]), "&", "&&"), $bookmarksMenu);
		_ArrayAdd($bookmarksMenuItems, $item);
		GUICtrlSetOnEvent($item, "Bookmark_Click");
	Next
EndFunc

Func Bookmark_Click()
	Local $i;
	For $i = 1 To UBound($SETTINGS_Bookmarks) - 1
		If $bookmarksMenuItems[$i] = @GUI_CtrlId Then
			LoadDir($SETTINGS_Bookmarks[$i][0]);
			ExitLoop;
		EndIf
	Next
EndFunc