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

Dim $i = 1;
If $CmdLine[$i] = "/AutoIt3ExecuteScript" Then $i += 2;

If StringInStr(FileGetAttrib($CmdLine[$i]), "D") Then
	Exit NewDirMove($CmdLine[$i], $CmdLine[$i + 1], 1)
Else
	Exit FileMove($CmdLine[$i], $CmdLine[$i + 1], 1);
EndIf

Func NewDirMove($src, $dst, $ovw)
	Dim $search = FileFindFirstFile($src & "\*");
	While True
		Dim $file = FileFindNextFile($search);
		If @error Then ExitLoop;
		If StringInStr(FileGetAttrib($src & "\" & $file), "D") Then
			DirCreate($dst & "\" & $file);
			NewDirMove($src & "\" & $file, $dst & "\" & $file, $ovw);
		Else
			FileMove($src & "\" & $file, $dst & "\" & $file, $ovw);
		EndIf
	WEnd
	DirRemove($src);
EndFunc