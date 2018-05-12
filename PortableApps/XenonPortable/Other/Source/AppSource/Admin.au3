#NoTrayIcon
#RequireAdmin
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
	
	One Exeception:
		Small snippets of code may be used from Xenon withouth subjecting
		your code to the GNU Lesser General Public License if
			a) The code borrowed does not include more than four (4) functions.
			and
			b) The application that this code will be used in is not a file browser.
	
#ce

#include <GUIConstantsEx.au3>
#include <String.au3>

Dim $startIndex = 1;
If $CmdLine[$startIndex] = "/AutoIt3ExecuteScript" Then $startIndex += 2;

If @OSVersion = "WIN_VISTA"  Or IsAdmin() Then
	Run(_HexToString($CmdLine[$startIndex]));
Else
	
	#region Lang
	Dim $__DATA_DIR = EnvGet("XENON_DATA_DIR");
	If $__DATA_DIR = "" Then
		If StringLeft(@ScriptDir, StringLen(@ProgramFilesDir)) = @ProgramFilesDir Then
			$__DATA_DIR = @AppDataDir & "\Xenon\" ;
			If Not StringInStr(FileGetAttrib($__DATA_DIR), "D") Then DirCreate($__DATA_DIR);
		Else
			$__DATA_DIR = @ScriptDir;
		EndIf
	EndIf
	Const $DATA_DIR = $__DATA_DIR;
	Dim $__LANG_DIR = EnvGet("XENON_LANG_DIR");
	If $__LANG_DIR = "" Then
		$__LANG_DIR = $DATA_DIR;
	EndIf
	Const $LANG_DIR = $__LANG_DIR;

	Const $LANG_FILE = $LANG_DIR & "\" & IniRead($DATA_DIR & "\settings.ini", "Xenon", "language", "lang_en-US.ini");


	Const $LANG_ENTERAUTH = IniRead($LANG_FILE, "ADMIN", "AUTH", "Authentication");
	Const $LANG_ENTERAUTHMSG = IniRead($LANG_FILE, "ADMIN", "ENTERAUTHMSG", "Enter your Administrator's user name and password.");
	Const $LANG_OK = IniRead($LANG_FILE, "ADMIN", "OK", "&OK");
	Const $LANG_CANCEL = IniRead($LANG_FILE, "ADMIN", "CANCEL", "&Cancel");
	#endregion
	
	Dim $window = GUICreate($LANG_ENTERAUTH, 200, 150);
	Dim $lbl = GUICtrlCreateLabel($LANG_ENTERAUTHMSG, 10, 10);
	Dim $tboxuser = GUICtrlCreateInput("", 10, 40, 180);
	Dim $tboxpass = GUICtrlCreateInput("", 10, 80, 180);
	Dim $okbtn = GUICtrlCreateButton($LANG_OK, 35, 120, 75);
	Dim $cancelbtn = GUICtrlCreateButton($LANG_CANCEL, 115, 120, 75)
	GUISetState(@SW_SHOW, $window);
	
	While True
		Dim $msg = GUIGetMsg();
		
		Switch $msg
			
			Case $GUI_EVENT_CLOSE, $cancelbtn
				Exit;
				
			Case $okbtn
				ExitLoop
				
		EndSwitch
	WEnd
	GUIDelete($window)
	
	RunAs(GUICtrlRead($tboxuser), @ComputerName, GUICtrlRead($tboxpass), 4, _HexToString($CmdLine[$startIndex]));
EndIf