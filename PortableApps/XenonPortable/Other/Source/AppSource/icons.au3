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

Func GetIcon($file, ByRef $iconFile, ByRef $iconIndexId)
	Local $drive, $path, $filename, $ext;
	_PathSplit($file, $drive, $path, $filename, $ext);
	
	Switch $ext
		Case ".exe", ".scr"
			If Not FileHasIcons($file) Then
				$iconFile = GetAssocIconFromFileName("default.ico");
				$iconIndexId = 0;
				Return;
			EndIf
			
			$iconFile = $file;
			$iconIndexId = 0;
			Return;
		Case ".ico"
			$iconFile = $file;
			$iconIndexId = 0;
			Return;
		Case ".lnk"
			Local $shortcutInfo = FileGetShortcut($file);
			
			Local $iconFileName = $shortcutInfo[4];
			Local $iconIndex = $shortcutInfo[5];
			
			$iconFile = $iconFileName;
			$iconIndexId = $iconIndex;
			Return;
		
	EndSwitch
	
	Local $ext2 = StringTrimLeft($ext, 1);
	Local $iconname = IniRead($DATA_DIR & "\assoc.ini", $ext2, "icon", "default.ico");
	
	$iconFile = GetAssocIconFromFileName($iconname);
	$iconIndexId = 0;
EndFunc

Func FolderGetIcon($folder, ByRef $picon, ByRef $iconIndex, $reverse = True)
	Local $desktopini = StringFormat("%s/%s/Desktop.ini", $dir, $folder);
	Local $icon = _WinAPI_ExpandEnvironmentStrings(IniRead($desktopini, ".ShellClassInfo", "IconFile", GetFolderIconForCurTheme()));
	Local $iconId = IniRead($desktopini, ".ShellClassInfo", "IconIndex", 0);
	
	If DriveOf($icon) = "" Then
		$icon = StringFormat("%s/%s/%s", $dir, $folder, $icon);
	EndIf
	
	If Not FileExists($icon) Then
		$icon = GetFolderIconForCurTheme();
		$iconId = 0;
	EndIf
	
	$picon = $icon;
	$iconIndex = $iconId;
	
	If $reverse Then
		If $iconIndex > 0 Then
			$iconIndex = -$iconIndex - 1;
		Else
			$iconIndex = Abs($iconIndex);
		EndIf
	EndIf
EndFunc

Func DriveLoadIcon($drive, ByRef $name, ByRef $index)
	$index = 0;
	$name = "";
	Local $loadFromAutoRun = DriveStatus($drive) <> "NOTREADY";
	Switch DriveGetType($drive)
		Case "Removable"
			Local $driveico = GetDriveIcon("removable.ico");
			If $loadFromAutoRun Then
				$name = IniRead($drive & "\autorun.inf", "autorun", "icon", $driveico);
				If DriveOf($name) <> $drive And $driveico Then
					$name = $drive & $name;
				EndIf
			EndIf
			
			If Not FileExists($name) Or $name = "" Then
				$name = $driveico;
			EndIf
			
		Case "CDROM"
			Local $driveico = GetDriveIcon("cdrom.ico");
			If $loadFromAutoRun Then
				$name = IniRead($drive & "\autorun.inf", "autorun", "icon", $driveico);
				If DriveOf($name) <> $drive And $name <> $driveico Then
					$name = $drive & $name;
				EndIf
			EndIf
			
			If Not FileExists($name) Then
				$name = $driveico;
			EndIf
			
		Case Else
			Local $driveico = GetDriveIcon("default.ico");
			If $loadFromAutoRun Then
				$name = IniRead($drive & "\autorun.inf", "autorun", "icon", $driveico);
				If DriveOf($name) <> $drive And $name <> $driveico Then
					$name = $drive & $name;
				EndIf
			EndIf
			
			If Not FileExists($name) Then
				$name = $driveico;
			EndIf
		
	EndSwitch
EndFunc