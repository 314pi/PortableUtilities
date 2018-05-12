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

Dim $pluginMenuItems[1] = [0];
Dim $pluginFileNames[1] = [0];
Dim $pluginTypes[1] = [0];
Dim $pluginCategories[1] = [0];
Dim $indexes[1] = [0];


Dim $guiPlugins[1][2] = [[0,0]];
Enum $PLUGIN_FILE, $PLUGIN_NAME;
Enum $PLUGIN_EVENT_INIT, $PLUGIN_EVENT_EXIT, $PLUGIN_EVENT_LOADICONS, $PLUGIN_EVENT_LOADFILELISTING, _
		$PLUGIN_EVENT_LOADDIR, $PLUGIN_EVENT_COPY, $PLUGIN_EVENT_CUT, $PLUGIN_EVENT_PASTE;
Enum $PLUGIN_MSG_LOADDIR, $PLUGIN_MSG_ARRAY_SIZE, $PLUGIN_MSG_ARRAY_GET, $PLUGIN_MSG_ARRAY_SET, _
		$PLUGIN_MSG_ARRAY_DEL, $PLUGIN_MSG_ARRAY_PUSH, $PLUGIN_MSG_ARRAY_POP, $PLUGIN_GUICTRLCREATE;
Const $callback_args = "int;wstr;wstr;int;ptr";

Const $validTypes[4] = ["SCRIPT", "EXECUTABLE", "SEPARATOR", "GUISCRIPT"];

Dim $categories = IniReadSectionNames($PLUGINS_DIR & "\plugins.ini");
If Not @error Then
	Dim $i;
	
	For $i = 1 To $categories[0]
		Dim $file = IniRead($PLUGINS_DIR & "\plugins.ini", $categories[$i], "file", "");
		Dim $type = IniRead($PLUGINS_DIR & "\plugins.ini", $categories[$i], "type", "");
		Dim $text = IniRead($PLUGINS_DIR & "\plugins.ini", $categories[$i], "text", "");
		Dim $bitmap = IniRead($PLUGINS_DIR & "\plugins.ini", $categories[$i], "bitmap", "");
		Dim $index = Int(IniRead($PLUGINS_DIR & "\plugins.ini", $categories[$i], "index", "-1"));
		Dim $subItems = Int(IniRead($PLUGINS_DIR & "\plugins.ini", $categories[$i], "subitems", "0"));
		
		ConsoleWrite($type & @CRLF);
		
		If _ArraySearch($validTypes, $type) == -1 Then ContinueLoop;
		If $type <> "SEPARATOR" And Not FileExists($PLUGINS_DIR & "\" & $file) Then ContinueLoop;
		
		ConsoleWrite($categories[$i] & @CRLF & @CRLF);
		
		If $index <> -1 Then
			Dim $j;
			For $j = 1 To UBound($indexes) - 1
				If $indexes[$j] <= $index Then
					$index += 1;
				EndIf
			Next
		EndIf
		
		Switch $type
			Case "SCRIPT", "EXECUTABLE"
				If $subItems Then
					Dim $parent = GUICtrlCreateMenu($text, $contextMenu, $index);
					If $index <> -1 Then _ArrayAdd($indexes, $index);
					
					If $bitmap <> "" Then
						If $index == -1 Then
							AddImageToMenu($contextMenu, $MF_BYPOSITION, $CONTEXTMENU_LENGTH + (UBound($indexes) - 1), $PLUGINS_DIR & "\" & $bitmap);
						Else
							AddImageToMenu($contextMenu, $MF_BYPOSITION, $index, $PLUGINS_DIR & "\" & $bitmap);
						EndIf
					EndIf
					
					Dim $j = 0;
					While True
						Dim $itemText = IniRead($PLUGINS_DIR & "\plugins.ini", $categories[$i], "subitems[" & $j & "]", "__NOTEXT__");
						If $itemText == "__NOTEXT__" Then ExitLoop;
						
						Dim $subItem = GUICtrlCreateMenuItem($itemText, $parent);
						GUICtrlSetOnEvent($subItem, "Plugin_Click");
						_ArrayAdd($pluginMenuItems, $subItem);
						_ArrayAdd($pluginFileNames, $file);
						_ArrayAdd($pluginTypes, $type);
						_ArrayAdd($pluginCategories, $categories[$i]);
						
						$j += 1;
					WEnd
					
					
				Else
					Dim $item = GUICtrlCreateMenuItem($text, $contextMenu, $index);
					If $index <> -1 Then _ArrayAdd($indexes, $index);
					GUICtrlSetOnEvent($item, "Plugin_Click");
					
					If $bitmap <> "" Then
						If $index == -1 Then
							AddImageToMenu($contextMenu, $MF_BYPOSITION, $CONTEXTMENU_LENGTH + (UBound($indexes) - 1), $PLUGINS_DIR & "\" & $bitmap);
						Else
							AddImageToMenu($contextMenu, $MF_BYPOSITION, $index, $PLUGINS_DIR & "\" & $bitmap);
						EndIf
					EndIf
					
					_ArrayAdd($pluginMenuItems, $item);
					_ArrayAdd($pluginFileNames, $file);
					_ArrayAdd($pluginTypes, $type);
					_ArrayAdd($pluginCategories, $categories[$i]);
				EndIf
			
			Case "SEPARATOR"
				GUICtrlCreateMenuItem("", $contextMenu, $index);
				If $index <> -1 Then _ArrayAdd($indexes, $index);
			
			Case "GUISCRIPT"
				
			
		EndSwitch
	Next
EndIf

Func XenonPlugin_RegisterPlugin($file, $name)
	Local $last = UBound($guiPlugins);
	
	Local $i;
	For $i = 1 To $last - 1
		If _PathFull($file) = _PathFull($guiPlugins[$i][$PLUGIN_FILE]) Or $name = $guiPlugins[$i][$PLUGIN_NAME] Then Return 0;
	Next
	
	ReDim $guiPlugins[$last+1][UBound($guiPlugins, 2)];
	$guiPlugins[$last][$PLUGIN_FILE] = $file;
	$guiPlugins[$last][$PLUGIN_NAME] = $name;
	
EndFunc


Func XenonPlugin_Callback($msg, $str1, $str2, $int1, $ptr1)
	Switch $msg
		Case 0
	EndSwitch
EndFunc


Func Plugin_Click()
	Local $index = _ArraySearch($pluginMenuItems, @GUI_CtrlId);
	Local $lvItems = _GUICtrlListView_GetSelectedIndices($listView, 1);
	If $index <> -1 Then
		
		Local $selected = "";
		
		If IsArray($lvItems) Then
			Local $i;
			For $i = 1 To $lvItems[0]
				$selected &= _GUICtrlListView_GetItemText($listView, $lvItems[$i], 0) & "|";
			Next
		EndIf
		
		$selected = StringTrimRight($selected, 1);
		
		EnvSet("XENON_DATA_DIR", $DATA_DIR);
		EnvSet("XENON_PLUGINS_DIR", $PLUGINS_DIR);
		EnvSet("XENON_DIR", @ScriptDir);
		
		EnvSet("XENON_PLUGINS_INI", $PLUGINS_DIR & "\plugins.ini");
		EnvSet("XENON_PLUGINS_INI_CAT", $pluginCategories[$index]);
		
		EnvSet("XENON_FILES_SEL", $selected);
		EnvSet("XENON_CURRENT_DIR", $dir);
		EnvSet("XENON_ITEM_TEXT", GUICtrlRead(@GUI_CtrlId, 1));
		
		Switch $pluginTypes[$index]
			Case "SCRIPT"
				ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & StringReplace($PLUGINS_DIR & "\" & $pluginFileNames[$index], """", """""") & """", $dir);
			
			Case "EXECUTABLE"
				ShellExecute($PLUGINS_DIR & "\" & $pluginFileNames[$index]);
		EndSwitch
	EndIf
EndFunc