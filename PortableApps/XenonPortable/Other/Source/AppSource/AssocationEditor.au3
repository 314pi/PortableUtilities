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

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=AssocationEditor.a3x
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GUIComboBox.au3>
#include <GUIListBox.au3>
#include <Array.au3>
#include <File.au3>

Opt("GUIOnEventMode", 1);
Opt("GUICloseOnEsc", 0);

#include "Constants.au3"


Const $LANG_INIFILE = IniRead($DATA_DIR & "\settings.ini", "Xenon", "language", "lang_en-us.ini");
Dim $LangFullPath = $LANG_DIR & "\" & $LANG_INIFILE;

Const $LANG_FILEASSOCIATIONEDITOR = IniRead($LangFullPath, "ASSOCEDIT", "FILEASSOCATIONEDITOR", "File Association Editor");
Const $LANG_ICON = IniRead($LangFullPath, "ASSOCEDIT", "ICON", "Icon");
Const $LANG_EXECUTABLE = IniRead($LangFullPath, "ASSOCEDIT", "EXECUTABLE", "Executable");
Const $LANG_BROWSE = IniRead($LangFullPath, "ASSOCEDIT", "BROWSE", "Browse...");
Const $LANG_ADD = IniRead($LangFullPath, "ASSOCEDIT", "ADD", "&Add");
Const $LANG_CANCEL = IniRead($LangFullPath, "ASSOCEDIT", "CANCEL", "&Cancel");
Const $LANG_ADDEXTENSION = IniRead($LangFullPath, "ASSOCEDIT", "ADDEXTENSION", "&Add Extenstion");
Const $LANG_DELETEEXTENSION = IniRead($LangFullPath, "ASSOCEDIT", "DELETEEXTENSION", "&Delete Extension");
Const $LANG_BROWSEFOREXECUTABLE = IniRead($LangFullPath, "ASSOCEDIT", "BROWSEFOREXECUTABLE", "Browse for Exececutable");
Const $LANG_ERROR = IniRead($LangFullPath, "ASSOCEDIT", "ERROR", "Error");
Const $LANG_THEEXECUTABLEMUSTBEONTHESAMEDRIVEASXENON = IniRead($LangFullPath, "ASSOCEDIT", "THEEXECUTABLEMUSTBEONTHESAMEDRIVEASXENON","The executable must be on the same drive as Xenon.");
Const $LANG_ENTERFILEEXTENSION = IniRead($LangFullPath, "ASSOCEDIT", "ENTERFILEEXTENSION", "Enter File Extension");
Const $LANG_INSTALLNEWICON = IniRead($LangFullPath, "ASSOCEDIT", "INSTALLNEWICON", "&Install Icon");
Const $LANG_ICONFILES = IniRead($LangFullPath, "ASSOCEDIT", "ICONFILES", "Icon Files");
Const $LANG_OVERWRITEICON = IniRead($LangFullPath, "ASSOCEDIT", "OVERWRITEICON", "Are you sure you want to replace the icon %s?");
Const $LANG_CANTINSTALLICON = IniRead($LangFullPath, "ASSOCEDIT", "CANTINSTALLICON", "An unknown error occurred while installing icons.");
Const $LANG_CLEAR = IniRead($LangFullPath, "ASSOCEDIT", "CLEAR", "&Clear");
Const $LANG_SAVE = IniRead($LangFullPath, "ASSOCEDIT", "SAVE", "&Save");
Const $LANG_SAVECHANGES = IniRead($LangFullPath, "ASSOCEDIT", "SAVECHANGES", "Would you like to save your changes?");


Dim $window = GUICreate("Xenon " & $LANG_FILEASSOCIATIONEDITOR, 500, 500);
GUISetOnEvent($GUI_EVENT_CLOSE, "window_Close", $window);

Dim $extList = GUICtrlCreateList("", 0, 0, 100, 500, $WS_VSCROLL + $LBS_NOINTEGRALHEIGHT);
GUICtrlSetOnEvent($extList, "extList_SelectedIndexChanged");
_GUICtrlListBox_ResetContent($extList);

Dim $fileIcons[1];
Dim $fileExecs[1];
Dim $fileStarts[1];
Dim $tmpExt;

Dim $iniCategories = IniReadSectionNames($DATA_DIR & "\assoc.ini");
Dim $i;
For $i = 1 To $iniCategories[0]
	_GUICtrlListBox_InsertString($extList, $iniCategories[$i]);
	
	ReDim $fileIcons[UBound($fileIcons) + 1];
	$fileIcons[UBound($fileIcons) - 1] = IniRead($DATA_DIR & "\assoc.ini", $iniCategories[$i], "icon", "default.ico");
	
	ReDim $fileExecs[UBound($fileExecs) + 1];
	$fileExecs[UBound($fileExecs) - 1] = IniRead($DATA_DIR & "\assoc.ini", $iniCategories[$i], "exe", "");
	
	ReDim $fileStarts[UBound($fileStarts) + 1];
	$fileStarts[UBound($fileStarts) - 1] = IniRead($DATA_DIR & "\assoc.ini", $iniCategories[$i], "start", "");
Next

Dim $iconLabel = GUICtrlCreateLabel($LANG_ICON, 120, 10);
Dim $iconPreviewCtrl = GUICtrlCreateIcon("", 0, 120, 35);
Dim $iconCombo = GUICtrlCreateCombo("", 120, 70, 100, 150, $CBS_DROPDOWNLIST);
_GUICtrlComboBox_DeleteString($iconCombo, 0);
GUICtrlSetState($iconCombo, $GUI_DISABLE);
GUICtrlSetOnEvent($iconCombo, "iconCombo_SelectedIndexChanged");
Dim $iconFile;

Dim $files = FileFindFirstFile($CURRENT_THEME_DIR & "\assoc\*.ico");
If $files <> -1 Then
	While True
		Dim $file = FileFindNextFile($files);
		If @error Then ExitLoop;
		_GUICtrlComboBox_AddString($iconCombo, $file);
	WEnd
	FileClose($files);
EndIf

Dim $files = FileFindFirstFile($DEFAULT_THEME_DIR & "\assoc\*.ico");
If $files <> -1 Then
	While True
		Dim $file = FileFindNextFile($files);
		If @error Then ExitLoop;
		_GUICtrlComboBox_AddString($iconCombo, $file);
	WEnd
	FileClose($files);
EndIf


Dim $installIcon = GUICtrlCreateButton($LANG_INSTALLNEWICON, 230, 70, 120, 21);
GUICtrlSetOnEvent($installIcon, "installIcon_Click");

Dim $execLabel = GUICtrlCreateLabel($LANG_EXECUTABLE, 120, 150);
Dim $execTextBox = GUICtrlCreateInput("", 120, 170, 200);
Dim $execBrowseButton = GUICtrlCreateButton($LANG_BROWSE, 330, 170, 73, 21);
Dim $execClearButton = GUICtrlCreateButton($LANG_CLEAR, 410, 170, 73, 21);
GUICtrlSetOnEvent($execBrowseButton, "execBrowseButton_Click");
GUICtrlSetOnEvent($execClearButton, "execClearButton_Click");
GUICtrlSetState($execTextBox, $GUI_DISABLE);
GUICtrlSetState($execBrowseButton, $GUI_DISABLE);
GUICtrlSetState($execClearButton, $GUI_DISABLE);

Dim $startTextBox = GUICtrlCreateInput("", 120, 200, 200);
Dim $startBrowseButton = GUICtrlCreateButton($LANG_BROWSE, 330, 200, 73, 21);
Dim $startClearButton = GUICtrlCreateButton($LANG_CLEAR, 410, 200, 73, 21);
GUICtrlSetOnEvent($startBrowseButton, "startBrowseButton_Click");
GUICtrlSetOnEvent($startClearButton, "startClearButton_Click");
GUICtrlSetState($startTextBox, $GUI_DISABLE);
GUICtrlSetState($startBrowseButton, $GUI_DISABLE);
GUICtrlSetState($startClearButton, $GUI_DISABLE);

Dim $confirmAddButton = GUICtrlCreateButton($LANG_ADD, 120, 250, 73);
Dim $cancelButton = GUICtrlCreateButton($LANG_CANCEL, 200, 250, 73);
GUICtrlSetState($confirmAddButton, $GUI_HIDE);
GUICtrlSetState($cancelButton, $GUI_HIDE);
GUICtrlSetOnEvent($confirmAddButton, "confirmAddButton_Click");
GUICtrlSetOnEvent($cancelButton, "cancelButton_Click");

Dim $addExtButton = GUICtrlCreateButton($LANG_ADDEXTENSION, 110, 470);
GUICtrlSetOnEvent($addExtButton, "addExtButton_Click");

Dim $deleteExtButton = GUICtrlCreateButton($LANG_DELETEEXTENSION, 250, 470);
GUICtrlSetState($deleteExtButton, $GUI_DISABLE);
GUICtrlSetOnEvent($deleteExtButton, "deleteExtButton_Click");

Dim $saveButton = GUICtrlCreateButton($LANG_SAVE, 110, 440);
GUICtrlSetOnEvent($saveButton, "window_Close");

Dim $cancelAllButton = GUICtrlCreateButton($LANG_CANCEL, 250, 440);
GUICtrlSetOnEvent($cancelAllButton, "cancelAllButton_Click");

Dim $index = $LB_ERR;

GUISetState(@SW_SHOW, $window);

While True
	Sleep(200);
WEnd

Func window_Close()
	GUISetState(@SW_HIDE, $window);
	
	If @GUI_CtrlId = $GUI_EVENT_CLOSE Then
		If MsgBox(0x24, "", $LANG_SAVECHANGES) <> 6 Then Exit;
	EndIf
	
	_GUICtrlListBox_SetCurSel($extList, -1);
	extList_SelectedIndexChanged();
	
	Local $handle = FileOpen($DATA_DIR & "\assoc.ini", 2);
	
	Local $i;
	For $i = 0 To _GUICtrlListBox_GetCount($extList) - 1
		FileWriteLine($handle, "[" & _GUICtrlListBox_GetText($extList, $i) & "]");
		
		If $fileIcons[$i + 1] <> "default.ico" Then
			FileWriteLine($handle, "icon=" & $fileIcons[$i + 1]);
		EndIf
		If $fileExecs[$i + 1] <> "" Then
			FileWriteLine($handle, "exe=" & $fileExecs[$i + 1]);
		EndIf
		If $fileStarts[$i + 1] <> "" Then
			FileWriteLine($handle, "start=" & $fileStarts[$i + 1]);
		EndIf
		
		FileWriteLine($handle, "");
	Next
	FileClose($handle);
	
	Exit(0);
EndFunc

Func extList_SelectedIndexChanged()
	Dim $currentIndex = _GUICtrlListBox_GetCurSel($extList);
	
	If $index <> $LB_ERR Then
		$fileIcons[$index + 1] = $iconFile;
		$fileExecs[$index + 1] = GUICtrlRead($execTextBox);
		$fileStarts[$index + 1] = GUICtrlRead($startTextBox);
	EndIf
	
	$index = $currentIndex;
	
	If $currentIndex == $LB_ERR Then
		GUICtrlSetData($execTextBox, "");
		GUICtrlSetData($startTextBox, "");
		GUICtrlSetState($iconPreviewCtrl, $GUI_HIDE);
		_GUICtrlComboBox_SetCurSel($iconCombo, $CB_ERR);
		GUICtrlSetState($deleteExtButton, $GUI_DISABLE);
		GUICtrlSetState($iconCombo, $GUI_DISABLE)
		GUICtrlSetState($execBrowseButton, $GUI_DISABLE);
		GUICtrlSetState($execClearButton, $GUI_DISABLE);
		GUICtrlSetState($startBrowseButton, $GUI_DISABLE);
		GUICtrlSetState($startClearButton, $GUI_DISABLE);
		Return;
	EndIf
	GUICtrlSetState($deleteExtButton, $GUI_ENABLE);
	GUICtrlSetState($iconCombo, $GUI_ENABLE);
	GUICtrlSetState($execBrowseButton, $GUI_ENABLE);
	GUICtrlSetState($execClearButton, $GUI_ENABLE);
	GUICtrlSetState($startBrowseButton, $GUI_ENABLE);
	GUICtrlSetState($startClearButton, $GUI_ENABLE);
	GUICtrlSetState($iconPreviewCtrl, $GUI_SHOW);
	
	$index = $currentIndex;
	
	$iconFile = $fileIcons[$currentIndex + 1];
	GUICtrlSetData($execTextBox, $fileExecs[$currentIndex + 1]);
	GUICtrlSetData($startTextBox, $fileStarts[$currentIndex + 1]);
	_GUICtrlComboBox_SelectString($iconCombo, $iconFile);
	
	iconCombo_SelectedIndexChanged();
	
EndFunc

Func iconCombo_SelectedIndexChanged()
	Local $icon;
	_GUICtrlComboBox_GetLBText($iconCombo, _GUICtrlComboBox_GetCurSel($iconCombo), $icon);
	GUICtrlSetImage($iconPreviewCtrl, GetAssocIconFromFileName($icon), 0);
	$iconFile = $icon;
EndFunc

Func installIcon_Click()
	Local $filename = FileOpenDialog("", DriveOf(@ScriptDir), $LANG_ICONFILES & " (*.ico)", 1 + 4);
	If @error Then Return;
	
	Local $fileNames = StringSplit($filename, "|");
	Local $i;
	
	If $fileNames[0] = 1 Then
		Local $drive, $path, $filename, $ext;
		_PathSplit($fileNames[1], $drive, $path, $filename, $ext);
		
		$fileNames[0] += 1;
		$fileNames[1] = $drive & $path;
		_ArrayAdd($fileNames, $filename & $ext);
	EndIf
	
	
	For $i = 2 To $fileNames[0]
		Local $overwrite = 0;
		If FileExists($DEFAULT_THEME_DIR & "\assoc\" & $fileNames[$i]) Then
			If MsgBox(0x44, "", StringFormat($LANG_OVERWRITEICON, $fileNames[$i])) = 6 Then $overwrite = 1;
		EndIf
		
		If FileCopy($fileNames[1] & "\" & $fileNames[$i], $DEFAULT_THEME_DIR & "\assoc\", $overwrite) Then
			_GUICtrlComboBox_AddString($iconCombo, $fileNames[$i]);
		Else
			MsgBox(16, $LANG_ERROR, $LANG_CANTINSTALLICON);
		EndIf
	Next
EndFunc

Func execBrowseButton_Click()
	Dim $filename = FileOpenDialog($LANG_BROWSEFOREXECUTABLE, @ScriptDir & "\..\..\..\", $LANG_EXECUTABLE & " (*.exe;*.a3x;*.au3)", 1);
	If @error Then Return;
	
	If DriveOf($filename) <> DriveOf(@ScriptDir) Then
		MsgBox(16, $LANG_ERROR, $LANG_THEEXECUTABLEMUSTBEONTHESAMEDRIVEASXENON);
		Return;
	EndIf
	
	$filename = StringReplace($filename, @ScriptDir, "|XEDIR|")
	
	Local $drive, $folder, $file, $ext;
	_PathSplit($filename, $drive, $folder, $file, $ext);
	
	GUICtrlSetData($execTextBox, $folder & $file & $ext);
EndFunc

Func startBrowseButton_Click()
	Dim $filename = FileOpenDialog($LANG_BROWSEFOREXECUTABLE, @ScriptDir & "\..\..\..\", $LANG_EXECUTABLE & " (*.exe;*.a3x;*.au3)", 1);
	If @error Then Return;
	
	If DriveOf($filename) <> DriveOf(@ScriptDir) Then
		MsgBox(16, $LANG_ERROR, $LANG_THEEXECUTABLEMUSTBEONTHESAMEDRIVEASXENON);
		Return;
	EndIf
	
	$filename = StringReplace($filename, @ScriptDir, "|XEDIR|")
	
	Local $drive, $folder, $file, $ext;
	_PathSplit($filename, $drive, $folder, $file, $ext);
	
	GUICtrlSetData($startTextBox, $folder & $file & $ext);
EndFunc

Func addExtButton_Click()
	Dim $ext = InputBox($LANG_ENTERFILEEXTENSION, "eg. png  .png", "", " M");
	If @error Then Return;
 	If Not StringRegExp($ext, "\.?[a-zA-Z1-9_\-]") Then Return;
	If StringLeft($ext, 1) == '.' Then
		$tmpExt = StringTrimLeft($ext, 1);
	Else
		$tmpExt = $ext;
	EndIf
	If _GUICtrlListBox_FindString($extList, $ext) <> -1 Then
		Return;
	EndIf
	GUICtrlSetState($iconCombo, $GUI_ENABLE);
	GUICtrlSetState($execBrowseButton, $GUI_ENABLE);
	GUICtrlSetState($execClearButton, $GUI_ENABLE);
	GUICtrlSetState($startBrowseButton, $GUI_ENABLE);
	GUICtrlSetState($startClearButton, $GUI_ENABLE);
	GUICtrlSetState($confirmAddButton, $GUI_SHOW);
	GUICtrlSetState($cancelButton, $GUI_SHOW);
	GUICtrlSetState($extList, $GUI_DISABLE);
	GUICtrlSetState($addExtButton, $GUI_DISABLE);
	GUICtrlSetState($deleteExtButton, $GUI_DISABLE);
	
	GUICtrlSetData($execTextBox, "");
	GUICtrlSetData($startTextBox, "");
	
	_GUICtrlComboBox_SetCurSel($iconCombo, -1);
	iconCombo_SelectedIndexChanged();
	
EndFunc

Func deleteExtButton_Click()
	Dim $currentIndex = _GUICtrlListBox_GetCurSel($extList);
	If $currentIndex == $LB_ERR Then Return;
	_ArrayDelete($fileIcons, $currentIndex);
	_ArrayDelete($fileExecs, $currentIndex);
	_ArrayDelete($fileStarts, $currentIndex);
	_GUICtrlListBox_DeleteString($extList, $currentIndex);
	$index = $LB_ERR;
	_GUICtrlListBox_SetCurSel($extList, -1);
	GUICtrlSetState($deleteExtButton, $GUI_DISABLE);
	GUICtrlSetState($iconCombo, $GUI_DISABLE)
	GUICtrlSetState($execBrowseButton, $GUI_DISABLE);
	GUICtrlSetState($execClearButton, $GUI_DISABLE);
	GUICtrlSetState($startBrowseButton, $GUI_DISABLE);
	GUICtrlSetState($startClearButton, $GUI_DISABLE);
EndFunc

Func confirmAddButton_Click()
	_GUICtrlListBox_AddString($extList, $tmpExt);
	_ArrayAdd($fileIcons, GUICtrlRead($iconCombo));
	_ArrayAdd($fileExecs, GUICtrlRead($execTextBox));
	_ArrayAdd($fileStarts, GUICtrlRead($startTextBox));
	
	GUICtrlSetState($confirmAddButton, $GUI_HIDE);
	GUICtrlSetState($cancelButton, $GUI_HIDE);
	GUICtrlSetState($extList, $GUI_ENABLE);
	GUICtrlSetState($addExtButton, $GUI_ENABLE);
	GUICtrlSetState($deleteExtButton, $GUI_ENABLE);
EndFunc

Func cancelButton_Click()
	GUICtrlSetState($iconCombo, $GUI_DISABLE);
	GUICtrlSetState($execBrowseButton, $GUI_DISABLE);
	GUICtrlSetState($execClearButton, $GUI_DISABLE);
	GUICtrlSetState($startBrowseButton, $GUI_DISABLE);
	GUICtrlSetState($startClearButton, $GUI_DISABLE);
	GUICtrlSetState($confirmAddButton, $GUI_HIDE);
	GUICtrlSetState($cancelButton, $GUI_HIDE);
	GUICtrlSetState($extList, $GUI_ENABLE);
	GUICtrlSetState($addExtButton, $GUI_ENABLE);
	GUICtrlSetState($deleteExtButton, $GUI_ENABLE);
EndFunc

Func execClearButton_Click()
	GUICtrlSetData($execTextBox, "");
EndFunc

Func startClearButton_Click()
	GUICtrlSetData($startTextBox, "");
EndFunc

Func cancelAllButton_Click()
	Exit;
EndFunc