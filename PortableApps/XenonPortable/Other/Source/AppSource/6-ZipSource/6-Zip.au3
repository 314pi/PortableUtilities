#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=6-Zip.a3x
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs
	
	File Name: 			6-Zip.au3
	Author:				MI3 Software (http://www.mi3soft.info)
	Copyright:			Copyright (c) 2007 www.mi3soft.info
	License: 			Lesser GNU General Public License
	
#ce

#include <GUIConstantsEx.au3>
#include <File.au3>

Opt("GUIOnEventMode", 1);

Const $WINDOW_TITLE = "6-Zip";

Dim $DATA_DIR = EnvGet("XENON_DATA_DIR");
If $DATA_DIR == "" Then
	If StringLeft(@ScriptDir, StringLen(@ProgramFilesDir)) == @ProgramFilesDir Then
		$DATA_DIR = @AppDataDir & "\Xenon";
		If DirGetSize($DATA_DIR, 2) == -1 Then DirCreate($DATA_DIR);
	Else
		$DATA_DIR = @ScriptDir & "\..\xenon";
	EndIf
EndIf

Const $LANG_INI = @ScriptDir & "\" & IniRead($DATA_DIR & "\settings.ini", "Xenon", "Language", "lang_en-US.ini");

#region Lang
Const $LANG_FILETOEXTRACT = IniRead($LANG_INI, "TRANSLATION", "FILETOEXTRACT", "File to extract:");
Const $LANG_EXTRACTTODIR = IniRead($LANG_INI, "TRANSLATION", "EXTRACTODIR", "Extract to:");
Const $LANG_BROWSE = IniRead($LANG_INI, "TRANSLATION", "BROWSE", "Browse...");
Const $LANG_EXTRACT = IniRead($LANG_INI, "TRANSLATION", "EXTRACT", "&Extract");
Const $LANG_CANCEL = IniRead($LANG_INI, "TRANSLATION", "CANCEL", "&Cancel");
Const $LANG_SELECTFILE = IniRead($LANG_INI, "TRANSLATION", "SELECTFILE", "Select File");
Const $LANG_SELECTFOLDER = IniRead($LANG_INI, "TRANSLATION", "SELECTFOLDER", "Select Folder");
Const $LANG_ZIPFILES = IniRead($LANG_INI, "TRANSLATION", "ZIPFILES", "Zip Files");
Const $LANG_RARFILES = IniRead($LANG_INI, "TRANSLATION", "RARFILES", "Rar Files");
Const $LANG_7ZIPFILES = IniRead($LANG_INI, "TRANSLATION", "7ZIPFILES", "7-Zip Files");
Const $LANG_OTHERARCHIVES = IniRead($LANG_INI, "TRANSLATION", "OTHERARCHIVES", "Other Archives");
Const $LANG_MISSINGFILE = IniRead($LANG_INI, "TRANSLATION", "MISSINGFILE", "Missing File");
Const $LANG_MISSINGFOLDER = IniRead($LANG_INI, "TRANSLATION", "MISSINGFOLDER", "Missing Folder");
Const $LANG_FILENOTEXIST = IniRead($LANG_INI, "TRANSLATION", "FILENOTEXIST", "The specified file does not exist.");
Const $LANG_FOLDERNOTEXIST = IniRead($LANG_INI, "TRANSLATION", "FOLDERNOTEXIST", "The specified folder does not exist. Would you like to create it?");
Const $LANG_SUCCESS = IniRead($LANG_INI, "TRANSLATION", "SUCCESS", "Success");
Const $LANG_SUCCESSMSG = IniRead($LANG_INI, "TRANSLATION", "SUCCESSMSG", "The extraction was successful. If you are using Xenon you may have to refresh the folder before the extracted files become visible.");
#endregion

Dim $zipFile = "";
Dim $extractToDirStr = "";

If $CmdLine[0] > 0 Then
	If FileExists($CmdLine[1]) Then
		$zipFile = $CmdLine[1];
		
		Dim $drive, $path, $filename, $ext;
		_PathSplit($zipFile, $drive, $path, $filename, $ext);
		
		$extractToDirStr = $drive & $path & $filename;
		If FileExists($extractToDirStr) Then
			Dim $i = 1;
			While FileExists($extractToDirStr & $i)
				$i += 1;
			WEnd
		EndIf
	EndIf
EndIf

Dim $window = GUICreate($WINDOW_TITLE, 369, 250);

GUISetIcon(@ScriptDir & "\6-Zip.ico", 0, $window);

Dim $fileToExtractLabel = GUICtrlCreateLabel($LANG_FILETOEXTRACT, 20, 20);
Dim $fileTextBox = GUICtrlCreateInput($zipFile, 20, 35, 250);
Dim $fileBrowse = GUICtrlCreateButton($LANG_BROWSE, 275, 35, 85, 20);

Dim $extractToDirLabel = GUICtrlCreateLabel($LANG_EXTRACTTODIR, 20, 100); 
Dim $extractToDirTextBox = GUICtrlCreateInput($extractToDirStr, 20, 115, 250);
Dim $extractToDirBrowse = GUICtrlCreateButton($LANG_BROWSE, 275, 115, 85, 20);

Dim $extractButton = GUICtrlCreateButton($LANG_EXTRACT, 20, 210, 74);
Dim $cancelButton = GUICtrlCreateButton($LANG_CANCEL, 104, 210, 74);

GUISetOnEvent($GUI_EVENT_CLOSE, "window_Close", $window);
GUICtrlSetOnEvent($fileBrowse, "fileBrowse");
GUICtrlSetOnEvent($extractToDirBrowse, "dirBrowse");
GUICtrlSetOnEvent($extractButton, "extractButton_Click");
GUICtrlSetOnEvent($cancelButton, "window_Close");

GUISetState(@SW_SHOW, $window);

While True
	Sleep(200);
WEnd

Func window_Close()
	Exit(0);
EndFunc

Func fileBrowse()
	Local $drive, $path, $filename, $ext;
	_PathSplit(GUICtrlRead($fileTextBox), $drive, $path, $filename, $ext);
	
	Local $startDir = $drive & $path;
	Local $startFile = $filename & $ext;
	If $startDir == "" Then $startDir = StringLeft(@ScriptDir, 2) & "\Documents";
	
	Local $fname = FileOpenDialog($LANG_SELECTFILE, $startDir, $LANG_ZIPFILES & " (*.zip)|" & $LANG_RARFILES & " (*.rar)|" & $LANG_7ZIPFILES & " (*.7z)|" & $LANG_OTHERARCHIVES & " (*.001;*.arj;*.bz2;*.cab;*.deb;*.exe;*.gz;*.iso;*.lzh;*.rpm;*.tar;*.z)");
	If @error Then Return;
	
	If GUICtrlRead($extractToDirTextBox) == $extractToDirStr Then
		_PathSplit($fname, $drive, $path, $filename, $ext);
		GUICtrlSetData($extractToDirTextBox, $drive & $path & $filename);
		$extractToDirStr = GUICtrlRead($extractToDirTextBox);
	EndIf
	
	GUICtrlSetData($fileTextBox, $fname);
EndFunc

Func dirBrowse()
	Local $dir = FileSelectFolder($LANG_SELECTFOLDER, StringLeft(@ScriptDir, 2), 3, GUICtrlRead($extractToDirTextBox));
	If @error Then Return;
	
	GUICtrlSetData($extractToDirTextBox, $dir);
EndFunc

Func extractButton_Click()
	
	Local $zipFileName = GUICtrlRead($fileTextBox);
	Local $extractDir = GUICtrlRead($extractToDirTextBox);
	If Not FileExists($zipFileName) Then
		MsgBox(16, $LANG_MISSINGFILE, $LANG_FILENOTEXIST);
		Return;
	EndIf
	
	If DirGetSize($extractDir) == -1 Then
		If FileExists($extractDir) Then
			Return;
		Else
			If MsgBox(36, $LANG_MISSINGFOLDER, $LANG_FOLDERNOTEXIST) <> 6 Then Return;
			DirCreate($extractDir);
		EndIf
	EndIf
	
	GUISetState(@SW_HIDE, $window);
	
	Local $exitCode = ShellExecuteWait(@ScriptDir & "\7zG.exe", "x """ & StringReplace($zipFileName, """", """""") & """ -o""" & StringReplace($extractDir, """", """""") & """");
	
	If $exitCode == 0 Then
		MsgBox(64, $LANG_SUCCESS, $LANG_SUCCESSMSG);
		Exit(0);
	EndIf
	
	Exit(1);
EndFunc