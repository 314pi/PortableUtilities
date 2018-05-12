#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile_type=a3x
#AutoIt3Wrapper_outfile=Search.a3x
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
	
	One Exeception:
		Small snippets of code may be used from Xenon withouth subjecting
		your code to the GNU Lesser General Public License if
			a) The code borrowed does not include more than four (4) functions.
			and
			b) The application that this code will be used in is not a file browser.
	
#ce

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <GuiStatusBar.au3>
#include <ButtonConstants.au3>
#include <File.au3>
#include <Array.au3>


;Const $WM_GETMINMAXINFO = 0x24;
;Const $WM_NOTIFY = 78;
;Const $NM_DBLCLK = -3;


#include "Constants.au3"

Const $LANG_INIFILE = $LANG_DIR & "\" & IniRead($DATA_DIR & "\settings.ini", "Xenon", "language", "lang_en-us.ini");


Const $LANG_SEARCH = IniRead($LANG_INIFILE, "SEARCH", "SEARCH", "Search");
Const $LANG_CANCEL = IniRead($LANG_INIFILE, "SEARCH", "CANCEL", "Cancel");
Const $LANG_ROOTDIRECTORY = IniRead($LANG_INIFILE, "SEARCH", "ROOTDIRECTORY", "Root Directory");
Const $LANG_BROWSE = IniRead($LANG_INIFILE, "SEARCH", "BROWSE", "Browse...");
Const $LANG_QUERY = IniRead($LANG_INIFILE, "SEARCH", "QUERY", "Query");
Const $LANG_SEARCHINSIDEFILES = IniRead($LANG_INIFILE, "SEARCH", "SEARCHINSIDEFILES", "Search inside files");
Const $LANG_FILENAME = IniRead($LANG_INIFILE, "SEARCH", "FILENAME", "Filename");
Const $LANG_DIRECTORY = IniRead($LANG_INIFILE, "SEARCH", "DIRECTORY", "Directory");
Const $LANG_SELECTFOLDER = IniRead($LANG_INIFILE, "SEARCH", "SELECTFOLDER", "Select Folder");

Global $dir;


Dim $searching;


Dim $window = GUICreate("Xenon " & $LANG_SEARCH, 650, 450, Default, Default, BitOR($WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_THICKFRAME));

Dim $rootLabel = GUICtrlCreateLabel($LANG_ROOTDIRECTORY, 10, 10);
Dim $rootTextBox = GUICtrlCreateInput(DriveOf(@ScriptDir) & "\", 10, 30, 350);
Dim $rootBrowseButton = GUICtrlCreateButton($LANG_BROWSE, 365, 30, 85, 20);

Dim $queryLabel = GUICtrlCreateLabel($LANG_QUERY, 10, 70);
Dim $queryTextBox = GUICtrlCreateInput("", 10, 85, 200);

Dim $searchInsideFilesCheckBox = GUICtrlCreateCheckbox($LANG_SEARCHINSIDEFILES, 540, 30);
GUICtrlSetState($searchInsideFilesCheckBox, $GUI_CHECKED);

Dim $searchButton = GUICtrlCreateButton($LANG_SEARCH, 10, 115, 73, Default, $BS_DEFPUSHBUTTON);
Dim $cancelButton = GUICtrlCreateButton($LANG_CANCEL, 90, 115, 73);

Dim $resultsListView = GUICtrlCreateListView($LANG_FILENAME & "|" & $LANG_DIRECTORY, 0, 150, 648, 255);
_GUICtrlListView_SetColumnWidth($resultsListView, 0, 400);
_GUICtrlListView_SetColumnWidth($resultsListView, 1, 220);

Dim $statusBar = _GUICtrlStatusBar_Create($window, -1, "");

GUICtrlSetResizing($rootLabel, $GUI_DOCKALL);
GUICtrlSetResizing($rootTextBox, $GUI_DOCKALL);
GUICtrlSetResizing($rootBrowseButton, $GUI_DOCKALL);
GUICtrlSetResizing($queryLabel, $GUI_DOCKALL);
GUICtrlSetResizing($queryTextBox, $GUI_DOCKALL);
GUICtrlSetResizing($searchButton, $GUI_DOCKALL);
GUICtrlSetResizing($cancelButton, $GUI_DOCKALL);
GUICtrlSetResizing($searchInsideFilesCheckBox, BitOR($GUI_DOCKSIZE, $GUI_DOCKRIGHT, $GUI_DOCKTOP));
GUICtrlSetResizing($resultsListView, $GUI_DOCKBORDERS);
GUICtrlSetResizing($statusBar, BitOR($GUI_DOCKLEFT, $GUI_DOCKBOTTOM, $GUI_DOCKRIGHT));


GUIRegisterMsg($WM_GETMINMAXINFO, "HANDLE_WM_GETMINMAXINFO");
GUIRegisterMsg($WM_NOTIFY, "HANDLE_WM_NOTIFY");

GUISetState(@SW_SHOW, $window);

If $CmdLine[0] >= 2 Then
	If $CmdLine[1] = "/Search" Then
		GUICtrlSetData($rootTextBox, $CmdLine[2]);
		If $CmdLine[0] >= 3 Then
			GUICtrlSetData($queryTextBox, $CmdLine[3]);
			ControlClick($window, "", $searchButton);
		EndIf
	EndIf
EndIf

Func MessageLoop()
	
	Local $msg = GUIGetMsg();
	
	Switch $msg
		
		Case $searchButton
			Search();
			
		Case $cancelButton
			$searching = False;
		
		Case $rootBrowseButton
			Local $pdirName = FileSelectFolder($LANG_SELECTFOLDER, "", GUICtrlRead($rootTextBox))
			If Not @error Then
				GUICtrlSetData($rootTextBox, $pdirName);
			EndIf
		
		Case $GUI_EVENT_RESIZED
			_GUICtrlStatusBar_Resize($statusBar);
			
		Case $GUI_EVENT_MINIMIZE
			_GUICtrlStatusBar_Resize($statusBar);
			
		Case $GUI_EVENT_MAXIMIZE
			_GUICtrlStatusBar_Resize($statusBar);
		
		Case $GUI_EVENT_CLOSE
			Return False;
	EndSwitch
	
	Return True;
	
EndFunc

While MessageLoop();
WEnd
Exit(0);

Func Search()
	GUICtrlSetState($searchButton, $GUI_DISABLE);
	Local $pdir = GUICtrlRead($rootTextBox);
	_GUICtrlListView_DeleteAllItems($resultsListView);
	$searching = True;
	SearchDir($pdir);
	GUICtrlSetState($searchButton, $GUI_ENABLE);
	_GUICtrlStatusBar_SetText($statusBar, "");
EndFunc

Func Cancel()
	$searching = False;
EndFunc

Func SearchDir($pdir)
	Local $searchTerm = GUICtrlRead($queryTextBox);
	Local $searchInFiles = BitAND(GUICtrlRead($searchInsideFilesCheckBox), $GUI_CHECKED) = $GUI_CHECKED;
	
	If $searchTerm == "" Then Return;
	
	Local $search = FileFindFirstFile(Pad($pdir) & "*");
	If $search <> -1 Then
		While $searching
			If Not MessageLoop() Then Exit(0);
			Local $filename = FileFindNextFile($search);
			If @error Then ExitLoop;
			
			_GUICtrlStatusBar_SetText($statusBar, _PathFull($pdir));
			If Not IsDir($pdir & "\" & $filename) Then
				If StringMatch($filename, '*' & $searchTerm & '*', 2) Then
					;GUICtrlCreateListViewItem($filename & "|" & _PathFull($pdir), $resultsListView);
					CreateItem($filename, $pdir);
				ElseIf $searchInFiles Then
					SearchFile(Pad(_PathFull($pdir)), $filename, $searchTerm);
				EndIf
			EndIf
		WEnd
	EndIf
	
	$search = FileFindFirstFile(Pad($pdir) & "*");
	If $search <> -1 Then
		While $searching
			If Not MessageLoop() Then Exit(0);
			Local $filename = FileFindNextFile($search);
			If @error Then ExitLoop;
			
			If IsDir($pdir & "\" & $filename) Then
				SearchDir($pdir & "\" & $filename);
			EndIf
		WEnd
	EndIf
EndFunc

Func SearchFile($pdir, $filename, $searchTerm)
	Local $drive, $path, $file, $ext;
	_PathSplit($filename, $drive, $path, $file, $ext);
	
	Local $text = "";
	
	Local $openoffice_types[3] = [".odt", ".ods", ".odp"];
	Local $textdoc_types[14] = ["", ".txt", ".rtf", ".bat", ".ini", ".xml", ".php", ".asp", ".aspx", ".cs", ".vb", ".au3", ".js", ".vbs"];
	If _ArraySearch($openoffice_types, $ext) <> -1 Then
		Local $tmpFile = @ScriptDir & "\tmp\content.xml";
		ShellExecuteWait(@ScriptDir & "\7za.exe", "x """ & StringReplace($pdir & $filename, """", """""") & """ -o""" & StringReplace(@ScriptDir, """", """""") & "\tmp"" content.xml -y", "", "OPEN", @SW_HIDE);
		Sleep(200);
		
		Local $fp = FileOpen($tmpFile, 0);
		If $fp <> -1 Then
			$text = FileRead($fp);
 			$text = StringRegExpReplace($text, "\<[^>]+\>", " ");
			FileClose($fp);
		EndIf
		
		FileDelete($tmpFile);
	ElseIf _ArraySearch($textdoc_types, $ext) <> -1 Then
		$text = FileRead($pdir & $filename);
	EndIf
	
	If StringMatch($text, '*' & $searchTerm & '*') Then
		CreateItem($filename, $pdir);
	EndIf
	
EndFunc


Func CreateItem($filename, $pdir)
	Local $ctrl = GUICtrlCreateListViewItem($filename & "|" & _PathFull($pdir), $resultsListView);
	Local $icon;
	Local $index;
	
	Global $dir = $pdir;
	GetIcon($pdir & $filename, $icon, $index);
	GUICtrlSetImage($ctrl, $icon, $index);
EndFunc

Func _StringEnvReplace($str)
	Local $arrayStr = StringSplit($str, "%");
	Local $returnVal = "";
	Local $i;
	For $i = 1 To $arrayStr[0]
		If Mod($i, 2) == 1 Then ;; Not part of an envvar.
			$returnVal &= $arrayStr[$i];
		Else ;; An enviroment variable
			If $arrayStr[$i] == "" Then ;; Escaped
				$returnVal &= "%";
			Else
				$returnVal &= EnvGet($arrayStr[$i]);
			EndIf
		EndIf
	Next
	Return $returnVal;
EndFunc

Func Pad($dir)
	Local $lastChar = StringRight($dir, 1);
	If  $lastChar <> '/' And $lastChar <> '\' Then
		Return $dir & '\';
	EndIf
	Return $dir;
EndFunc

;Func IsDir($dir)
;	Return StringInStr(FileGetAttrib($dir), "D");
;EndFunc

Func FileHasIcons($file)
	Return Not _WinAPI_ExtractIconEx($file, -1, 0, 0, 0);
EndFunc

#include "icons.au3"

Func HANDLE_WM_GETMINMAXINFO($hWndGUI, $MsgID, $wParam, $lParam)
	#forceref $MsgID, $wParam
	If $hWndGUI = $window Then; the main GUI-limited
		Local $minmaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)
		DllStructSetData($minmaxinfo, 7, 605); min width
		DllStructSetData($minmaxinfo, 8, 400); min height
		DllStructSetData($minmaxinfo, 9, @DesktopWidth); max width
		DllStructSetData($minmaxinfo, 10, @DesktopHeight); max height
		Return 0
	Else;other dialogs-"no" lower limit
		Return 0
	EndIf
EndFunc   ;==>HANDLE_WM_GETMINMAXINFO

Func HANDLE_WM_NOTIFY($hWndGUI, $MsgID, $wParam, $lParam)
    #forceref $hWndGUI, $MsgID, $wParam
    Local $tagNMHDR, $event
    
    If $wParam = $resultsListView Then
        $tagNMHDR = DllStructCreate("int;int;int", $lParam)
        If @error Then Return
        $event = DllStructGetData($tagNMHDR, 3)
        
		If $event = $NM_DBLCLK Then
			Local $indeces = _GUICtrlListView_GetSelectedIndices($resultsListView, 1);
			If $indeces == $LV_ERR Then
				Return;
			EndIf
			Local $index = $indeces[1];
			
			Local $file = Pad(_GUICtrlListView_GetItemText($resultsListView, $index, 1)) & _GUICtrlListView_GetItemText($resultsListView, $index, 0);
			
			Local $drive, $path, $filename, $ext;
			_PathSplit($file, $drive, $path, $filename, $ext);
			Local $ext2 = StringTrimLeft($ext, 1);
			
			Local $exe = IniRead($DATA_DIR & "\assoc.ini", $ext2, "exe", "");
			
			If $exe == "" Then
				ShellExecute($file);
			Else
				ShellExecute(DriveOf(@ScriptDir) & StringReplace($exe, "|XEDIR|", StringTrimLeft(@ScriptDir, 2)), """" & StringReplace($file, """", """""") & """");
			EndIf
			
		EndIf
    EndIf
EndFunc

;========================
Func StringMatch($s, $p, $Case = 0)
	Local $i, $t, $l, $e, $f = 0
	While StringInStr($p, '*?') Or StringInStr($p, '?*')
		$p = StringReplace($p, '*?', '*')
		$p = StringReplace($p, '?*', '*')
	WEnd
	$t = StringSplit($p, '?');
	For $i = 1 To $t[0]
		$l = $t[$i]
		If $i <> 1 Then $s = StringTrimLeft($s, 1)
		If $l = '' Or $l = '*' Then ContinueLoop
		If $i = $t[0] Then $f = 1
		$e = StringAsterMatch($s, $l, $Case, $f)
		If $e = 0 Then Return 0
		$s = StringTrimLeft($s, $e)
		If $i = $t[0] And StringRight($l, 1) <> '*' And $s <> '' Then Return 0
	Next
	Return 1
EndFunc   ;==>StringMatch

;========================
Func StringAsterMatch($s, $p, $Case, $f = 0)
	Local $i, $t, $l, $r, $b, $e
	$r = 0
	$t = StringSplit($p, '*')
	For $i = 1 To $t[0]
		$l = $t[$i]
		If $l = '' Then ContinueLoop
		If $s = '' Then Return 0
		If $i = $t[0] And $f Then
			$b = StringInStr($s, $l, $Case, -1)
		Else
			$b = StringInStr($s, $l, $Case)
		EndIf
		If $b = 0 Then Return 0
		If $i = 1 And ($b <> 1) Then Return 0
		$e = $b + StringLen($l) - 1
		$s = StringTrimLeft($s, $e)
		$r += $e
	Next
	Return $r
EndFunc   ;==>StringAsterMatch