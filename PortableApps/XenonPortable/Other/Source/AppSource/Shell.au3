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
	
	One Exeception:
		Small snippets of code may be used from Xenon withouth subjecting
		your code to the GNU Lesser General Public License if
			a) The code borrowed does not include more than four (4) functions.
			and
			b) The application that this code will be used in is not a file browser.
	
#ce

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <File.au3>
#include <String.au3>
#include <Process.au3>
#include <GuiMenu.au3>

#include "processgetexitcode.au3"

Opt("GUIOnEventMode", 1);

If $CmdLine[0] < 2 Then Exit;


Dim $cancel = False;
Dim $confirm_Result;
Dim $yesToAll = False;
Dim $noToAll = False;
Dim $checkbox;

Enum $MSG_QUIT, $MSG_RETRY, $MSG_ADMIN

#region Lang
Dim $__DATA_DIR = EnvGet("XENON_DATA_DIR");
If $__DATA_DIR = "" Then
	If StringLeft(@ScriptDir, StringLen(@ProgramFilesDir)) == @ProgramFilesDir Then
		$__DATA_DIR = @AppDataDir & "\Xenon\";
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
Const $SETTINGS_PromptOnDelete = IniRead($DATA_DIR & "\settings.ini", "Xenon", "PromptOnDelete", 1);


Const $LANG_DELETECONFIRM = IniRead($LANG_FILE, "SHELL", "DELETECONFIRM", "Delete Confirmation");
Const $LANG_DELETECONFIRMMSG = IniRead($LANG_FILE, "SHELL", "DELETECONFIRMMSG", "Are you sure you want to delete the file %s?");
Const $LANG_DELETINGFILES = IniRead($LANG_FILE, "SHELL", "DELETINGFILES", "Deleting Files");
Const $LANG_ERRORDELETING = IniRead($LANG_FILE, "SHELL", "ERRORDELETING", "Error Deleting");
Const $LANG_ERRORDELETINGMSG = IniRead($LANG_FILE, "SHELL", "ERRORDELETINGMSG", "The file/folder %s could not be deleted.");

Const $LANG_ERRORCOPYING = IniRead($LANG_FILE, "SHELL", "ERRORCOPYING", "Error Copying");
Const $LANG_ERRORCOPYINGMSG = IniRead($LANG_FILE, "SHELL", "ERRORDELETINGMSG", "The file/folder %s could not be copied.");

Const $LANG_ERRORMOVING = IniRead($LANG_FILE, "SHELL", "ERRORMOVING", "Error Moving");
Const $LANG_ERRORMOVINGMSG = IniRead($LANG_FILE, "SHELL", "ERRORMOVINGMSG", "The file/folder %s could not be moved.");

Const $LANG_COPYINGFILES = IniRead($LANG_FILE, "SHELL", "COPYINGFILES", "Copying Files");
Const $LANG_MOVINGFILES = IniRead($LANG_FILE, "SHELL", "MOVINGFILES", "Moving Files");

Const $LANG_REPLACEFILE = IniRead($LANG_FILE, "SHELL", "REPLACEFILE", "Replace File");
Const $LANG_REPLACEFILEMSG = StringReplace(IniRead($LANG_FILE, "SHELL", "REPLACEFILEMSG", "The destination file/folder already exists.\n\nDestination\n%s\nSize: %s\nDate: %s\n\n\nSource\n%s\nSize: %s\nDate: %s\n\nWould you like to replace the destination file/folder?"), "\n", @CRLF);

Const $LANG_CANCEL = IniRead($LANG_FILE, "SHELL", "CANCEL", "&Cancel");

Const $LANG_YES = IniRead($LANG_FILE, "SHELL", "YES", "&Yes");
Const $LANG_NO = IniRead($LANG_FILE, "SHELL", "NO", "&No");
Const $LANG_SAMEFORALL = IniRead($LANG_FILE, "SHELL", "SAMEFORALL", "&Do this for all.");

Const $LANG_ERRORPOSSIBLE = IniRead($LANG_FILE, "SHELL", "ERRORPOSSIBLE", "The file operation could not be completed. This may be because the file is already open, you do not have permission, or some other reason.");
Const $LANG_RETRY = IniRead($LANG_FILE, "SHELL", "RETRY", "&Retry");
Const $LANG_RETRYADMIN = IniRead($LANG_FILE, "SHELL", "RETRYADMIN", "Retry as &Admin");
#endregion

Dim $start = TimerInit();
Dim $startIndex = 1;
If $CmdLine[$startIndex] = "/AutoIt3ExecuteScript" Then $startIndex += 2;

Switch StringLower($CmdLine[$startIndex])
	
	Case "/delete"
		If EnvGet("XeDisablePrompt") == "1" Then $yesToAll = True;
		Local $i;
		Dim $gui = SplashScreen(@ScriptDir & "\shell_delete.jpg");
		For $i = $startIndex + 1 To $CmdLine[0]
			While True
				If Not FileExists($CmdLine[$i]) Then ExitLoop;
				
				If Not Confirm($LANG_DELETECONFIRM, StringFormat($LANG_DELETECONFIRMMSG, $CmdLine[$i])) Then ExitLoop;
				
				Dim $pid = Run(@AutoItExe & " /AutoIt3ExecuteScript """ & @ScriptDir & "\Delete.au3"" """ & $CmdLine[$i] & """");
				Dim $handle = _ProcessOpenHandle($pid);
				
				While ProcessExists($pid) And Not $cancel
					Sleep(200);
				WEnd
				If $cancel Then
					ProcessClose($pid);
					Exit;
				EndIf
				
				Dim $result = _ProcessGetExitCode($pid, $handle);
			
				If Not $result Then
					Switch ErrorMessage($LANG_ERRORDELETING, $LANG_ERRORDELETINGMSG)
						Case $MSG_QUIT
							ExitLoop;
							
						Case $MSG_RETRY
							ContinueLoop;
							
						Case $MSG_ADMIN
							ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & @ScriptDir & "\Admin.a3x"" """ & _StringToHex("""" & @AutoItExe & """ /AutoIt3ExecuteScript """ & @ScriptFullPath & """ /delete """ & $CmdLine[$i] & """") & """");
							ExitLoop;
					EndSwitch
				EndIf
				ExitLoop;
			WEnd
		Next
		GUIDelete($gui);
	
	Case "/copy"
		
		Local $i;
		Dim $gui = SplashScreen(@ScriptDir & "\shell_copy.jpg");
		For $i = $startIndex + 1 To $CmdLine[0] - 1 Step 2
			Dim $src = $CmdLine[$i];
			Dim $dst = $CmdLine[$i + 1];
			While True
				If Not FileExists($src) Then ExitLoop;
				
				Dim $timeSrc = FileGetTime($src);
				Dim $timeDst = FileGetTime($dst);
				
				If $timeSrc <> 0 Then $timeSrc = $timeSrc[0] & "-" & $timeSrc[1] & "-" & $timeSrc[2] & " " & $timeSrc[3] & ":" & $timeSrc[4] & ":" & $timeSrc[5];
				If $timeDst <> 0 Then $timeDst = $timeDst[0] & "-" & $timeDst[1] & "-" & $timeDst[2] & " " & $timeDst[3] & ":" & $timeDst[4] & ":" & $timeDst[5];
				
				If (FileExists($dst) And Not StringInStr(FileGetAttrib($dst), "D")) Then
					If Not Confirm($LANG_REPLACEFILE, StringFormat($LANG_REPLACEFILEMSG, _
							_PathFull($dst), FileGetSize($dst), $timeDst, _
							$src, FileGetSize($src), $timeSrc)) Then
							ExitLoop;
					EndIf
				ElseIf StringInStr(FileGetAttrib($dst), "D") And Not StringInStr(FileGetAttrib($src), "D") Then
					Dim $drive, $folder, $filename, $ext;
					_PathSplit($src, $drive, $folder, $filename, $ext);
					$dst = $dst & "\" & $filename & $ext;
					ContinueLoop;
				ElseIf (StringInStr(FileGetAttrib($src), "D") And StringInStr(FileGetAttrib($dst), "D")) Then
					If Not Confirm($LANG_REPLACEFILE, StringFormat($LANG_REPLACEFILEMSG, _
							$dst, DirGetSize($dst), $timeDst, _
							$src, DirGetSize($src), $timeSrc)) Then
						ExitLoop;
					EndIf
				EndIf
				
				Dim $pid;
				
				;SplashImageOn($LANG_COPYINGFILES, @ScriptDir & "\shell_copy.jpg", 500, 250);
				If StringInStr(FileGetAttrib($src), "D") Then
					If Not StringInStr(FileGetAttrib($dst), "D") And FileExists($dst) Then
						ExitLoop;
					EndIf
					
					;$result = DirCopy(_PathFull($src), _PathFull($dst), 1);
					$pid = Run(@AutoItExe & " /AutoIt3ExecuteScript """ & @ScriptDir & "\Copy.au3"" """ & _PathFull($src) & """ """ & _PathFull($dst) & """");
				Else
					$pid = Run(@AutoItExe & " /AutoIt3ExecuteScript """ & @ScriptDir & "\Copy.au3"" """ & $src & """ """ & $dst & """");
				EndIf
				Dim $handle = _ProcessOpenHandle($pid);
				
				While ProcessExists($pid) And Not $cancel
					Sleep(200);
				WEnd
				If $cancel Then
					ProcessClose($pid);
					Exit;
				EndIf
				
				Dim $result = _ProcessGetExitCode($pid, $handle);
				
				If Not $result Then
					Switch ErrorMessage($LANG_ERRORCOPYING, $LANG_ERRORCOPYINGMSG)
						
						Case $MSG_QUIT
							ExitLoop;
						
						Case $MSG_RETRY
							ContinueLoop;
						
					Case $MSG_ADMIN
							ShellExecuteWait(@AutoItExe, "/AutoIt3ExecuteScript """ & @ScriptDir & "\Admin.a3x"" """ & _StringToHex("""" & @AutoItExe & """ /AutoIt3ExecuteScript """ & @ScriptFullPath & """ /copy """ & $src & """ """ & $dst & """") & """");
							ExitLoop;
						
					EndSwitch
				EndIf
				ExitLoop;
			WEnd
		Next
		GUIDelete($gui);
	
	Case "/move"
		
		Local $i;
		Local $gui = SplashScreen(@ScriptDir & "\shell_move.jpg");
		For $i = $startIndex + 1 To $CmdLine[0] - 1 Step 2
			Dim $src = $CmdLine[$i];
			Dim $dst = $CmdLine[$i + 1];
			While True
				If Not FileExists($src) Then ExitLoop;
				
				Dim $timeSrc = FileGetTime($src);
				Dim $timeDst = FileGetTime($dst);
				
				If $timeSrc <> 0 Then $timeSrc = $timeSrc[0] & "-" & $timeSrc[1] & "-" & $timeSrc[2] & " " & $timeSrc[3] & ":" & $timeSrc[4] & ":" & $timeSrc[5];
				If $timeDst <> 0 Then $timeDst = $timeDst[0] & "-" & $timeDst[1] & "-" & $timeDst[2] & " " & $timeDst[3] & ":" & $timeDst[4] & ":" & $timeDst[5];
				
				If (FileExists($dst) And Not StringInStr(FileGetAttrib($dst), "D")) Then
					If Not Confirm($LANG_REPLACEFILE, StringFormat($LANG_REPLACEFILE, _
							$dst, FileGetSize($dst), $timeDst, _
							$src, FileGetSize($src), $timeSrc)) Then
						ExitLoop;
					EndIf
				ElseIf StringInStr(FileGetAttrib($dst), "D") And Not StringInStr(FileGetAttrib($src), "D") Then
					Dim $drive, $folder, $filename, $ext;
					_PathSplit($src, $drive, $folder, $filename, $ext);
					$dst = $dst & "\" & $filename & $ext;
					ContinueLoop;
				ElseIf (StringInStr(FileGetAttrib($src), "D") And StringInStr(FileGetAttrib($dst), "D")) Then
					If Not Confirm($LANG_REPLACEFILE, StringFormat($LANG_REPLACEFILEMSG, _
							$dst, DirGetSize($dst), $timeDst, _
							$src, DirGetSize($src), $timeSrc)) Then
						ExitLoop;
					EndIf
				EndIf
				
				Dim $pid;
				
				If StringInStr(FileGetAttrib($src), "D") Then
					If Not StringInStr(FileGetAttrib($dst), "D") And FileExists($dst) Then
						ExitLoop;
					EndIf
					$pid = Run(@AutoItExe & " /AutoIt3ExecuteScript """ & @ScriptDir & "\Move.au3"" """ & _PathFull($src) & """ """ & _PathFull($dst) & """");
				Else
					$pid = Run(@AutoItExe & " /AutoIt3ExecuteScript """ & @ScriptDir & "\Move.au3"" """ & $src & """ """ & $dst & """");
				EndIf
				Dim $handle = _ProcessOpenHandle($pid);
				
				While ProcessExists($pid) And Not $cancel
					Sleep(200);
				WEnd
				If $cancel Then
					ProcessClose($pid);
					Exit;
				EndIf
				Dim $result = _ProcessGetExitCode($pid, $handle);
				
				If Not $result Then
					Switch ErrorMessage($LANG_ERRORMOVING, $LANG_ERRORMOVINGMSG)
						
						Case $MSG_QUIT
							ExitLoop;
						
						Case $MSG_RETRY
							ContinueLoop;
						
					Case $MSG_ADMIN
							ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & @ScriptDir & "\Admin.a3x"" " & _StringToHex("""" & @AutoItExe & """ /AutoIt3ExecuteScript """ & @ScriptFullPath & """ /move """ & $src & """ """ & $dst & """") & """");
							ExitLoop;
						
					EndSwitch
				EndIf
				ExitLoop;
			WEnd
		Next
		GUIDelete($gui);
		
	Case Else
		Exit;
	
EndSwitch

If TimerDiff($start) < 5000 Then
	Local $windows = WinList("Xenon");
	
	Local $i;
	For $i = 1 To $windows[0][0]
		If _ProcessGetName(WinGetProcess($windows[$i][1])) = _ProcessGetName(@AutoItPID) Then
			Dim $menu = _GUICtrlMenu_GetMenu($windows[$i][1]);
			If $menu = 0 Then ContinueLoop;
			Dim $view = _GUICtrlMenu_GetItemSubMenu($menu, 2);
			
			WinMenuSelectItem($windows[$i][1], "", _GUICtrlMenu_GetItemText($menu, 2), _GUICtrlMenu_GetItemText($view, 0));
			ExitLoop;
		EndIf
	Next
EndIf

Func ErrorMessage($errTitle, $errMsg)
	If @OSTYPE = "WIN32_WINDOWS" Then Return $MSG_QUIT;
	Dim $opt = Opt("GUIOnEventMode", 0);
	Local $error = GUICreate($errTitle, 300, 300);
	GUISetState(@SW_SHOW, $error);
	
	Local $lbl = GUICtrlCreateLabel($LANG_ERRORPOSSIBLE, 5, 5, 290, 40);
	
	Local $btnQuit = GUICtrlCreateButton($LANG_CANCEL, 10, 50, 280, 70);
	Local $btnRetry = GUICtrlCreateButton($LANG_RETRY, 10, 135, 280, 70);
	Local $btnAdmin = GUICtrlCreateButton($LANG_RETRYADMIN, 10, 220, 280, 70);
	
	GUICtrlSetFont($btnQuit, 24);
	GUICtrlSetFont($btnRetry, 24);
	GUICtrlSetFont($btnAdmin, 24);
	
	Local $retVal;
	
	While True
		Local $msg = GUIGetMsg();
		Switch $msg
			Case $btnQuit, $GUI_EVENT_CLOSE
				$retVal = $MSG_QUIT;
				ExitLoop;
			
			Case $btnRetry
				$retVal = $MSG_RETRY;
				ExitLoop;
			
		Case $btnAdmin
				$retVal = $MSG_ADMIN;
				ExitLoop;
		EndSwitch
	WEnd
	
	GUIDelete($error);
	Opt("GUIOnEventMode", $opt);
	Return $retVal;
EndFunc

Func SplashScreen($file)
	Local $gui = GUICreate("", 500, 250, Default, Default, BitOR($WS_MINIMIZEBOX, $WS_BORDER));, $WS_EX_TOPMOST);
	Local $size = WinGetClientSize($gui);
	Local $pos = WinGetPos($gui);
	WinMove($gui, "", $pos[0] + ((500 - $size[0]) / 2), $pos[1] + ((250 - $size[1]) / 2), 500 + (500 - $size[0]), 250 + (250 - $size[1]));
	Local $pic = GUICtrlCreatePic($file, 0, 0, 500, 250);
	GUICtrlSetState($pic, $GUI_DISABLE);
	Local $btn = GUICtrlCreateButton($LANG_CANCEL, 400, 200, 75, Default);
	GUICtrlSetOnEvent($btn, "CancelBtn_Click");
	GUISetState(@SW_SHOW, $gui);
	Return $gui;
EndFunc

Func CancelBtn_Click()
	$cancel = True;
EndFunc

Func Confirm($title, $msg)
	If $yesToAll Then Return True;
	If $noToAll Then Return False;
	Local $gui = GUICreate($title, 300, 300);
	Local $label = GUICtrlCreateLabel($msg, 20, 20, 260, 200);
	Local $ok = GUICtrlCreateButton($LANG_YES, 20, 240, 73, Default, $BS_DEFPUSHBUTTON);
	Local $cancel = GUICtrlCreateButton($LANG_NO, 96, 240, 73);
	$checkbox = GUICtrlCreateCheckbox($LANG_SAMEFORALL, 20, 270);
	
	GUISetOnEvent($GUI_EVENT_CLOSE, "confirm_Cancel_Click", $gui);
	GUICtrlSetOnEvent($ok, "confirm_OK_Click");
	GUICtrlSetOnEvent($cancel, "confirm_Cancel_Click");
	
	GUISetState(@SW_SHOW, $gui);
	While WinExists($gui)
		Sleep(100);
	WEnd
	
	Return $confirm_Result;
EndFunc

Func confirm_OK_Click()
	$confirm_Result = True;
	If BitAND(GUICtrlRead($checkbox), $GUI_CHECKED) = $GUI_CHECKED Then
		$yesToAll = True;
	EndIf
	GUIDelete(@GUI_WinHandle);
EndFunc

Func confirm_Cancel_Click()
	$confirm_Result = False;
	If BitAND(GUICtrlRead($checkbox), $GUI_CHECKED) = $GUI_CHECKED Then
		$noToAll = True;
	EndIf
	GUIDelete(@GUI_WinHandle);
EndFunc