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

Const $LANG_INI = IniRead($DATA_DIR & "\settings.ini", "Xenon", "language", "lang_en-US.ini");
Dim $SETTINGS_ShowHiddenFiles = Int(IniRead($DATA_DIR & "\settings.ini", "Xenon", "ShowHiddenFiles", "0"));
Dim $SETTINGS_GetFolderSizes = Int(IniRead($DATA_DIR & "\settings.ini", "Xenon", "GetFolderSizes", "0"));
Dim $SETTINGS_Language = $LANG_INI;
Dim $SETTINGS_ViewStyle = Int(IniRead($DATA_DIR & "\settings.ini", "Xenon", "ViewStyle", "0"));
Dim $SETTINGS_ShowTreeView = Int(IniRead($DATA_DIR & "\settings.ini", "Xenon", "ShowTreeView", "0"));
Dim $SETTINGS_ShowDDItem = Int(IniRead($DATA_DIR & "\settings.ini", "Xenon", "ShowDDItem", "0"));
Dim $SETTINGS_IconSet = IniRead($DATA_DIR & "\settings.ini", "Xenon", "IconSet", "PortableApps.com");
Dim $SETTINGS_Homepage = IniRead($DATA_DIR & "\settings.ini", "Xenon", "Homepage", "\");
Dim $SETTINGS_PromptOnDelete = Int(IniRead($DATA_DIR & "\settings.ini", "Xenon", "PromptOnDelete", "1"));

Dim $SETTINGS_Bookmarks[1][2] = [[0,0]];
Dim $i = 1;
While True
	Dim $value = IniRead($DATA_DIR & "\settings.ini", "Bookmarks", $i, "");
	Dim $caption = IniRead($DATA_DIR & "\settings.ini", "Bookmarks", "cap" & $i, "");
	If $value == "" Then ExitLoop;
	ReDim $SETTINGS_Bookmarks[$i+1][2];
	$SETTINGS_Bookmarks[$i][0] = StringReplace($value, "?", StringLeft(DriveOf(@ScriptDir), 1));
	$SETTINGS_Bookmarks[$i][1] = $caption;
	$i += 1;
WEnd