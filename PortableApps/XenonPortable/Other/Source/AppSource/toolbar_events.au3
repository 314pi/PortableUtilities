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

Func backButton_Click()
	If UBound($history) > 1 Then
		_ArrayAdd($forward, $dir);
		LoadDir(_ArrayPop($history), False);
	EndIf
EndFunc

Func forwardButton_Click()
	If UBound($forward) > 1 Then
		_ArrayAdd($history, $dir);
		LoadDir(_ArrayPop($forward), False);
	EndIf
EndFunc

Func upButton_Click()
	If $dir = $LANG_COMPUTER Then Return;
	FolderItemClick("..");
EndFunc

Func computerButton_Click()
	LoadDir($LANG_COMPUTER);
EndFunc

Func homeButton_Click()
	LoadDir(DriveOf(@ScriptDir) & $SETTINGS_Homepage);
EndFunc

Func goButton_Click()
	LoadDir(GUICtrlRead($addressBar));
EndFunc

Func searchButton_Click()
	If $dir = $LANG_COMPUTER Then Return;
	If GUICtrlRead($searchBar) == "" Then
		ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & StringReplace(@ScriptDir, """", """""") & "\Search.a3x""");
	Else
		ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & StringReplace(@ScriptDir, """", """""") & "\Search.a3x"" /Search """ & _
			StringReplace($dir, """", """""") & """ """ & StringReplace(GUICtrlRead($searchBar), """", """""") & """");
	EndIf
EndFunc