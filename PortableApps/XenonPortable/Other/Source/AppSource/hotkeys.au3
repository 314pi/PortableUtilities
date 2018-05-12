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

#region HotKey Events
Func enter_Pressed()
	If WinActive($window) Then
		If ControlGetHandle($window, "", ControlGetFocus($window)) = GUICtrlGetHandle($addressBar) Then
			goButton_Click();
		ElseIf ControlGetHandle($window, "", ControlGetFocus($window)) = GUICtrlGetHandle($searchBar) Then
			searchButton_Click();
		ElseIf ControlGetHandle($window, "", ControlGetFocus($window)) = GUICtrlGetHandle($listView) Then
			Open();
;~ 		Else
;~ 			HotKeySet(@HotKeyPressed);
;~ 			Send(@HotKeyPressed);
;~ 			HotKeySet(@HotKeyPressed, "enter_Pressed");
		EndIf
;~ 	Else
;~ 		HotKeySet(@HotKeyPressed);
;~ 		Send(@HotKeyPressed);
;~ 		HotKeySet(@HotKeyPressed, "enter_Pressed");
	EndIf
EndFunc

Func Backspace_Pressed()
	If WinActive($window) And ControlGetHandle($window,"", ControlGetFocus($window)) = GUICtrlGetHandle($listView) Then
		FolderItemClick("..");
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "Backspace_Pressed");
	EndIf
EndFunc

Func AltEnter_Pressed()
	If WinActive($window) Then
		Start();
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "AltEnter_Pressed");
	EndIf
EndFunc

Func F7_Pressed()
	If WinActive($window) Then
		NewFolder();
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "F7_Pressed");
	EndIf
EndFunc

Func CtrlF_Pressed()
	If WinActivate($window) Then
		searchButton_Click();
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "CtrlF_Pressed");
	EndIf
EndFunc

Func Delete_Pressed()
	If WinActive($window) Then
		If ControlGetHandle($window, "", ControlGetFocus($window)) = GUICtrlGetHandle($listView) Then
			Delete();
		Else
			HotKeySet(@HotKeyPressed);
			Send(@HotKeyPressed);
			HotKeySet(@HotKeyPressed, "Delete_Pressed");
		EndIf
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "Delete_Pressed");
	EndIf
EndFunc

Func AltLeft_Pressed()
	If WinActive($window) Then
		backButton_Click();
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "AltLeft_Pressed");
	EndIf
EndFunc

Func AltRight_Pressed()
	If WinActive($window) Then
		forwardButton_Click();
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "AltRight_Pressed");
	EndIf
EndFunc

Func CtrlC_Pressed()
	If WinActive($window) And ControlGetFocus($window) <> $addressBar Then
		If ControlGetHandle($window, "", ControlGetFocus($window)) == GUICtrlGetHandle($addressBar) Or _
			ControlGetHandle($window, "", ControlGetFocus($window)) == GUICtrlGetHandle($searchBar) Then
			HotKeySet(@HotKeyPressed);
			Send(@HotKeyPressed);
			HotKeySet(@HotKeyPressed, "CtrlC_Pressed");
		Else
			Copy();
		EndIf
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "CtrlC_Pressed");
	EndIf
EndFunc

Func CtrlX_Pressed()
	If WinActive($window) And ControlGetFocus($window) <> $addressBar Then
		If ControlGetHandle($window, "", ControlGetFocus($window)) = GUICtrlGetHandle($addressBar) Or _
			ControlGetHandle($window, "", ControlGetFocus($window)) = GUICtrlGetHandle($searchBar) Then
			HotKeySet(@HotKeyPressed);
			Send(@HotKeyPressed);
			HotKeySet(@HotKeyPressed, "CtrlX_Pressed");
		Else
			Cut();
		EndIf
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "CtrlX_Pressed");
	EndIf
EndFunc

Func CtrlV_Pressed()
	If WinActive($window) And ControlGetFocus($window) <> $addressBar Then
		If ControlGetHandle($window, "", ControlGetFocus($window)) = GUICtrlGetHandle($addressBar) Or _
			ControlGetHandle($window, "", ControlGetFocus($window)) = GUICtrlGetHandle($searchBar) Then
			HotKeySet(@HotKeyPressed);
			Send(@HotKeyPressed);
			HotKeySet(@HotKeyPressed, "CtrlV_Pressed");
		Else
			Paste();
		EndIf
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "CtrlV_Pressed");
	EndIf
EndFunc

Func CtrlA_Pressed()
	If WinActive($window) Then
		If ControlGetHandle($window, "", ControlGetFocus($window)) = GUICtrlGetHandle($addressBar) Or _
			ControlGetHandle($window, "", ControlGetFocus($window)) = GUICtrlGetHandle($searchBar) Then
			HotKeySet(@HotKeyPressed);
			Send(@HotKeyPressed);
			HotKeySet(@HotKeyPressed, "CtrlA_Pressed");
		Else
			SelectAll();
		EndIf
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "CtrlA_Pressed");
	EndIf
EndFunc

Func CtrlShiftA_Pressed()
	If WinActive($window) Then
		SelectNone();
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "CtrlA_Pressed");
	EndIf
EndFunc

Func F1_Pressed()
	If WinActive($window) Then
		Help();
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "F1_Pressed");
	EndIf
EndFunc

Func F2_Pressed()
	If WinActive($window) Then
		Rename();
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "F2_Pressed");
	EndIf
EndFunc

Func F5_Pressed()
	If WinActive($window) And ControlGetFocus($window) <> $addressBar Then
		Refresh();
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "F5_Pressed");
	EndIf
EndFunc

Func CtrlT_Pressed()
	If WinActive($window) Then
		NewTab();
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "CtrlT_Pressed");
	EndIf
EndFunc


Func CtrlF4_Pressed()
	If WinActive($window) Then
		CloseTab();
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "CtrlF4_Pressed");
	EndIf
EndFunc

Func CtrlTab_Pressed()
	If WinActive($window) Then
		Local $index = _GUICtrlTab_GetCurSel($tabset) + 1;
		If $index >= _GUICtrlTab_GetItemCount($tabset) Then $index = 0;
		_GUICtrlTab_SetCurSel($tabset, $index);
		SelectTab();
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "CtrlTab_Pressed");
	EndIf
EndFunc

Func CtrlShiftTab_Pressed()
	If WinActive($window) Then
		Local $index = _GUICtrlTab_GetCurSel($tabset) - 1;
		If $index < 0 Then $index = _GUICtrlTab_GetItemCount($tabset) - 1;
		_GUICtrlTab_SetCurSel($tabset, $index);
		SelectTab();
	Else
		HotKeySet(@HotKeyPressed);
		Send(@HotKeyPressed);
		HotKeySet(@HotKeyPressed, "CtrlShiftTab_Pressed");
	EndIf
EndFunc
#endregion

Func DisableHotkeys()
	HotKeySet("{Backspace}");
	HotKeySet("!{Enter}");
	HotKeySet("{F7}");
	HotKeySet("^f");
	HotKeySet("{F2}");
	HotKeySet("{Del}");
	HotKeySet("!{Left}");
	HotKeySet("!{Right}");
	HotKeySet("^c");
	HotKeySet("^x");
	HotKeySet("^v");
	HotKeySet("^a");
	HotKeySet("^+a");
	HotKeySet("{F5}");
	HotKeySet("^r");
	HotKeySet("^t");
	HotKeySet("^{F4}");
	HotKeySet("^w");
	HotKeySet("^{Tab}");
	HotKeySet("^+{Tab}");
EndFunc

Func EnableHotkeys()
	HotKeySet("{Backspace}", "Backspace_Pressed");
	HotKeySet("!{Enter}", "AltEnter_Pressed");
	HotKeySet("{F7}", "F7_Pressed");
	HotKeySet("^f", "CtrlF_Pressed");
	HotKeySet("{F2}", "F2_Pressed");
	HotKeySet("{Del}", "Delete_Pressed");
	HotKeySet("!{Left}", "AltLeft_Pressed");
	HotKeySet("!{Right}", "AltRight_Pressed");
	HotKeySet("^c", "CtrlC_Pressed");
	HotKeySet("^x", "CtrlX_Pressed");
	HotKeySet("^v", "CtrlV_Pressed");
	HotKeySet("^a", "CtrlA_Pressed");
	HotKeySet("^+a", "CtrlShiftA_Pressed");
	HotKeySet("{F5}", "F5_Pressed");
	HotKeySet("^r", "F5_Pressed");
	HotKeySet("^t", "CtrlT_Pressed");
	HotKeySet("^{F4}", "CtrlF4_Pressed");
	HotKeySet("^w", "CtrlF4_Pressed");
	HotKeySet("^{Tab}", "CtrlTab_Pressed");
	HotKeySet("^+{Tab}", "CtrlShiftTab_Pressed");
EndFunc