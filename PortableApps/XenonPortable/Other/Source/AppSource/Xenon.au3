#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile_type=a3x
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
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
	
	One Exception:
		Small snippets of code may be used from Xenon withouth subjecting
		your code to the GNU Lesser General Public License if
			a) The code borrowed does not include more than four (4) functions.
			and
			b) The application that this code will be used in is not a file browser. MI3 Software will decide if the application is a file manager.
	
#ce


#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <MenuConstants.au3>
#include <GuiListView.au3>
#include <GuiTreeView.au3>
#include <GuiListBox.au3>
#include <GuiTab.au3>
#include <GuiMenu.au3>
#include <File.au3>
#include <Array.au3>
#include <Misc.au3>

#include "Dialogs.au3"
#include "Constants.au3"
#include "Sorts.au3"

Opt("GUIOnEventMode", 1);
Opt("GUICloseOnESC", 0);

;Const $WM_NOTIFY = 78;
;Const $NM_DBLCLK = -3;

Const $WM_DROPFILES = 0x233;
Dim $gaDropFiles[1];

Const $MF_BYCOMMAND = 0x00000000;
;Const $MF_BYPOSITION = 0x00000400;
Const $IMAGE_BITMAP = 0
Const $LR_LOADMAP3DCOLORS = 0x00001000
Const $LR_LOADFROMFILE = 0x0010

Const $WM_MBUTTONDOWN = 0x0207;


Dim $startDir = DriveOf(@ScriptDir) & "\" & $SETTINGS_HomePage;

If $CmdLine[0] > 0 Then
	If $CmdLine[1] <> "/AutoIt3ExecuteScript" Then
		$startDir = $CmdLine[1];
	Else
		If $CmdLine[0] > 2 Then $startDir = $CmdLine[3];
	EndIf
EndIf


Dim $cutting = 0;
Dim $last_icon = 1;
Dim $Sort_Descending[3];
Dim $hasOverloaded = True;
Dim $curCol = 0;
Dim $curDirection = 1;
Dim $curSet;
Dim $disableTreeViewEvents = 0;

#include "lang.au3"


Dim $dir = 0;
Dim $dirs[1] = [0];
Dim $history[1] = [0];
Dim $forward[1] = [0];
Dim $histories[1] = [0];
Dim $forwards[1] = [0];
Dim $curTab;
Dim $lastRtClickOnTab = 0;
Dim $msgLvDblClk = False;
Dim $msgTvClk = 0;
Dim $msgTvClkAddToHistory = True;


Dim $user32 = DllOpen("user32.dll");

#include "gui.au3"

AddTab($startDir);

Dim $lastPressedMid = False;
Dim $lastPressedEnter = False;
While True
	Sleep(90);
	If WinActive($window) Then
		If _IsPressed("04", $user32) And Not $lastPressedMid Then
			mouseMiddleButton_Clicked();
			$lastPressedMid = True;
		Else
			$lastPressedMid = False;
		EndIf
		
		If _IsPressed("0D", $user32) And Not $lastPressedEnter Then
			enter_Pressed();
			$lastPressedEnter = True;
		Else
			$lastPressedEnter = False;
		EndIf
	EndIf
	
	If $msgLvDblClk Then
		Open();
		$msgLvDblClk = False;
	EndIf
	
	If Not IsInt($msgTvClk) Then
		LoadDir($msgTvClk, $msgTvClkAddToHistory);
		$msgTvClk = 0;
	EndIf
WEnd

#include "window_events.au3"
#include "reload.au3"
#include "icons.au3"
#include "file_clicked.au3"
#include "menu_events.au3"
#include "IconGUI.au3"
#include "bookmarks.au3"

Func Open()
	Local $lvItems = _GUICtrlListView_GetSelectedIndices($listView, 1);
	If IsArray($lvItems) Then
		Local $i;
		For $i = 1 To $lvItems[0]
			Local $file = _GUICtrlListView_GetItemText($listView, $lvItems[$i], 0);
			If $dir == $LANG_COMPUTER Then
				DriveItemClick(DriveOf(_GUICtrlListView_GetItemText($listView, $lvItems[$i], 0)));
			ElseIf IsDir($dir & $file) Then
				FolderItemClick($file);
			Else
				FileItemClick($file);
			EndIf
		Next
	EndIf
EndFunc

Func Start()
	Local $lvItems = _GUICtrlListView_GetSelectedIndices($listView, 1);
	If IsArray($lvItems) Then
		Local $i;
		For $i = 1 To $lvItems[0]
			Local $file = _GUICtrlListView_GetItemText($listView, $lvItems[$i], 0);
			If $dir == $LANG_COMPUTER Then
				AddTab(StringLeft(_GUICtrlListView_GetItemText($listView, $lvItems[$i], 0), 2));
			ElseIf IsDir($dir & $file) Then
				AddTab($dir & $file);
			Else
				FileItemClick($file, True);
			EndIf
		Next
	EndIf
EndFunc

Func ListView_Click()
	$curSet = False;
	_WinAPI_InvalidateRect(GUICtrlGetHandle($listView), 0, 1);
EndFunc

Func ListView_Sort($hwnd, $item1, $item2, $col)
	
	If Not $curSet Then
		If $col = $curCol Then
			$curDirection = -$curDirection;
		Else
 			$curDirection = -1;
		EndIf
		$curCol = $col;
		$curSet = True;
	EndIf
	
	Local $lvFind1 = DllStructCreate($tagLVFINDINFO);
	DllStructSetData($lvFind1, "Flags", $LVFI_PARAM);
	DllStructSetData($lvFind1, "Param", $item1);
	
	Local $lvFind2 = DllStructCreate($tagLVFINDINFO);
	DllStructSetData($lvFind2, "Flags", $LVFI_PARAM);
	DllStructSetData($lvFind2, "Param", $item2);
	
	Local $index1 = GUICtrlSendMsg($hwnd, $LVM_FINDITEM, -1, DllStructGetPtr($lvFind1));
	Local $index2 = GUICtrlSendMsg($hwnd, $LVM_FINDITEM, -1, DllStructGetPtr($lvFind2));
	
	Local $result = 1;
	
	$lvFind1 = 0;
	$lvFind2 = 0;
	
	Local $item1Text = _GUICtrlListView_GetItemText($hwnd, $index1, $col);
	Local $item2Text = _GUICtrlListView_GetItemText($hwnd, $index2, $col);
	
	
	Local $item1FullPath;
	Local $item2FullPath;
	
	If $dir == $LANG_COMPUTER Then
		$item1FullPath = DriveOf(_GUICtrlListView_GetItemText($hwnd, $index1));
		$item2FullPath = DriveOf(_GUICtrlListView_GetItemText($hwnd, $index2));
	Else
		$item1FullPath = $dir & _GUICtrlListView_GetItemText($hwnd, $index1);
		$item2FullPath = $dir & _GUICtrlListView_GetItemText($hwnd, $index2);
	EndIf
	
	Local $item1IsDir = IsDir($item1FullPath);
	Local $item2IsDir = IsDir($item2FullPath);
	
	Switch $col
		Case 0
			If Not $item1IsDir And $item2IsDir Then
 				$result = $curDirection;
			ElseIf $item1IsDir And Not $item2IsDir Then
 				$result = -$curDirection;
			Else
 				$result = _Iif($item1Text > $item2Text, -1, 1);
			EndIf
			
		Case 1
			If Not $item1IsDir And $item2IsDir Then
 				$result = $curDirection;
			ElseIf $item1IsDir And Not $item2IsDir Then
 				$result = -$curDirection;
			ElseIf $item1IsDir And $item2IsDir Then
 				$result = _Iif(_GUICtrlListView_GetItemText($hwnd, $index1) > _GUICtrlListView_GetItemText($hwnd, $index2), -1, 1);
			Else
				$result = _Iif(Int(StringTrimRight($item1Text, 2)) > Int(StringTrimRight($item2Text, 2)), -1, 1);
			EndIf
		Case 2
			If Not $item1IsDir And $item2IsDir Then
 				$result = $curDirection;
			ElseIf $item1IsDir And Not $item2IsDir Then
 				$result = -$curDirection;
			Else
				$result = _Iif($item1Text > $item2Text, -1, 1);
			EndIf
	EndSwitch
	
	$result *= $curDirection;
	
	Return $result;
EndFunc

#include "toolbar_events.au3"
#include "hotkeys.au3"
#include "utils.au3"
#include "wm_handlers.au3"