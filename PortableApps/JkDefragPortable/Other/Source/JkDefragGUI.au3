#cs
Copyright 2008 Travis Carrico

Website: http://PortableApps.com/JkDefragPortable

This software is OSI Certified Open Source Software.
OSI Certified is a certification mark of the Open Source Initiative.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; If not, see <http://www.gnu.org/licenses/>.
#ce

;This script was made to work with AutoIt v3.2.12.0, updated versions of AutoIt may cause the script to break
#include <GUIConstantsEx.au3>
#Include <String.au3>
#Include <GuiListView.au3>
#RequireAdmin
AutoItSetOption("TrayIconHide", 1)
If @ProcessorArch = "X64" OR @ProcessorArch = "IA64" Then
	Const $EXE = "JkDefrag64.exe"
Else
	Const $EXE = "JkDefrag.exe"
EndIf
Dim $drivesfixed = DriveGetDrive( "FIXED" )
Dim $drivesremovable = DriveGetDrive( "REMOVABLE" )
Dim $selecteddrives[26], $driveslisted[26]
Dim $parameters, $logfile, $line, $i, $LANG_INI, $PID
Dim $a = 7

If FileExists($EXE) <> 1 Then
	MsgBox("","JkDefrag Portable","The required " & $EXE & " cannot be found.")
	Exit
EndIf

If DriveGetType(StringLeft(@WorkingDir,3)) = "CDROM" Then
	$LOG = @AppDataDir & "\JkDefrag.txt"
Else
	$LOG = "JkDefrag.txt"
EndIf
Const $WINDOW = "JkDefrag v3.36"

Select
	Case StringInStr("0804,1004", @OSLang); Simplified Chinese
		$LANG_INI = "languages\lang-zh-CN.ini"
	
	Case StringInStr("0404,0c04,1404", @OSLang); Traditional Chinese
		$LANG_INI = "languages\lang-zh-TW.ini"
	
	Case StringInStr("0405", @OSLang); Czech
		$LANG_INI = "languages\lang-cz-CZ.ini"
	
	Case StringInStr("040b", @OSLang); Finnish
		$LANG_INI = "languages\lang-fi-FI.ini"

    Case StringInStr("040c,080c,0c0c,100c,140c,180c", @OSLang); French
		$LANG_INI = "languages\lang-fr-FR.ini"

    Case StringInStr("0407,0807,0c07,1007,1407", @OSLang); German
		$LANG_INI = "languages\lang-de-DE.ini"

    Case StringInStr("0410,0810", @OSLang); Italian
		$LANG_INI = "languages\lang-it-IT.ini"
	
	Case StringInStr("0411", @OSLang); Japanese
		$LANG_INI = "languages\lang-ja-JA.ini"
	
	Case StringInStr("0415", @OSLang); Polish
		$LANG_INI = "languages\lang-pl-PL.ini"
	
	Case StringInStr("0416", @OSLang); Portuguese-Brazilian
		$LANG_INI = "languages\lang-pt-BR.ini"
	
	Case StringInStr("0816", @OSLang); Portuguese-Standard
		$LANG_INI = "languages\lang-pt-PT.ini"

    Case StringInStr("040a,080a,0c0a,100a,140a,180a,1c0a,200a,240a,280a,2c0a,300a,340a,380a,3c0a,400a,440a,480a,4c0a,500a", @OSLang); Spanish
		$LANG_INI = "languages\lang-es-ES.ini"
	
	Case Else ; English
		$LANG_INI = "languages\lang-en-US.ini"
		
EndSelect
Const $LANG_NOTANALYZED = IniRead($LANG_INI, "TRANSLATION", "NOTANALYZED", "Not Analyzed")
Const $LANG_DEFRAGMENTED = IniRead($LANG_INI, "TRANSLATION", "DEFRAGMENTED", "Defragmented")

GUICreate("JkDefrag Portable 3.36",528,205, (-1),(-1),0x80CE0000)
$listview = GUICtrlCreateListView ("          " & IniRead($LANG_INI, "TRANSLATION", "VOLUME", "Volume") & "          " & "|" & IniRead($LANG_INI, "TRANSLATION", "FILESYSTEM", "File System") & "|% " & IniRead($LANG_INI, "TRANSLATION", "FRAGMENTED", "Fragmented") & "|" & IniRead($LANG_INI, "TRANSLATION", "CAPACITY", "Capacity") & "|" & IniRead($LANG_INI, "TRANSLATION", "FREESPACE", "Free Space") & "|% " & IniRead($LANG_INI, "TRANSLATION", "FREESPACE", "Free Space"),10,10,508,150,0x8000)
$button1 = GUICtrlCreateButton (IniRead($LANG_INI, "TRANSLATION", "ANALYZE", "Analyze"),10,170,90,25)
$button2 = GUICtrlCreateButton (IniRead($LANG_INI, "TRANSLATION", "DEFRAGMENT", "Defragment"),110,170,90,25)
$button3 = GUICtrlCreateButton (IniRead($LANG_INI, "TRANSLATION", "DEFRAGOPTIMIZE", "Defragment and Optimize"),210,170,170,25,0x0001)
$button4 = GUICtrlCreateButton (IniRead($LANG_INI, "TRANSLATION", "VIEWLOG", "View Log"),418,170,100,25)
For $i = 1 to $drivesfixed[0] ; Fill in listview information for HDDs
	If DriveStatus($drivesfixed[$i]) = "READY" Then
		$a += 1
		$driveslisted[$a - 7] = $drivesfixed[$i]
		GUICtrlCreateListViewItem("",$listview)
		If DriveGetLabel($drivesfixed[$i]) <> "" Then
			GUICtrlSetData($a,StringUpper($drivesfixed[$i]) & " (" & DriveGetLabel($drivesfixed[$i]) & ")" & "|" & DriveGetFileSystem($drivesfixed[$i]) & "|" & $LANG_NOTANALYZED & "|" & Round(DriveSpaceTotal($drivesfixed[$i]) / 1024, 2) & " GB" & "|" & Round(DriveSpaceFree($drivesfixed[$i]) / 1024, 2) & " GB" & "|" & Round(DriveSpaceFree($drivesfixed[$i]) * 100 / DriveSpaceTotal($drivesfixed[$i]),2) & "%")
		Else
			GUICtrlSetData($a,StringUpper($drivesfixed[$i]) & "|" & DriveGetFileSystem($drivesfixed[$i]) & "|" & $LANG_NOTANALYZED & "|" & Round(DriveSpaceTotal($drivesfixed[$i]) / 1024, 2) & " GB" & "|" & Round(DriveSpaceFree($drivesfixed[$i]) / 1024, 2) & " GB" & "|" & Round(DriveSpaceFree($drivesfixed[$i]) * 100 / DriveSpaceTotal($drivesfixed[$i]),2) & "%")
		Endif
	Endif
Next
If $CmdLine[0] <> 0 Then ; If run with /flash, add flash and floppy drives
	If $CmdLine[1] = "/flash" AND $drivesremovable <> "" Then
		For $i = 1 to $drivesremovable[0]
		If DriveStatus($drivesremovable[$i]) = "READY" Then
			$a += 1
			$driveslisted[$a - 7] = $drivesremovable[$i]
			GUICtrlCreateListViewItem("",$listview)
			If DriveGetLabel($drivesremovable[$i]) <> "" Then
				GUICtrlSetData($a,StringUpper($drivesremovable[$i]) & " (" & DriveGetLabel($drivesremovable[$i]) & ")" & "|" & DriveGetFileSystem($drivesremovable[$i]) & "|" & $LANG_NOTANALYZED & "|" & Round(DriveSpaceTotal($drivesremovable[$i]) / 1024, 2) & " GB" & "|" & Round(DriveSpaceFree($drivesremovable[$i]) / 1024, 2) & " GB" & "|" & Round(DriveSpaceFree($drivesremovable[$i]) * 100 / DriveSpaceTotal($drivesremovable[$i]),2) & "%")
			Else
				GUICtrlSetData($a,StringUpper($drivesremovable[$i]) & "|" & DriveGetFileSystem($drivesremovable[$i]) & "|" & $LANG_NOTANALYZED & "|" & Round(DriveSpaceTotal($drivesremovable[$i]) / 1024, 2) & " GB" & "|" & Round(DriveSpaceFree($drivesremovable[$i]) / 1024, 2) & " GB" & "|" & Round(DriveSpaceFree($drivesremovable[$i]) * 100 / DriveSpaceTotal($drivesremovable[$i]),2) & "%")
			EndIf
		EndIf
		Next
	EndIf
EndIf
GUICtrlSetResizing($listview,110)
GUICtrlSetResizing($button1,834)
GUICtrlSetResizing($button2,834)
GUICtrlSetResizing($button3,834)
GUICtrlSetResizing($button4,836)
_GUICtrlListView_JustifyColumn($listview, 2, 1)
_GUICtrlListView_JustifyColumn($listview, 3, 1)
_GUICtrlListView_JustifyColumn($listview, 4, 1)
_GUICtrlListView_JustifyColumn($listview, 5, 1)
GUICtrlSetState(8,$GUI_FOCUS)
GUICtrlSetState($button4,$GUI_DISABLE)
GUISetState()
Do
  $msg = GUIGetMsg ()
	Select
	Case $msg = $button1 ; Analyze Button
			If GUICtrlRead(GUICtrlRead($listview)) <> "0" Then
				$selecteddrives = _GUICtrlListView_GetSelectedIndices($listview, True)
				For $i = 1 to $selecteddrives[0]
						$parameters = $parameters & " " & $driveslisted[$selecteddrives[$i] + 1]
				Next
				Run($EXE & " -l " & '"' & $LOG & '"' & " -q -a 1" & StringUpper($parameters))
				GUISetState(@SW_HIDE)
				WinWait($WINDOW,"",10)
				WinWaitClose($WINDOW)
				Sleep(500)
				If ProcessExists($EXE) Then
					Sleep(1000)
					If ProcessExists($EXE) Then
						ProcessClose($EXE)
						$PID = ProcessExists($EXE)
						If $PID Then ProcessClose($PID)
					EndIf
				EndIf
				If FileExists($LOG) Then ; Read %Fragmentation from the log file
					$logfile = FileOpen($LOG, 0)
					For $i = 1 to $selecteddrives[0]
						While 1
							$line = FileReadLine($logfile)
							If @error Then ExitLoop
							If StringInStr($line, "Total size of fragmented items:") Then
								$line = StringTrimRight( $line, 8)
								ExitLoop
							EndIf
						WEnd
						If StringRight( $line, 1) = "%" Then
							$line = StringTrimRight( $line, 1)
							Select
								Case StringIsFloat(StringRight( $line, 8)) = 1
									$line = StringRight( $line, 8)
								Case StringIsFloat(StringRight( $line, 7)) = 1
									$line = StringRight( $line, 7)
								Case StringIsFloat(StringRight( $line, 6)) = 1
									$line = StringRight( $line, 6)
							EndSelect
							GUICtrlSetData($selecteddrives[$i] + 8,"||" & Round($line,2) & "%")
						EndIf
					Next
					FileClose($logfile)
				EndIf
				GUICtrlSetState($button4,$GUI_ENABLE)
				GUISetState(@SW_SHOW)
				GUICtrlSetState($button3,$GUI_DEFBUTTON)
				GUICtrlSetState($listview,$GUI_FOCUS)
				$parameters = ""
			Else
				GUICtrlSetState($button3,$GUI_DEFBUTTON)
				GUICtrlSetState($listview,$GUI_FOCUS)
			EndIf
		Case $msg = $button2 ; Defragment Button
			If GUICtrlRead(GUICtrlRead($listview)) <> "0" Then
				$selecteddrives = _GUICtrlListView_GetSelectedIndices($listview, True)
				For $i = 1 to $selecteddrives[0]
						$parameters = $parameters & " " & $driveslisted[$selecteddrives[$i] + 1]
				Next
				Run($EXE & " -l " & '"' & $LOG & '"' & " -q -a 2" & StringUpper($parameters))
				GUISetState(@SW_HIDE)
				WinWait($WINDOW,"",10)
				WinWaitClose($WINDOW)
				Sleep(500)
				If ProcessExists($EXE) Then
					Sleep(1000)
					If ProcessExists($EXE) Then
						ProcessClose($EXE)
						$PID = ProcessExists($EXE)
						If $PID Then ProcessClose($PID)
					EndIf
				EndIf
				GUICtrlSetState($button4,$GUI_ENABLE)
				For $i = 1 to $selecteddrives[0]
					GUICtrlSetData($selecteddrives[$i] + 8,"||" & $LANG_DEFRAGMENTED)
				Next
				GUISetState(@SW_SHOW)
				GUICtrlSetState($listview,$GUI_FOCUS)
				GUICtrlSetState($button3,$GUI_DEFBUTTON)
				$parameters = ""
			Else
				GUICtrlSetState($listview,$GUI_FOCUS)
				GUICtrlSetState($button3,$GUI_DEFBUTTON)
			EndIf
		Case $msg = $button3 ; Defragment and Optimize Button
			If GUICtrlRead(GUICtrlRead($listview)) <> "0" Then
				$selecteddrives = _GUICtrlListView_GetSelectedIndices($listview, True)
				For $i = 1 to $selecteddrives[0]
						$parameters = $parameters & " " & $driveslisted[$selecteddrives[$i] + 1]
				Next
				Run($EXE & " -l " & '"' & $LOG & '"' & " -q -a 3" & StringUpper($parameters))
				GUISetState(@SW_HIDE)
				WinWait($WINDOW,"",10)
				WinWaitClose($WINDOW)
				Sleep(500)
				If ProcessExists($EXE) Then
					Sleep(1000)
					If ProcessExists($EXE) Then
						ProcessClose($EXE)
						$PID = ProcessExists($EXE)
						If $PID Then ProcessClose($PID)
					EndIf
				EndIf
				GUICtrlSetState($button4,$GUI_ENABLE)
				GUICtrlSetState($listview,$GUI_FOCUS)
				For $i = 1 to $selecteddrives[0]
					GUICtrlSetData($selecteddrives[$i] + 8,"||" & $LANG_DEFRAGMENTED)
				Next
				GUISetState(@SW_SHOW)
				$parameters = ""
			EndIf
		Case $msg = $button4 ; View Log Button
			If FileExists($LOG) Then
				If FileExists("..\..\..\Notepad++Portable\Notepad++Portable.exe") Then
					Run("..\..\..\Notepad++Portable\Notepad++Portable.exe" & ' "' & $LOG & '"')
				Else
					ShellExecute($LOG)
				EndIf
			EndIf
			GUICtrlSetState($button3,$GUI_DEFBUTTON)
			GUICtrlSetState($listview,$GUI_FOCUS)
		Case $msg = $listview
			GUICtrlSetState($button3,$GUI_DEFBUTTON)
   EndSelect
Until $msg = $GUI_EVENT_CLOSE
If DriveGetType(StringLeft(@WorkingDir,3)) = "CDROM" Then
	FileDelete($LOG)
EndIf