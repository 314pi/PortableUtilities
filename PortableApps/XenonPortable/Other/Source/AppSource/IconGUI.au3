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

Func ChooseIconSet($parent)
	DisableHotKeys();
	GUISetState(@SW_DISABLE, $parent);
	Local $optOnEvent = Opt("GUIOnEventMode", 0);
	
	Local $selIconWin = GUICreate(StringReplace($LANG_CHOOSEICONSET, "&", ""), 500, 214);
	Local $iconSetList = GUICtrlCreateList("", 0, 0, 180, 220);
	Local $iconSetPreview = GUICtrlCreatePic($CURRENT_THEME_DIR & "\preview.jpg", 200, 0, 300, 180);
	Local $okBtn = GUICtrlCreateButton($LANG_OK, 200, 185, 93);
	Local $cancelBtn = GUICtrlCreateButton($LANG_CANCEL, 300, 185, 93);
	
	Local $search = FileFindFirstFile($THEMES_DIR & "\*");
	While True
		Local $fname = FileFindNextFile($search);
		If @error Then ExitLoop;
		If Not IsDir($THEMES_DIR & "\" & $fname) Or Not FileExists($THEMES_DIR & "\" & $fname & "\preview.jpg") Then ContinueLoop;
		
		_GUICtrlListBox_AddString($iconSetList, $fname);
	WEnd
	
	_GUICtrlListBox_SelectString($iconSetList, $SETTINGS_IconSet);
	
	GUISetState(@SW_SHOW, $selIconWin);
	While True
		Local $msg = GUIGetMsg();
		Switch $msg
			Case $GUI_EVENT_CLOSE, $cancelBtn
				ExitLoop;
				
			Case $iconSetList
				GUICtrlSetImage($iconSetPreview, $THEMES_DIR & "\" & _GUICtrlListBox_GetText($iconSetList, _GUICtrlListBox_GetCurSel($iconSetList)) & "\preview.jpg");
				
			Case $okBtn
				If _GUICtrlListBox_GetCurSel($iconSetList) <> -1 Then
					$SETTINGS_IconSet = _GUICtrlListBox_GetText($iconSetList, _GUICtrlListBox_GetCurSel($iconSetList));
					
					$CURRENT_THEME_DIR = $THEMES_DIR & "\" & $SETTINGS_IconSet;
					$ASSOCICONS_DIR = $CURRENT_THEME_DIR & "\assoc";
					$TOOLBAR_DIR = $CURRENT_THEME_DIR & "\toolbar";
					$DRIVEICO_DIR = $CURRENT_THEME_DIR & "\drives";
					$MENU_DIR = $CURRENT_THEME_DIR & "\menu";
				EndIf
				ExitLoop;
		EndSwitch
	WEnd	
	GUIDelete($selIconWin);
	
	WinActivate($parent);
	
	ReloadIcons();
	
	Opt("GUIOnEventMode", $optOnEvent);
	GUISetState(@SW_ENABLE, $parent);
	
EndFunc

Func ReloadIcons()
	GUICtrlSetImage($backButton, $TOOLBAR_DIR & "\back.ico");
	GUICtrlSetImage($forwardButton, $TOOLBAR_DIR & "\forward.ico");
	GUICtrlSetImage($upButton, $TOOLBAR_DIR & "\up.ico");
	GUICtrlSetImage($computerButton, $TOOLBAR_DIR & "\computer.ico");
	GUICtrlSetImage($homeButton, $TOOLBAR_DIR & "\home.ico");
	GUICtrlSetImage($refreshButton, $TOOLBAR_DIR & "\refresh.ico");
	GUICtrlSetImage($copyButton, $TOOLBAR_DIR & "\copy.ico");
	GUICtrlSetImage($cutButton, $TOOLBAR_DIR & "\cut.ico");
	GUICtrlSetImage($pasteButton, $TOOLBAR_DIR & "\paste.ico");
	
	GUICtrlSetImage($backButtonHover, $TOOLBAR_DIR & "\back_hover.ico");
	GUICtrlSetImage($forwardButtonHover, $TOOLBAR_DIR & "\forward_hover.ico");
	GUICtrlSetImage($upButtonHover, $TOOLBAR_DIR & "\up_hover.ico");
	GUICtrlSetImage($computerButtonHover, $TOOLBAR_DIR & "\computer_hover.ico");
	GUICtrlSetImage($homeButtonHover, $TOOLBAR_DIR & "\home_hover.ico");
	GUICtrlSetImage($refreshButtonHover, $TOOLBAR_DIR & "\refresh_hover.ico");
	GUICtrlSetImage($copyButtonHover, $TOOLBAR_DIR & "\copy_hover.ico");
	GUICtrlSetImage($cutButtonHover, $TOOLBAR_DIR & "\cut_hover.ico");
	GUICtrlSetImage($pasteButtonHover, $TOOLBAR_DIR & "\paste_hover.ico");
	
	GUICtrlSetImage($backButtonDis, $TOOLBAR_DIR & "\back_disabled.ico");
	GUICtrlSetImage($forwardButtonDis, $TOOLBAR_DIR & "\forward_disabled.ico");
	GUICtrlSetImage($upButtonDis, $TOOLBAR_DIR & "\up_disabled.ico");
	
	GUICtrlSetImage($searchButton, $TOOLBAR_DIR & "\search.ico");
	GUICtrlSetImage($searchButtonHover, $TOOLBAR_DIR & "\search_hover.ico");
	
	GUICtrlSetImage($goButton, $TOOLBAR_DIR & "\go.ico");
	GUICtrlSetImage($goButtonHover, $TOOLBAR_DIR & "\go_hover.ico");
	
	
	AddImageToMenu($fileMenu, $MF_BYPOSITION, 0, $MENU_DIR & "\tab.bmp");
	AddImageToMenu($fileMenu, $MF_BYPOSITION, 3, $MENU_DIR & "\folder.bmp");
	AddImageToMenu($fileMenu, $MF_BYPOSITION, 4, $MENU_DIR & "\new.bmp");
	AddImageToMenu($fileMenu, $MF_BYPOSITION, 6, $MENU_DIR & "\search.bmp");
	AddImageToMenu($editMenu, $MF_BYPOSITION, 0, $MENU_DIR & "\copy.bmp");
	AddImageToMenu($editMenu, $MF_BYPOSITION, 1, $MENU_DIR & "\cut.bmp");
	AddImageToMenu($editMenu, $MF_BYPOSITION, 2, $MENU_DIR & "\paste.bmp");
	AddImageToMenu($viewMenu, $MF_BYPOSITION, 0, $MENU_DIR & "\refresh.bmp");
	
	GUICtrlSetImage($tabCloseIcon, $CURRENT_THEME_DIR & "\closetab.ico");
	
	_GUICtrlTreeView_DeleteAll($treeView);
	LoadTreeView($dir);
	$msgTvClkAddToHistory = False;
	$msgTvClk = $dir;
EndFunc

Func ResizeIcons()
	
EndFunc