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
#AutoIt3Wrapper_outfile_type=a3x
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#NoTrayIcon

#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <File.au3>

Opt("GUIOnEventMode", 1);


#include "Constants.au3"

Const $LANG_INIFILE = $LANG_DIR & "\" & $LANG_INI;

Const $LANG_PROPERTIES = IniRead($LANG_INIFILE, "PROPERTIES", "PROPERTIES", "Properties");
Const $LANG_PROPERTY = IniRead($LANG_INIFILE, "PROPERTIES", "PROPERTY", "Property");
Const $LANG_VALUE = IniRead($LANG_INIFILE, "PROPERTIES", "VALUE", "Value");
Const $LANG_NAME = IniRead($LANG_INIFILE, "PROPERTIES", "NAME", "Name");
Const $LANG_FILESYSTEM = IniRead($LANG_INIFILE, "PROPERTIES", "FILESYSTEM", "File System");
Const $LANG_VOLUMELABEL = IniRead($LANG_INIFILE, "PROPERTIES", "VOLUMELABEL", "Volume Label");
Const $LANG_SERIALNUMBER = IniRead($LANG_INIFILE, "PROPERTIES", "SERIALNUMBER", "Serial Number");
Const $LANG_TOTALSPACE = IniRead($LANG_INIFILE, "PROPERTIES", "TOTALSPACE", "Total Space");
Const $LANG_FREESPACE = IniRead($LANG_INIFILE, "PROPERTIES", "FREESPACE", "Free Space");
Const $LANG_Status = IniRead($LANG_INIFILE, "PROPERTIES", "STATUS", "Status");
Const $LANG_SIZE = IniRead($LANG_INIFILE, "PROPERTIES", "SIZE", "Size");
Const $LANG_TRUE = IniRead($LANG_INIFILE, "PROPERTIES", "TRUE", "True");
Const $LANG_FALSE = IniRead($LANG_INIFILE, "PROPERTIES", "FALSE", "False");
Const $LANG_HIDDEN = IniRead($LANG_INIFILE, "PROPERTIES", "HIDDEN", "Hidden");
Const $LANG_READONLY = IniRead($LANG_INIFILE, "PROPERTIES", "READONLY", "Read Only");
Const $LANG_SYSTEM = IniRead($LANG_INIFILE, "PROPERTIES", "SYSTEM", "System");
Const $LANG_DATEMODIFIED = IniRead($LANG_INIFILE, "PROPERTIES", "DATEMODIFIED", "Date Modified");
Const $LANG_DATECREATED = IniRead($LANG_INIFILE, "PROPERTIES", "DATECREATED", "Date Created");
Const $LANG_DATEACCESSED = IniRead($LANG_INIFILE, "PROPERTIES", "DATEACCESSED", "Date Accessed");


Func ShowPropertiesWindow($file)
	
	Local $properties = GUICreate("Properties", 300, 400, Default, Default, Default, Default);
	GUISetOnEvent($GUI_EVENT_CLOSE, "props_Close", $properties);
	
	Local $listView = GUICtrlCreateListView("Property|Value", 0, 0, 300, 400);
	_GUICtrlListView_SetColumnWidth($listView, 0, 100);
	_GUICtrlListView_SetColumnWidth($listView, 1, 170);
	
	If DriveGetDrive(DriveOf($file)) <> "" And Not FileExists($file) Then
		Local $index;
		
		$file = DriveOf($file);
		$index = _GUICtrlListView_InsertItem($listView, $LANG_NAME);
		_GUICtrlListView_SetItemText($listView, $index, $file, 1);
		
		
		Local $filesystem = DriveGetFileSystem($file);
		If IsString($filesystem) Then
			$index = _GUICtrlListView_InsertItem($listView, $LANG_FILESYSTEM);
			_GUICtrlListView_SetItemText($listView, $index, $filesystem, 1);
		EndIf
		
		
		Local $volumelabel = DriveGetLabel($file);
		If @error Then $volumelabel = "";
		$index = _GUICtrlListView_InsertItem($listView, $LANG_VOLUMELABEL);
		_GUICtrlListView_SetItemText($listView, $index, $volumelabel, 1);
		
		
		Local $serialno = DriveGetSerial($file);
		If Not @error Then
			$index = _GUICtrlListView_InsertItem($listView, $LANG_SERIALNUMBER);
			_GUICtrlListView_SetItemText($listView, $index, $serialno, 1);
		EndIf
		
		
		Local $totalSpace = DriveSpaceTotal($file);
		If Not @error Then
			$index = _GUICtrlListView_InsertItem($listView, $LANG_TOTALSPACE);
			_GUICtrlListView_SetItemText($listView, $index, Round($totalSpace, 2), 1);
		EndIf
		
		Local $freeSpace = DriveSpaceFree($file);
		If Not @error Then
			$index = _GUICtrlListView_InsertItem($listView, $LANG_FREESPACE);
			_GUICtrlListView_SetItemText($listView, $index, Round($freeSpace, 2), 1);
		EndIf
		
		_GUICtrlListView_InsertItem($listView, $LANG_Status);
		_GUICtrlListView_SetItemText($listView, $index, DriveStatus($file), 1);
		
		
	ElseIf StringInStr(FileGetAttrib($file), "D") Then
		Local $attribs = FileGetAttrib($file);
		Local $dateModified = FileGetTime($file, 0);
		Local $dateCreated = FileGetTime($file, 1);
		Local $dateAccessed = FileGetTime($file, 2);
		
		
		$index = _GUICtrlListView_InsertItem($listView, $LANG_NAME);
		_GUICtrlListView_SetItemText($listView, $index, $file, 1);
		
		$index = _GUICtrlListView_InsertItem($listView, $LANG_SIZE);
		_GUICtrlListView_SetItemText($listView, $index, Round(DirGetSize($file) / 1024, 2) & " KB", 1);
		
		
		$index = _GUICtrlListView_InsertItem($listView, $LANG_DATEMODIFIED);
		_GUICtrlListView_SetItemText($listView, $index, TimeFormat($dateModified), 1);
		
		$index = _GUICtrlListView_InsertItem($listView, $LANG_DATECREATED);
		_GUICtrlListView_SetItemText($listView, $index, TimeFormat($dateCreated), 1);
		
		$index = _GUICtrlListView_InsertItem($listView, $LANG_DATEACCESSED);
		_GUICtrlListView_SetItemText($listView, $index, TimeFormat($dateAccessed), 1);
		
		
		$index = _GUICtrlListView_InsertItem($listView, $LANG_READONLY);
		If StringInStr($attribs, "R") Then
			_GUICtrlListView_SetItemText($listView, $index, $LANG_TRUE, 1);
		Else
			_GUICtrlListView_SetItemText($listView, $index, $LANG_FALSE, 1);
		EndIf
		
		$index = _GUICtrlListView_InsertItem($listView, $LANG_SYSTEM);
		If StringInStr($attribs, "S") Then
			_GUICtrlListView_SetItemText($listView, $index, $LANG_TRUE, 1);
		Else
			_GUICtrlListView_SetItemText($listView, $index, $LANG_FALSE, 1);
		EndIf
		
		$index = _GUICtrlListView_InsertItem($listView, $LANG_HIDDEN);
		If StringInStr($attribs, "H") Then
			_GUICtrlListView_SetItemText($listView, $index, $LANG_TRUE, 1);
		Else
			_GUICtrlListView_SetItemText($listView, $index, $LANG_FALSE, 1);
		EndIf
		
	Else
		Local $attribs = FileGetAttrib($file);
		Local $dateModified = FileGetTime($file, 0);
		Local $dateCreated = FileGetTime($file, 1);
		Local $dateAccessed = FileGetTime($file, 2);
		
		
		$index = _GUICtrlListView_InsertItem($listView, $LANG_NAME);
		_GUICtrlListView_SetItemText($listView, $index, $file, 1);
		
		$index = _GUICtrlListView_InsertItem($listView, $LANG_SIZE);
		_GUICtrlListView_SetItemText($listView, $index, Round(FileGetSize($file) / 1024, 2) & " KB", 1);
		
		
		$index = _GUICtrlListView_InsertItem($listView, $LANG_DATEMODIFIED);
		_GUICtrlListView_SetItemText($listView, $index, TimeFormat($dateModified), 1);
		
		$index = _GUICtrlListView_InsertItem($listView, $LANG_DATECREATED);
		_GUICtrlListView_SetItemText($listView, $index, TimeFormat($dateCreated), 1);
		
		$index = _GUICtrlListView_InsertItem($listView, $LANG_DATEACCESSED);
		_GUICtrlListView_SetItemText($listView, $index, TimeFormat($dateAccessed), 1);
		
		
		$index = _GUICtrlListView_InsertItem($listView, $LANG_READONLY);
		If StringInStr($attribs, "R") Then
			_GUICtrlListView_SetItemText($listView, $index, $LANG_TRUE, 1);
		Else
			_GUICtrlListView_SetItemText($listView, $index, $LANG_FALSE, 1);
		EndIf
		
		$index = _GUICtrlListView_InsertItem($listView, $LANG_SYSTEM);
		If StringInStr($attribs, "S") Then
			_GUICtrlListView_SetItemText($listView, $index, $LANG_TRUE, 1);
		Else
			_GUICtrlListView_SetItemText($listView, $index, $LANG_FALSE, 1);
		EndIf
		
		$index = _GUICtrlListView_InsertItem($listView, $LANG_HIDDEN);
		If StringInStr($attribs, "H") Then
			_GUICtrlListView_SetItemText($listView, $index, $LANG_TRUE, 1);
		Else
			_GUICtrlListView_SetItemText($listView, $index, $LANG_FALSE, 1);
		EndIf
		
		Local $versionInfoStrs[12] = ["Comments", "InternalName", "ProductName", "CompanyName", "LegalCopyright", "ProductVersion", _
				"FileDescription", "LegalTrademarks", "PrivateBuild", "FileVersion", "OriginalFilename", "SpecialBuild"];
		Local $i;
		For $i = 0 To 11
			Local $verInfo = FileGetVersion($file, $versionInfoStrs[$i]);
			If @error Then ContinueLoop;
			$index = _GUICtrlListView_InsertItem($listView, """" & $versionInfoStrs[$i] & """");
			_GUICtrlListView_SetItemText($listView, $index, $verInfo, 1);
		Next
	EndIf
	
	GUISetState(@SW_SHOW, $properties);
	
EndFunc

Func props_Close()
	Exit(0);
EndFunc
If $CmdLine[0] < 1 Then Exit;
Dim $startIndex = 1;
If $CmdLine[1] = "/AutoIt3ExecuteScript" Then $startIndex += 2;
If DriveGetDrive(DriveOf(_PathFull($CmdLine[$startIndex]))) == "" And Not FileExists($CmdLine[$startIndex]) Then Exit;

ShowPropertiesWindow(_PathFull($CmdLine[$startIndex]));

While True
	Sleep(500);
WEnd

Func TimeFormat($arr)
	If Not IsArray($arr) Then Return "";
	Return StringFormat("%s-%s-%s %s:%s:%s", $arr[0], $arr[1], $arr[2], $arr[3], $arr[4], $arr[5]);
EndFunc