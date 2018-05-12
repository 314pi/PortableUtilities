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

#include <Array.au3>

Dim $__DATA_DIR = EnvGet("XENON_DATA_DIR");
If $__DATA_DIR = "" Then
	If StringLeft(@ScriptDir, StringLen(@ProgramFilesDir)) == @ProgramFilesDir Then
		$__DATA_DIR = @AppDataDir & "\Xenon\";
		If Not IsDir($__DATA_DIR) Then DirCreate($__DATA_DIR);
	Else
		$__DATA_DIR = @ScriptDir;
	EndIf
EndIf
Const $DATA_DIR = $__DATA_DIR;

Dim $__PLUGINS_DIR = EnvGet("XENON_PLUGINS_DIR");
If $__PLUGINS_DIR = "" Then
	If StringLeft(@ScriptDir, StringLen(@ProgramFilesDir)) == @ProgramFilesDir Then
		$__PLUGINS_DIR = @AppDataDir & "\Xenon\plugins\";
		If Not IsDir($__PLUGINS_DIR) Then DirCreate($__PLUGINS_DIR);
	Else
		$__PLUGINS_DIR = @ScriptDir & "\plugins\"
	EndIf
EndIf
Const $PLUGINS_DIR = $__PLUGINS_DIR;

Dim $__LANG_DIR = EnvGet("XENON_LANG_DIR");
If $__LANG_DIR = "" Then
	$__LANG_DIR = $DATA_DIR;
EndIf
Const $LANG_DIR = $__LANG_DIR;

#include "Settings.au3"

Const $THEMES_DIR = @ScriptDir & "\themes";
Dim $CURRENT_THEME_DIR = $THEMES_DIR & "\" & $SETTINGS_IconSet;
Dim $ASSOCICONS_DIR = $THEMES_DIR & "\" & $SETTINGS_IconSet & "\assoc";
Dim $TOOLBAR_DIR = $THEMES_DIR & "\" & $SETTINGS_IconSet & "\toolbar";
Dim $DRIVEICO_DIR = $THEMES_DIR & "\" & $SETTINGS_IconSet & "\drives";
Dim $MENU_DIR = $THEMES_DIR & "\" & $SETTINGS_IconSet & "\menu";
Const $DEFAULT_THEME_DIR = $THEMES_DIR & "\" & IniRead($DATA_DIR & "\themes.ini", "themes", "defaultset", "userdefined");
Const $NEWFILES_DIR = @ScriptDir & "\NewFiles\";

Func IsDir($dir)
	Return StringInStr(FileGetAttrib($dir), "D");
EndFunc

Func DriveOf($dir)
	Local $drive, $path, $file, $ext;
	_PathSplit($dir, $drive, $path, $file, $ext);
	Return $drive;
EndFunc

Func StripDrive($dir)
	Local $drive, $path, $file, $ext;
	_PathSplit($dir, $drive, $path, $file, $ext);
	Return $path & $file & $ext;
EndFunc



Func GetAssocIconFromFileName($icon)
	Local $test = $ASSOCICONS_DIR & "\" & $icon;
	If FileExists($test) Then
		Return $test;
	EndIf
	
	Local $test = $DEFAULT_THEME_DIR & "\assoc\" & $icon;
	If FileExists($test) Then
		Return $test;
	EndIf
	
	If $icon <> "default.ico" Then
		Return GetAssocIconFromFileName("default.ico");
	Else
		Return "";
	EndIf
EndFunc
	
Func GetFolderIconForCurTheme()
	Local $test = $CURRENT_THEME_DIR & "\folder.ico";
	If FileExists($test) Then
		Return $test;
	Else
		Return $DEFAULT_THEME_DIR & "\folder.ico";
	EndIf
EndFunc

Func GetDriveIcon($icon)
	Local $test = $DRIVEICO_DIR & "\" & $icon;
	If FileExists($test) Then
		Return $test;
	Else
		Return $DEFAULT_THEME_DIR & "\drives\" & $icon;
	EndIf
EndFunc