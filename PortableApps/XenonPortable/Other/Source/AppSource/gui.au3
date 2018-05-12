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


Dim $window = GUICreate("Xenon " & $LANG_FILEMANAGER, 750, 550, Default, Default, BitOR($WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_SIZEBOX), $WS_EX_ACCEPTFILES);

#region Menu
Dim $fileMenu = GUICtrlCreateMenu($LANG_FILE);
	Dim $fileNewTabMenuItem = GUICtrlCreateMenuItem($LANG_NEWTAB & @TAB & "Ctrl+T", $fileMenu);
	DIm $fileCloseTabMenuItem = GUICtrlCreateMenuItem($LANG_CLOSETAB & @TAB & "Ctrl+F4", $fileMenu);
	GUICtrlCreateMenuItem("", $fileMenu);
	Dim $fileNewFolderMenuItem = GUICtrlCreateMenuItem($LANG_NEWFOLDER & @TAB & "F7", $fileMenu);
	Dim $fileNewMenuItem = GUICtrlCreateMenu($LANG_NEW, $fileMenu);
		Dim $fileNewAddTemplateMenuItem = GUICtrlCreateMenuItem($LANG_ADDTEMPLATE, $fileNewMenuItem);
		GUICtrlCreateMenuItem("", $fileNewMenuItem);
	GUICtrlCreateMenuItem("", $fileMenu);
	Dim $fileSearchMenuItem = GUICtrlCreateMenuItem($LANG_SEARCH & @TAB & "Ctrl+F", $fileMenu);
	GUICtrlCreateMenuItem("", $fileMenu);
	Dim $fileRenameMenuItem = GUICtrlCreateMenuItem($LANG_RENAME & @TAB & "F2", $fileMenu);
	Dim $fileDeleteMenuItem = GUICtrlCreateMenuItem($LANG_DELETE & @TAB & "Delete", $fileMenu);
	GUICtrlCreateMenuItem("", $fileMenu);
	Dim $fileExitMenuItem = GUICtrlCreateMenuItem($LANG_EXIT & @TAB & "Alt+F4", $fileMenu);
	
Dim $editMenu = GUICtrlCreateMenu($LANG_EDIT);
Dim $editCutMenuItem = GUICtrlCreateMenuItem($LANG_CUT & @TAB & "Ctrl+X", $editMenu);
	Dim $editCopyMenuItem = GUICtrlCreateMenuItem($LANG_COPY & @TAB & "Ctrl+C", $editMenu);
	Dim $editPasteMenuItem = GUICtrlCreateMenuItem($LANG_PASTE & @TAB & "Ctrl+V", $editMenu);
	GUICtrlCreateMenuItem("", $editMenu);
	Dim $editSelectAllMenuItem = GUICtrlCreateMenuItem($LANG_SELECTALL & @TAB & "Ctrl+A", $editMenu);
	Dim $editSelectNoneMenuItem = GUICtrlCreateMenuItem($LANG_SELECTNONE & @TAB & "Ctrl+Shift+A", $editMenu);
	
Dim $viewMenu = GUICtrlCreateMenu($LANG_VIEW);
	Dim $viewRefreshMenuItem = GUICtrlCreateMenuItem($LANG_REFRESH & @TAB & "F5", $viewMenu);
	Dim $viewShowTreeView = GUICtrlCreateMenuItem($LANG_TREEVIEW, $viewMenu);
	Dim $viewStyleMenuItem = GUICtrlCreateMenu($LANG_STYLE, $viewMenu);
		Dim $viewStyleDetailsMenuItem = GUICtrlCreateMenuItem($LANG_DETAILS, $viewStyleMenuItem, Default, 1);
		Dim $viewStyleIconsMenuItem = GUICtrlCreateMenuItem($LANG_ICONS, $viewStyleMenuItem, Default, 1);
		Dim $viewStyleSmallIconsMenuItem = GUICtrlCreateMenuItem($LANG_LIST, $viewStyleMenuItem, Default, 1);
		Dim $viewStyleTileMenuItem = GUICtrlCreateMenuItem($LANG_TILE, $viewStyleMenuItem, Default, 1);
	
Dim $settingsMenu = GUICtrlCreateMenu($LANG_SETTINGS);
	Dim $settingsFileAssocationEditorMenuItem = GUICtrlCreateMenuItem($LANG_FILEASSOCATIONEDITOR, $settingsMenu);
	Dim $settingsHomepageMenuItem = GUICtrlCreateMenuItem($LANG_HOMEPAGE, $settingsMenu);
	Dim $settingsChooseIconSetMenuItem = GUICtrlCreateMenuItem($LANG_CHOOSEICONSET, $settingsMenu);
	Dim $settingsShowHiddenFilesMenuItem = GUICtrlCreateMenuItem($LANG_SHOWHIDDENFILES, $settingsMenu);
	Dim $settingsGetFolderSizesMenuItem = GUICtrlCreateMenuItem($LANG_GETFOLDERSIZES, $settingsMenu);
	Dim $settingsShowDDItemMenuItem = GUICtrlCreateMenuItem($LANG_SHOWDDMENUITEM, $settingsMenu);
	Dim $settingsPromptOnDeleteMenuItem = GUICtrlCreateMenuItem($LANG_PROMPTONDELETE, $settingsMenu);
	Dim $settingsLanguageMenuItem = GUICtrlCreateMenu($LANG_LANGUAGE, $settingsMenu);
	
Dim $bookmarksMenu = GUICtrlCreateMenu($LANG_BOOKMARKS);
	Dim $bookmarksBookmarksEditorMenuItem = GUICtrlCreateMenuItem($LANG_BOOKMARKEDITOR, $bookmarksMenu);
	Dim $bookmarksSep = GUICtrlCreateMenuItem("", $bookmarksMenu);

Dim $helpMenu = GUICtrlCreateMenu($LANG_HELP);
	Dim $helpMenuItem = GUICtrlCreateMenuItem($LANG_HELP, $helpMenu & @TAB & "F1");
	Dim $helpAboutMenuItem = GUICtrlCreateMenuItem($LANG_ABOUT, $helpMenu);


GUICtrlSetOnEvent($fileNewTabMenuItem, "NewTab");
GUICtrlSetOnEvent($fileCloseTabMenuItem, "CloseTab");
GUICtrlSetOnEvent($fileNewFolderMenuItem, "NewFolder");
GUICtrlSetOnEvent($fileNewAddTemplateMenuItem, "fileNewAddTemplateMenuItem_Click");
GUICtrlSetOnEvent($fileSearchMenuItem, "searchButton_Click");
GUICtrlSetOnEvent($fileRenameMenuItem, "Rename");
GUICtrlSetOnEvent($fileDeleteMenuItem, "Delete");
GUICtrlSetOnEvent($fileExitMenuItem, "window_Close")
GUICtrlSetOnEvent($editCopyMenuItem, "Copy");
GUICtrlSetOnEvent($editCutMenuItem, "Cut");
GUICtrlSetOnEvent($editPasteMenuItem, "Paste");
GUICtrlSetOnEvent($editSelectAllMenuItem, "SelectAll");
GUICtrlSetOnEvent($editSelectNoneMenuItem, "SelectNone");
GUICtrlSetOnEvent($settingsFileAssocationEditorMenuItem, "settingsFileAssocationEditorMenuItem_Click");
GUICtrlSetOnEvent($settingsHomepageMenuItem, "settingsHomepageMenuItem_Click");
GUICtrlSetOnEvent($settingsChooseIconSetMenuItem, "settingsChooseIconSetMenuItem_Click");
GUICtrlSetOnEvent($settingsShowHiddenFilesMenuItem, "ShowHiddenFilesMenuItem_Click");
GUICtrlSetOnEvent($settingsGetFolderSizesMenuItem, "GetFolderSizesMenuItem_Click");
GUICtrlSetOnEvent($settingsShowDDItemMenuItem, "ShowDDItemMenuItem_Click");
GUICtrlSetOnEvent($settingsPromptOnDeleteMenuItem, "settingsPromptOnDeleteMenuItem_Click");
GUICtrlSetOnEvent($helpMenuItem, "Help");
GUICtrlSetOnEvent($helpAboutMenuItem, "About");
GUICtrlSetOnEvent($viewRefreshMenuItem, "Refresh");
GUICtrlSetOnEvent($viewShowTreeView, "ShowHideTreeView");
GUICtrlSetOnEvent($viewStyleDetailsMenuItem, "ViewStyleDetials");
GUICtrlSetOnEvent($viewStyleIconsMenuItem, "ViewStyleIcons");
GUICtrlSetOnEvent($viewStyleSmallIconsMenuItem, "ViewStyleSmallIcons");
GUICtrlSetOnEvent($viewStyleTileMenuItem, "ViewStyleTile");
GUICtrlSetOnEvent($bookmarksBookmarksEditorMenuItem, "bookmarksBookmarksEditorMenuItem_Click");

AddImageToMenu($fileMenu, $MF_BYPOSITION, 0, $MENU_DIR & "\tab.bmp");
AddImageToMenu($fileMenu, $MF_BYPOSITION, 3, $MENU_DIR & "\folder.bmp");
AddImageToMenu($fileMenu, $MF_BYPOSITION, 4, $MENU_DIR & "\new.bmp");
AddImageToMenu($fileMenu, $MF_BYPOSITION, 6, $MENU_DIR & "\search.bmp");
AddImageToMenu($editMenu, $MF_BYPOSITION, 0, $MENU_DIR & "\copy.bmp");
AddImageToMenu($editMenu, $MF_BYPOSITION, 1, $MENU_DIR & "\cut.bmp");
AddImageToMenu($editMenu, $MF_BYPOSITION, 2, $MENU_DIR & "\paste.bmp");
AddImageToMenu($viewMenu, $MF_BYPOSITION, 0, $MENU_DIR & "\refresh.bmp");

If @OSTYPE <> "WIN32_NT" Or @OSVersion = "WIN_NT4" Or @OSVersion = "WIN_2000" Then
	GUICtrlSetState($viewStyleTileMenuItem, $GUI_DISABLE);
EndIf

If @OSTYPE = "WIN32_WINDOWS" Then GUICtrlSetState($viewShowTreeView, $GUI_DISABLE);
#endregion Menu

#region Settings
If $SETTINGS_ShowHiddenFiles Then
	GUICtrlSetState($settingsShowHiddenFilesMenuItem, $GUI_CHECKED);
EndIf

Switch $SETTINGS_ViewStyle
	Case 1
		GUICtrlSetState($viewStyleIconsMenuItem, $GUI_CHECKED);
		
	Case 2
		GUICtrlSetState($viewStyleSmallIconsMenuItem, $GUI_CHECKED);
		
	Case 3
		GUICtrlSetState($viewStyleDetailsMenuItem, $GUI_CHECKED);
		
	Case 4
		GUICtrlSetState($viewStyleTileMenuItem, $GUI_CHECKED);
		
	Case Else
		GUICtrlSetState($viewStyleDetailsMenuItem, $GUI_CHECKED);
EndSwitch

If $SETTINGS_ShowTreeView Then
	GUICtrlSetState($viewShowTreeView, $GUI_CHECKED);
EndIf

If $SETTINGS_GetFolderSizes Then
	GUICtrlSetState($settingsGetFolderSizesMenuItem, $GUI_CHECKED);
EndIf

If $SETTINGS_ShowDDItem Then
	GUICtrlSetState($settingsShowDDItemMenuItem, $GUI_CHECKED);
EndIf

If $SETTINGS_PromptOnDelete Then
	GUICtrlSetState($settingsPromptOnDeleteMenuItem, $GUI_CHECKED);
EndIf
#endregion Settings

#region Lang
Dim $languageMenuItems[1] = [0];
Dim $languageFileNames[1] = [0];

Dim $search = FileFindFirstFile($LANG_DIR & "\lang_*.ini");
If $search <> -1 Then
	While True
		Dim $file = FileFindNextFile($search);
		If @error Then ExitLoop;
	
		Dim $langMenuItem = GUICtrlCreateMenuItem(IniRead($LANG_DIR & "\" & $file, "INFO", "NAME", "Unknown"), $settingsLanguageMenuItem, Default, True);
		If $file == $SETTINGS_Language Then
			GUICtrlSetState($langMenuItem, $GUI_CHECKED);
		EndIf
		
		GUICtrlSetOnEvent($langMenuItem, "languageItem_Click");
		
		_ArrayAdd($languageMenuItems, $langMenuItem);
		_ArrayAdd($languageFileNames, $file);
	WEnd
	FileClose($search);
EndIf
#endregion Lang

#region Bookmarks
Dim $bookmarksMenuItems[1];
RecreateBookmarks();
#endregion

Const $icon_size = 24;
#region Buttons
Dim $backButton = GUICtrlCreateIcon($TOOLBAR_DIR & "\back.ico", 0, 4, 3, $icon_size, $icon_size);
GUICtrlSetResizing($backButton, $GUI_DOCKALL);
GUICtrlSetOnEvent($backButton, "backButton_Click");
GUICtrlSetTip($backButton, $LANG_TIPGOTOPREV);

Dim $forwardButton = GUICtrlCreateIcon($TOOLBAR_DIR & "\forward.ico", 0, 34, 3, $icon_size, $icon_size);
GUICtrlSetResizing($forwardButton, $GUI_DOCKALL);
GUICtrlSetOnEvent($forwardButton, "forwardButton_Click");
GUICtrlSetTip($forwardButton, $LANG_TIPGOTONEXT);

Dim $upButton = GUICtrlCreateIcon($TOOLBAR_DIR & "\up.ico", 0, 65, 3, $icon_size, $icon_size);
GUICtrlSetResizing($upButton, $GUI_DOCKALL);
GUICtrlSetOnEvent($upButton, "upButton_Click");
GUICtrlSetTip($upButton, $LANG_TIPGOUP);

Dim $computerButton = GUICtrlCreateIcon($TOOLBAR_DIR & "\computer.ico", 0, 110, 3, $icon_size, $icon_size);
GUICtrlSetResizing($computerButton, $GUI_DOCKALL);
GUICtrlSetOnEvent($computerButton, "computerButton_Click");
GUICtrlSetTip($computerButton, $LANG_TIPGOTOCOMPUTER);

Dim $homeButton = GUICtrlCreateIcon($TOOLBAR_DIR & "\home.ico", 0, 143, 3, $icon_size, $icon_size);
GUICtrlSetResizing($homeButton, $GUI_DOCKALL);
GUICtrlSetOnEvent($homeButton, "homeButton_Click");
GUICtrlSetTip($homeButton, $LANG_TIPGOTOHOMEDRIVE);

Dim $refreshButton = GUICtrlCreateIcon($TOOLBAR_DIR & "\refresh.ico", 0, 176, 3, $icon_size, $icon_size);
GUICtrlSetResizing($refreshButton, $GUI_DOCKALL);
GUICtrlSetOnEvent($refreshButton, "Refresh");
GUICtrlSetTip($refreshButton, $LANG_TIPREFRSH);

Dim $cutButton = GUICtrlCreateIcon($TOOLBAR_DIR & "\cut.ico", 0, 220, 3, $icon_size, $icon_size);
GUICtrlSetResizing($cutButton, $GUI_DOCKALL);
GUICtrlSetOnEvent($cutButton, "Cut");
GUICtrlSetTip($cutButton, $LANG_TIPCUT);

Dim $copyButton = GUICtrlCreateIcon($TOOLBAR_DIR & "\copy.ico", 0, 253, 3, $icon_size, $icon_size);
GUICtrlSetResizing($copyButton, $GUI_DOCKALL);
GUICtrlSetOnEvent($copyButton, "Copy");
GUICtrlSetTip($copyButton, $LANG_TIPCOPY);

Dim $pasteButton = GUICtrlCreateIcon($TOOLBAR_DIR & "\paste.ico", 0, 284, 3, $icon_size, $icon_size);
GUICtrlSetResizing($pasteButton, $GUI_DOCKALL);
GUICtrlSetOnEvent($pasteButton, "Paste");
GUICtrlSetTip($pasteButton, $LANG_TIPPASTE);

Dim $searchButton = GUICtrlCreateIcon($TOOLBAR_DIR & "\search.ico", 0, 720, 3, $icon_size, $icon_size);
GUICtrlSetResizing($searchButton, $GUI_DOCKSIZE + $GUI_DOCKRIGHT);
GUICtrlSetOnEvent($searchButton, "searchButton_Click");
GUICtrlSetTip($searchButton, $LANG_TIPSEARCH);
#endregion

#region Hover Buttons
Dim $backButtonHover = GUICtrlCreateIcon($TOOLBAR_DIR & "\back_hover.ico", 0, 4, 3, $icon_size, $icon_size);
GUICtrlSetResizing($backButtonHover, $GUI_DOCKALL);
GUICtrlSetOnEvent($backButtonHover, "backButton_Click");
GUICtrlSetTip($backButtonHover, $LANG_TIPGOTOPREV);
GUICtrlSetState($backButtonHover, $GUI_HIDE);

Dim $forwardButtonHover = GUICtrlCreateIcon($TOOLBAR_DIR & "\forward_hover.ico", 0, 34, 3, $icon_size, $icon_size);
GUICtrlSetResizing($forwardButtonHover, $GUI_DOCKALL);
GUICtrlSetOnEvent($forwardButtonHover, "forwardButton_Click");
GUICtrlSetTip($forwardButtonHover, $LANG_TIPGOTONEXT);
GUICtrlSetState($forwardButtonHover, $GUI_HIDE);

Dim $upButtonHover = GUICtrlCreateIcon($TOOLBAR_DIR & "\up_hover.ico", 0, 65, 3, $icon_size, $icon_size);
GUICtrlSetResizing($upButtonHover, $GUI_DOCKALL);
GUICtrlSetOnEvent($upButtonHover, "upButton_Click");
GUICtrlSetTip($upButtonHover, $LANG_TIPGOUP);
GUICtrlSetState($upButtonHover, $GUI_HIDE);

Dim $computerButtonHover = GUICtrlCreateIcon($TOOLBAR_DIR & "\computer_hover.ico", 0, 110, 3, $icon_size, $icon_size);
GUICtrlSetResizing($computerButtonHover, $GUI_DOCKALL);
GUICtrlSetOnEvent($computerButtonHover, "computerButton_Click");
GUICtrlSetTip($computerButtonHover, $LANG_TIPGOTOCOMPUTER);
GUICtrlSetState($computerButtonHover, $GUI_HIDE);

Dim $homeButtonHover = GUICtrlCreateIcon($TOOLBAR_DIR & "\home_hover.ico", 0, 143, 3, $icon_size, $icon_size);
GUICtrlSetResizing($homeButtonHover, $GUI_DOCKALL);
GUICtrlSetOnEvent($homeButtonHover, "homeButton_Click");
GUICtrlSetTip($homeButtonHover, $LANG_TIPGOTOHOMEDRIVE);
GUICtrlSetState($homeButtonHover, $GUI_HIDE);

Dim $refreshButtonHover = GUICtrlCreateIcon($TOOLBAR_DIR & "\refresh_hover.ico", 0, 176, 3, $icon_size, $icon_size);
GUICtrlSetResizing($refreshButtonHover, $GUI_DOCKALL);
GUICtrlSetOnEvent($refreshButtonHover, "Refresh");
GUICtrlSetTip($refreshButtonHover, $LANG_TIPREFRSH);
GUICtrlSetState($refreshButtonHover, $GUI_HIDE);

Dim $cutButtonHover = GUICtrlCreateIcon($TOOLBAR_DIR & "\cut_hover.ico", 0, 220, 3, $icon_size, $icon_size);
GUICtrlSetResizing($cutButtonHover, $GUI_DOCKALL);
GUICtrlSetOnEvent($cutButtonHover, "Cut");
GUICtrlSetTip($cutButtonHover, $LANG_TIPCUT);
GUICtrlSetState($cutButtonHover, $GUI_HIDE);

Dim $copyButtonHover = GUICtrlCreateIcon($TOOLBAR_DIR & "\copy_hover.ico", 0, 253, 3, $icon_size, $icon_size);
GUICtrlSetResizing($copyButtonHover, $GUI_DOCKALL);
GUICtrlSetOnEvent($copyButtonHover, "Copy");
GUICtrlSetTip($copyButtonHover, $LANG_TIPCOPY);
GUICtrlSetState($copyButtonHover, $GUI_HIDE);

Dim $pasteButtonHover = GUICtrlCreateIcon($TOOLBAR_DIR & "\paste_hover.ico", 0, 284, 3, $icon_size, $icon_size);
GUICtrlSetResizing($pasteButtonHover, $GUI_DOCKALL);
GUICtrlSetOnEvent($pasteButtonHover, "Paste");
GUICtrlSetTip($pasteButtonHover, $LANG_TIPPASTE);
GUICtrlSetState($pasteButtonHover, $GUI_HIDE);

Dim $searchButtonHover = GUICtrlCreateIcon($TOOLBAR_DIR & "\search_hover.ico", 0, 720, 3, $icon_size, $icon_size);
GUICtrlSetResizing($searchButtonHover, $GUI_DOCKSIZE + $GUI_DOCKRIGHT);
GUICtrlSetOnEvent($searchButtonHover, "searchButton_Click");
GUICtrlSetTip($searchButtonHover, $LANG_TIPSEARCH);
GUICtrlSetState($searchButtonHover, $GUI_HIDE);
#endregion

#region Disabled Buttons
Dim $backButtonDis = GUICtrlCreateIcon($TOOLBAR_DIR & "\back_disabled.ico", 0, 4, 3, $icon_size, $icon_size);
GUICtrlSetResizing($backButtonDis, $GUI_DOCKALL);
GUICtrlSetState($backButtonDis, $GUI_HIDE);

Dim $forwardButtonDis = GUICtrlCreateIcon($TOOLBAR_DIR & "\forward_disabled.ico", 0, 34, 3, $icon_size, $icon_size);
GUICtrlSetResizing($forwardButtonDis, $GUI_DOCKALL);
GUICtrlSetState($forwardButtonDis, $GUI_HIDE);

Dim $upButtonDis = GUICtrlCreateIcon($TOOLBAR_DIR & "\up_disabled.ico", 0, 65, 3, $icon_size, $icon_size);
GUICtrlSetResizing($upButtonDis, $GUI_DOCKALL);
GUICtrlSetState($upButtonDis, $GUI_HIDE);
#endregion

#region Toolbars
Dim $searchBar = GUICtrlCreateInput("", 560, 3, 154);
GUICtrlSetResizing($searchBar, $GUI_DOCKSIZE + $GUI_DOCKRIGHT);

Dim $addressBar = GUICtrlCreateInput("", 5, 32, 709, Default);
GUICtrlSetResizing($addressBar, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT);
;GUICtrlSetFont($addressBar, 11.5);

Dim $goButton = GUICtrlCreateIcon($TOOLBAR_DIR & "\go.ico", 0, 719, 32, 24, 24);
GUICtrlSetResizing($goButton, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE);
GUICtrlSetOnEvent($goButton, "goButton_Click");

Dim $goButtonHover = GUICtrlCreateIcon($TOOLBAR_DIR & "\go_hover.ico", 0, 719, 32, 24, 24);
GUICtrlSetResizing($goButtonHover, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE);
GUICtrlSetOnEvent($goButtonHover, "goButton_Click");
GUICtrlSetState($goButtonHover, $GUI_HIDE);
#endregion Toolbars

Dim $treeView = GUICtrlCreateTreeView(0, 60, 224, 448, Default, $WS_EX_CLIENTEDGE);
GUICtrlSetResizing($treeView, $GUI_DOCKALL);
If @OSTYPE <> "WIN32_NT" Or Not $SETTINGS_ShowTreeView Then GUICtrlSetState($treeView, $GUI_HIDE);

Dim $listView = GUICtrlCreateListView($LANG_FILENAME & "|" & $LANG_FILESIZE & "|" & $LANG_DATEMODIFIED, 0, 80, 748, 418, $LVS_SHOWSELALWAYS, $LVS_EX_FULLROWSELECT + $WS_EX_CLIENTEDGE);
GUICtrlSetResizing($listView, $GUI_DOCKALL);
If @OSTYPE <> "WIN32_NT" Or @OSVersion = "WIN_NT4" Or @OSVersion = "WIN_2000" Then
	GUICtrlSetStyle($viewStyleMenuItem, $GUI_DISABLE);
Else
	_GUICtrlListView_SetView($listView, $SETTINGS_ViewStyle);
EndIf

GUICtrlSetOnEvent($listView, "ListView_Click");
GUICtrlRegisterListViewSort($listView, "ListView_Sort");
GUICtrlSetImage($listView, GetAssocIconFromFileName("default.ico"), 0);
GUICtrlSetState($listView, $GUI_DROPACCEPTED);
GUICtrlSetBkColor($listView, $GUI_BKCOLOR_LV_ALTERNATE);
GUICtrlSetBkColor($listView, 0xFFFFFF);
If $SETTINGS_ShowTreeView Then
	_GUICtrlListView_SetColumnWidth($listView, 0, 250);
Else
	_GUICtrlListView_SetColumnWidth($listView, 0, 500);
EndIf
Dim $listViewItems[1] = [0];

Const $CONTEXTMENU_LENGTH = 8;
Dim $contextMenu = GUICtrlCreateContextMenu($listView);
GUICtrlSetOnEvent(GUICtrlCreateMenuItem($LANG_OPEN, $contextMenu), "Open");
GUICtrlSetState(-1,$GUI_DEFBUTTON);
GUICtrlSetOnEvent(GUICtrlCreateMenuItem($LANG_START, $contextMenu), "Start");
GUICtrlCreateMenuItem("", $contextMenu);
Dim $newContextFile = GUICtrlCreateMenu($LANG_NEW, $contextMenu);
	GUICtrlSetOnEvent(GUICtrlCreateMenuItem($LANG_NEWFOLDER, $newContextFile), "NewFolder");
GUICtrlCreateMenuItem("", $contextMenu);
GUICtrlSetOnEvent(GUICtrlCreateMenuItem($LANG_CUT, $contextMenu), "Cut");
GUICtrlSetOnEvent(GUICtrlCreateMenuItem($LANG_COPY, $contextMenu), "Copy");
GUICtrlSetOnEvent(GUICtrlCreateMenuItem($LANG_PASTE, $contextMenu), "Paste");
GUICtrlCreateMenuItem("", $contextMenu);
GUICtrlSetOnEvent(GUICtrlCreateMenuItem($LANG_DELETE, $contextMenu), "Delete");
GUICtrlSetOnEvent(GUICtrlCreateMenuItem($LANG_RENAME, $contextMenu), "Rename");
GUICtrlSetOnEvent(GUICtrlCreateMenuItem($LANG_REFRESH, $contextMenu), "Refresh");
GUICtrlCreateMenuItem("", $contextMenu);
GUICtrlSetOnEvent(GUICtrlCreateMenuItem($LANG_PROPERTIES, $contextMenu), "Properties");


Dim $tabset = _GUICtrlTab_Create($window, 0, 60, 728, 20);
Dim $tabImgList = _GUIImageList_Create(16, 16);

Dim $tabCloseIcon = GUICtrlCreateIcon($CURRENT_THEME_DIR & "\closetab.ico", 0, 730, 62, 16, 16);
GUICtrlSetResizing($tabCloseIcon, BitOR($GUI_DOCKTOP, $GUI_DOCKRIGHT, $GUI_DOCKSIZE));
GUICtrlSetOnEvent($tabCloseIcon, "CloseTab");


Dim $search = FileFindFirstFile($NEWFILES_DIR & "*.*");
If $search <> -1 Then
	While True
		Dim $file = FileFindNextFile($search);
		If @error Then ExitLoop;
		
		Dim $fileItem = GUICtrlCreateMenuItem($file, $fileNewMenuItem);
		GUICtrlSetOnEvent($fileItem, "fileNewItem_Click");
		
		Dim $fileItem = GUICtrlCreateMenuItem($file, $newContextFile);
		GUICtrlSetOnEvent($fileItem, "fileNewItem_Click");
	WEnd
	FileClose($search);
EndIf


#include "plugin.au3"

GUISetOnEvent($GUI_EVENT_CLOSE, "window_Close", $window);
GUISetOnEvent($GUI_EVENT_PRIMARYDOWN,"window_Click", $window);
GUISetOnEvent($GUI_EVENT_RESIZED, "window_Resize", $window);
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "window_Resize", $window);
GUISetOnEvent($GUI_EVENT_RESTORE, "window_Resize", $window);
GUISetOnEvent($GUI_EVENT_DROPPED, "window_Dropped", $window);
GUISetOnEvent($GUI_EVENT_MOUSEMOVE, "window_MouseMove", $window);
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY");
GUIRegisterMsg($WM_CONTEXTMENU, "WM_CONTEXTMENU");
GUIRegisterMsg($WM_DROPFILES, "WM_DROPFILES");
GUIRegisterMsg($WM_GETMINMAXINFO, "WM_GETMINMAXINFO");
GUIRegisterMsg($WM_ACTIVATEAPP, "WM_ACTIVATEAPP");

GUISetState(@SW_SHOW, $window);
EnableHotKeys();
window_Resize();