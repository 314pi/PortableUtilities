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

Func DriveItemClick($file)
	LoadDir($file);
EndFunc

Func FolderItemClick($file)
	Local $adir = $dir & $file;
	
	Local $drive, $path, $filename, $ext;
	_PathSplit($adir, $drive, $path, $filename, $ext);
	
	
	If $path & $filename & $ext == "\.." Then
		LoadDir($LANG_COMPUTER);
		Return;
	EndIf
	
	LoadDir($adir);
EndFunc

Func FileItemClick($file, $start = False)
	FileStart($dir & $file, $start)
EndFunc

Func FileStart($file, $start = False)
	Local $cwd = $dir;
	
	Local $drive, $path, $filename, $ext;
	Local $ext2;
	Do
		_PathSplit($file, $drive, $path, $filename, $ext);
		$ext2 = StringTrimLeft($ext, 1);
		If $ext2 == "lnk" Then
			Local $shortcutInfo = FileGetShortcut($file);
			$file = $shortcutInfo[0];
			$cwd = $shortcutInfo[1];
			If IsDir($file) Then
				LoadDir($file);
				Return;
			EndIf
			ContinueLoop;
		EndIf
	Until True
	
	If $start Then
		If RunFile($file, $cwd, True, $ext2) Then Return;
		;If PAShellExec($file, $cwd) Then Return;
		ShellExec($file, $cwd);
	Else
		;If PAShellExec($file, $cwd) Then Return;
		If RunFile($file, $cwd, False, $ext2) Then Return;
		ShellExec($file, $cwd);
	EndIf
	
;~ 	If $error Then
;~ 		_MsgBox(16, $LANG_ERROROPENINGFILE, $LANG_THEFILECOULDNOTBEOPENED, $window);
;~ 	EndIf
EndFunc

Func PAShellExec($file, $cwd)
	Local $paShellExec = EnvGet("PortableApps.comShellExecute");
	If $paShellExec <> "" Then
		If RunWait("""" & $paShellExec & """ open """ & StringReplace($file, """", """""") & """ errorifnotdefined", $cwd) Then
			Return False;
		EndIf
		If @error Then Return False;
		Return True;
	EndIf
	Return False;
EndFunc

Func ShellExec($file, $cwd)
	ShellExecute($file, "", $cwd);
EndFunc

Func RunFile($file, $cwd, $start, $ext)
	Local $exe = "";
	If $start Then $exe = IniRead($DATA_DIR & "\assoc.ini", $ext, "start", "");
	If Not $start Or $exe == "" Then $exe = IniRead($DATA_DIR & "\assoc.ini", $ext, "exe", "");
	If $start Or $exe == "" Then $exe = IniRead($DATA_DIR & "\assoc.ini", $ext, "start", "");
	
	Local $error;
	If $exe == "" Then
		Return False;
	Else
		Local $aditionalParam = "";
		
		Local $last4Chars = StringRight($exe, 4);
		If $last4Chars = ".au3" Or $last4Chars = ".a3x" Then
			Run("""" & @AutoItExe & """ /AutoIt3ExecuteScript """ & DriveOf(@ScriptDir) & StringReplace($exe, "|XEDIR|", StripDrive(@ScriptDir)) & _
					""" """ & StringReplace($file, """", """""") & """", $cwd);
		Else
			Run("""" & DriveOf(@ScriptDir) & StringReplace($exe, "|XEDIR|", StripDrive(@ScriptDir)) & """ """ & StringReplace($file, """", """""") & """", $cwd);
		EndIf
		
		If @error Then Return False;
	EndIf
	Return True;
EndFunc