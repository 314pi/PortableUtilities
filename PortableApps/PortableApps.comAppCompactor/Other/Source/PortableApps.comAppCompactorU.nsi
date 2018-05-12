;Copyright (C) 2006-2018 John T. Haller
;Copyright (C) 2008 Harold E. Austin, Jr.

;Website: http://PortableApps.com/AppCompressor

;This software is OSI Certified Open Source Software.
;OSI Certified is a certification mark of the Open Source Initiative.

;This program is free software; you can redistribute it and/or
;modify it under the terms of the GNU General Public License
;as published by the Free Software Foundation; either version 2
;of the License, or (at your option) any later version.

;This program is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.

;You should have received a copy of the GNU General Public License
;along with this program; if not, write to the Free Software
;Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

!define APPNAME "PortableApps.com AppCompactor"
!define VER "3.4.1.0"
!define WEBSITE "PortableApps.com/AppCompactor"
!define FRIENDLYVER "3.4.1"

;=== Program Details
Name "${APPNAME}"
OutFile "..\..\PortableApps.comAppCompactor.exe"
Caption "${APPNAME}"
VIProductVersion "${VER}"
VIAddVersionKey ProductName "${APPNAME}"
VIAddVersionKey Comments "A simple app compression utility  For additional details, visit ${WEBSITE}"
VIAddVersionKey CompanyName "PortableApps.com"
VIAddVersionKey LegalCopyright "John T. Haller"
VIAddVersionKey FileDescription "${APPNAME}"
VIAddVersionKey FileVersion "${VER}"
VIAddVersionKey ProductVersion "${VER}"
VIAddVersionKey InternalName "${APPNAME}"
VIAddVersionKey LegalTrademarks "PortableApps.com is a trademark of Rare Ideas, LLC."
VIAddVersionKey OriginalFilename "PortableApps.comAppCompactor.exe"

;=== Runtime Switches
CRCCheck On
RequestExecutionLevel user
Unicode true
ManifestDPIAware false

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On

;=== Includes
!include MUI.nsh
!include Registry.nsh
!include FileFunc.nsh
!include LogicLib.nsh
!include RecFind.nsh
!include WordFunc.nsh
!insertmacro GetParameters
!insertmacro GetRoot
!insertmacro GetSize
!insertmacro WordFind
!include GetSizeSilent.nsh
!insertmacro GetSizeSilent
!include TBProgress.nsh

;=== Icon & Stye ===
!define MUI_ICON "..\..\App\AppInfo\appicon.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP header.bmp

BrandingText "PortableApps.com®"
InstallButtonText "Go >" 
ShowInstDetails show
SubCaption 3 " | Processing Files"

;===  !defines
!define UPXCOMPRESS	"--best --compress-icons=0 --crp-ms=999999 --backup"	;  for Wine: --compress-exports=0
!define EXTINCLUDE	"|exe|dll|irc|bin|pyd|"			;   extensions to UPX (without checking for MZ header)
!define EXTEXCLUDE	"|py|txt|ini|cfg|ico|"			;   extensions to avoid
!define FILEXCLUDE	"|msvcm110.dll|msvcp110.dll|msvcr110.dll|msvcm100.dll|msvcp100.dll|msvcr100.dll|msvcm90.dll|msvcp90.dll|msvcr90.dll|msvcm80.dll|msvcp80.dll|msvcr80.dll|msvcm71.dll|msvcp71.dll|msvcr71.dll|qgif4.dll|qico4.dll|qjpeg4.dll|qmng4.dll|qsvg4.dll|qtga4.dll|qtiff4.dll|"	;files to avoid
!define EXTZIP		"|zip|jar|"						;   extensions to re-ZIP
!define ZIPTEMP		"$PLUGINSDIR\PortableAppsCompactorRezipTemp"
!define FILESIZECUTOFF 4096 ;don't compress files 4K or smaller

;=== Variables
Var FINISHTEXT
Var FINISHTITLE
Var COMPRESSTYPENRV2E
Var COMPRESSTYPENRV2D
Var COMPRESSTYPELZMA
Var COMPRESSTYPEBRUTE
Var COMPRESSTYPEDECOMPRESS
Var RECOMPRESSJARZIP
Var COMPRESSDIRECTORY
Var SKIPWELCOMEPAGE
Var AUTOCLOSECOMMANDWINDOW
Var SIZEBEFORECOMPRESSING
Var SIZEAFTERCOMPRESSING
Var FILESBEFORECOMPRESSING
Var FILESAFTERCOMPRESSING
Var DIRSBEFORECOMPRESSING
Var DIRSAFTERCOMPRESSING
Var COMPRESSTYPE
Var EXCLUDEFILES
Var EXCLUDEEXTS
Var INCLUDEEXTS
Var UPXCMDLINE
Var ACTION
Var ACTIONDISPLAY
Var intFilesToProcess
Var intCurrentFileProcessing
Var intPercentDone
Var strAppCompressing
Var intFileSizeCutOff

;=== Pages
!define MUI_WELCOMEFINISHPAGE_BITMAP welcomefinish.bmp
!define MUI_WELCOMEFINISHPAGE_BITMAP_RTL welcomefinishrtl.bmp
!define MUI_HEADERIMAGE_RIGHT
!define MUI_WELCOMEPAGE_TITLE "PortableApps.com AppCompactor"
!define MUI_WELCOMEPAGE_TEXT "Welcome to the PortableApps.com AppCompactor utility.\r\n\r\nThis utility allows you to quickly and easily compact an application to save space and improve performance on portable devices. Just click Next to select the compression options...\r\n\r\nCompression Tip: As with any application modification, it's best to make a backup of the files before compressing."
!define MUI_PAGE_CUSTOMFUNCTION_PRE ShowWelcomeWindow
!insertmacro MUI_PAGE_WELCOME
Page custom ShowCompressionWindow LeaveCompressionWindow " | Compression Settings" 
Page instfiles
!define MUI_FINISHPAGE_TITLE "$FINISHTITLE"
!define MUI_FINISHPAGE_TEXT "$FINISHTEXT"
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_NOTCHECKED
!define MUI_FINISHPAGE_RUN_TEXT "Compress another app"
!define MUI_FINISHPAGE_RUN_FUNCTION "RunOnFinish"
!insertmacro MUI_PAGE_FINISH

;=== Languages
!insertmacro MUI_LANGUAGE "English"

Function .onInit
	!insertmacro MUI_INSTALLOPTIONS_EXTRACT "PortableApps.comAppCompactorForm.ini"
	
	;=== Check for settings.ini
	IfFileExists $EXEDIR\Data\settings.ini GetSettings
		CreateDirectory $EXEDIR\Data
		CopyFiles $EXEDIR\App\DefaultData\settings.ini $EXEDIR\Data
	
	GetSettings:
		ReadINIStr $COMPRESSTYPENRV2E "$EXEDIR\Data\settings.ini" "AppCompactor" "NRV2E"
		ReadINIStr $COMPRESSTYPENRV2D "$EXEDIR\Data\settings.ini" "AppCompactor" "NRV2D"
		ReadINIStr $COMPRESSTYPELZMA "$EXEDIR\Data\settings.ini" "AppCompactor" "LZMA"
		ReadINIStr $COMPRESSTYPEBRUTE "$EXEDIR\Data\settings.ini" "AppCompactor" "BRUTE"
		ReadINIStr $COMPRESSTYPEDECOMPRESS "$EXEDIR\Data\settings.ini" "AppCompactor" "DECOMPRESS"
		ReadINIStr $RECOMPRESSJARZIP "$EXEDIR\Data\settings.ini" "AppCompactor" "RecompressJarZip"
		ReadINIStr $SKIPWELCOMEPAGE "$EXEDIR\Data\settings.ini" "AppCompactor" "SkipWelcomePage"
		ReadINIStr $AUTOCLOSECOMMANDWINDOW "$EXEDIR\Data\settings.ini" "AppCompactor" "AutoCloseCommandWindow"
		WriteINIStr $PLUGINSDIR\PortableApps.comAppCompactorForm.ini "Field 2" "State" "$COMPRESSTYPENRV2E"
		WriteINIStr $PLUGINSDIR\PortableApps.comAppCompactorForm.ini "Field 3" "State" "$COMPRESSTYPENRV2D"
		WriteINIStr $PLUGINSDIR\PortableApps.comAppCompactorForm.ini "Field 4" "State" "$COMPRESSTYPELZMA"
		WriteINIStr $PLUGINSDIR\PortableApps.comAppCompactorForm.ini "Field 7" "State" "$COMPRESSTYPEBRUTE"
		WriteINIStr $PLUGINSDIR\PortableApps.comAppCompactorForm.ini "Field 9" "State" "$COMPRESSTYPEDECOMPRESS"
		WriteINIStr $PLUGINSDIR\PortableApps.comAppCompactorForm.ini "Field 8" "State" "$RECOMPRESSJARZIP"
		ReadINIStr $COMPRESSDIRECTORY "$EXEDIR\Data\settings.ini" "AppCompactor" "CompressDirectory"

	${GetParameters} $R0
	StrCmp $R0 "" PreFillForm
		StrCpy $COMPRESSDIRECTORY $R0
		StrCpy $SKIPWELCOMEPAGE "true"

	PreFillForm:
		;=== Pre-Fill Path with Directory
		WriteINIStr $PLUGINSDIR\PortableApps.comAppCompactorForm.ini "Field 6" "State" "$COMPRESSDIRECTORY"
FunctionEnd

Function ShowWelcomeWindow
	StrCmp $SKIPWELCOMEPAGE "true" "" ShowWelcomeWindowEnd
		Abort
	ShowWelcomeWindowEnd:
FunctionEnd

Function ShowCompressionWindow
!insertmacro MUI_HEADER_TEXT "PortableApps.com AppCompactor ${FRIENDLYVER}" "Easily Compress Portable Apps"
    InstallOptions::InitDialog /NOUNLOAD "$PLUGINSDIR\PortableApps.comAppCompactorForm.ini"
    Pop $0
    InstallOptions::Show
FunctionEnd

Function LeaveCompressionWindow
	;=== Blank
	ReadINIStr $COMPRESSTYPENRV2E $PLUGINSDIR\PortableApps.comAppCompactorForm.ini "Field 2" "State" 
	ReadINIStr $COMPRESSTYPENRV2D $PLUGINSDIR\PortableApps.comAppCompactorForm.ini "Field 3" "State" 
	ReadINIStr $COMPRESSTYPELZMA $PLUGINSDIR\PortableApps.comAppCompactorForm.ini "Field 4" "State" 
	ReadINIStr $COMPRESSTYPEBRUTE $PLUGINSDIR\PortableApps.comAppCompactorForm.ini "Field 7" "State" 
	ReadINIStr $COMPRESSTYPEDECOMPRESS $PLUGINSDIR\PortableApps.comAppCompactorForm.ini "Field 9" "State" 
	ReadINIStr $RECOMPRESSJARZIP $PLUGINSDIR\PortableApps.comAppCompactorForm.ini "Field 8" "State"
	ReadINIStr $COMPRESSDIRECTORY $PLUGINSDIR\PortableApps.comAppCompactorForm.ini "Field 6" "State"
	
	StrCmp $COMPRESSDIRECTORY "" NoCompressDirectory
	IfFileExists "$COMPRESSDIRECTORY\*.*" "" NoCompressDirectory
	
	${GetRoot} $COMPRESSDIRECTORY $R0
	StrCpy $R1 $R0 2
	${If} $R1 == "\\"
		MessageBox MB_OK|MB_ICONEXCLAMATION `UNC Paths (example: \\Server\Directory) are not supported by the PortableApps.com AppCompactor.  Please move the application to a local device or map a drive letter and select the application using that.`
		Abort
	${EndIf}
	
	WriteINIStr "$EXEDIR\Data\settings.ini" "AppCompactor" "NRV2E" $COMPRESSTYPENRV2E
	WriteINIStr "$EXEDIR\Data\settings.ini" "AppCompactor" "NRV2D" $COMPRESSTYPENRV2D
	WriteINIStr "$EXEDIR\Data\settings.ini" "AppCompactor" "LZMA" $COMPRESSTYPELZMA
	WriteINIStr "$EXEDIR\Data\settings.ini" "AppCompactor" "BRUTE" $COMPRESSTYPEBRUTE
	WriteINIStr "$EXEDIR\Data\settings.ini" "AppCompactor" "DECOMPRESS" $COMPRESSTYPEDECOMPRESS
	WriteINIStr "$EXEDIR\Data\settings.ini" "AppCompactor" "RecompressJarZip" $RECOMPRESSJARZIP
	WriteINIStr "$EXEDIR\Data\settings.ini" "AppCompactor" "CompressDirectory" $COMPRESSDIRECTORY
	Goto EndLeaveCompressionWindow
	
	NoCompressDirectory:
		MessageBox MB_OK|MB_ICONEXCLAMATION `Please select a valid directory to compress.`
		Abort

	EndLeaveCompressionWindow:
FunctionEnd

Section Main
	SetDetailsPrint none

	StrCmp $COMPRESSTYPEDECOMPRESS "1" 0 DetermineCompressionType
		StrCpy $UPXCMDLINE "-d"
		StrCpy $ACTION "uncompress"
		StrCpy $ACTIONDISPLAY "Uncompressing"
		Goto SetupProgressBar

	DetermineCompressionType:
		StrCmp $COMPRESSTYPENRV2D "1" 0 +3
			StrCpy $COMPRESSTYPE "nrv2d"
			Goto SetUPXCmdLine
		StrCmp $COMPRESSTYPELZMA "1" 0 +3
			StrCpy $COMPRESSTYPE "lzma"
			Goto SetUPXCmdLine
		StrCmp $COMPRESSTYPEBRUTE "1" 0 +3
			StrCpy $COMPRESSTYPE "brute"
			Goto SetUPXCmdLine
		StrCpy $COMPRESSTYPE "nrv2e"
		
	SetUPXCmdLine:
		StrCpy $UPXCMDLINE "${UPXCOMPRESS} --$COMPRESSTYPE"
		StrCpy $ACTION "compress"
		StrCpy $ACTIONDISPLAY "Compressing"

	SetupProgressBar:
		DetailPrint "Directory BEFORE: $COMPRESSDIRECTORY"
		IfFileExists "$COMPRESSDIRECTORY\App\*.*" 0 +2
			StrCpy $COMPRESSDIRECTORY "$COMPRESSDIRECTORY\App"
		SetOutPath $COMPRESSDIRECTORY
		
		ReadINIStr $0 "$COMPRESSDIRECTORY\AppInfo\AppCompactor.ini" "PortableApps.comAppCompactor" "AdditionalExtensionsExcluded"
		${If} $0 != ""
			StrCpy $EXCLUDEEXTS "|$0${EXTEXCLUDE}"
		${Else}
			StrCpy $EXCLUDEEXTS "${EXTEXCLUDE}"
		${EndIf}
		ReadINIStr $0 "$COMPRESSDIRECTORY\AppInfo\AppCompactor.ini" "PortableApps.comAppCompactor" "FilesExcluded"
		${If} $0 != ""
			StrCpy $EXCLUDEFILES "|$0${FILEXCLUDE}"
		${Else}
			StrCpy $EXCLUDEFILES "${FILEXCLUDE}"
		${EndIf}
		ReadINIStr $0 "$COMPRESSDIRECTORY\AppInfo\AppCompactor.ini" "PortableApps.comAppCompactor" "AdditionalExtensionsIncluded"
		${If} $0 != ""
			StrCpy $INCLUDEEXTS "|$0${EXTINCLUDE}"
		${Else}
			StrCpy $INCLUDEEXTS "${EXTINCLUDE}"
		${EndIf}
		ReadINIStr $0 "$COMPRESSDIRECTORY\AppInfo\AppCompactor.ini" "PortableApps.comAppCompactor" "CompressionFileSizeCutOff"
		${If} $0 < 4097
			StrCpy $intFileSizeCutOff 4096
		${Else}
			StrCpy $intFileSizeCutOff $0
		${EndIf}
		ReadINIStr $strAppCompressing "$COMPRESSDIRECTORY\AppInfo\AppInfo.ini" "Details" "Name"
		ClearErrors
		SetDetailsPrint ListOnly
		${If} $INCLUDEEXTS != ${EXTINCLUDE}
			DetailPrint "Included Extensions: = $INCLUDEEXTS"
		${EndIf}
		${If} $EXCLUDEEXTS != ${EXTEXCLUDE}
			DetailPrint "Excluded Extensions: = $EXCLUDEEXTS"
		${EndIf}
		${If} $EXCLUDEFILES != ${FILEXCLUDE}
			DetailPrint "Excluded Files: = $EXCLUDEFILES"
		${EndIf}

;		DetailPrint "WARNING: The details window is shown.  Closing it will abort the process."
		;DetailPrint " "
		DetailPrint "Processing: $COMPRESSDIRECTORY"
		${If} $strAppCompressing != ""
			DetailPrint "Application: $strAppCompressing"
		${EndIf} 
		DetailPrint " "
		;FindWindow $0 "#32770" "" $HWNDPARENT
		;FindWindow $1 "msctls_progress32" "" $0
		;RealProgress::UseProgressBar /NOUNLOAD $1
		RealProgress::SetProgress /NOUNLOAD 0
		${TBProgress} 0
		;RealProgress::GradualProgress /NOUNLOAD 2 1 90 "done."
		SetDetailsPrint both
		DetailPrint "Indexing files..."
		;=== Determine size before compressing
		${GetSize} `$COMPRESSDIRECTORY` "/M=*.* /S=0K /G=1" $SIZEBEFORECOMPRESSING $FILESBEFORECOMPRESSING $DIRSBEFORECOMPRESSING ;=== Current installation size
		SetDetailsPrint ListOnly
		DetailPrint "Size before: $SIZEBEFORECOMPRESSING KB  ($FILESBEFORECOMPRESSING files in $DIRSBEFORECOMPRESSING directories)"
		SetDetailsPrint both
		DetailPrint "Determining files to process..."
		SetDetailsPrint none
		StrCpy $intFilesToProcess 1
		${RecFindOpen} "." $0 $1					;   $0 = current dir;  $1 = current file
		${RecFindFirst}
		${WordFind} "$EXCLUDEFILES" "|$1|" "E+1{" $2
		IfErrors 0 CountNextFile
		${WordFind} "$1" "." -1 $2					;   $2 = current file extension
;		DetailPrint "ext=[$2]"
		${WordFind} ${EXTZIP} "|$2|" "E+1{" $3
		IfErrors +3
			StrCmp $ACTION "uncompress" +2
				StrCmp $RECOMPRESSJARZIP 1 CountCheckSize		
		${WordFind} "$EXCLUDEEXTS" "|$2|" "E+1{" $3
		IfErrors 0 CountNextFile
		${WordFind} "$INCLUDEEXTS" "|$2|" "E+1{" $3
		IfErrors 0 CountCheckSize
		Goto CountNextFile
			
		CountCheckSize:
			StrCmp $ACTION "uncompress" CountThisFile
			${GetSizeSilent} `$COMPRESSDIRECTORY$0` "/M=$1 /S=0B /G=0" $R1 $R2 $R3
			;MessageBox MB_OK|MB_ICONEXCLAMATION "`$COMPRESSDIRECTORY$0` `/M=$1 /S=0B /G=0` $R1 $R2 $R3"
			IntCmp $R1 $intFileSizeCutOff CountNextFile CountNextFile CountThisFile
		
		CountThisFile:
			;MessageBox MB_OK|MB_ICONINFORMATION "$2 - $3 - $ACTION - $RECOMPRESSJARZIP"
			IntOp $intFilesToProcess $intFilesToProcess + 1
			
		CountNextFile:
			SetDetailsPrint ListOnly
			${RecFindNext}
		${RecFindClose}
			
		SetDetailsPrint both
		DetailPrint " "
		${If} $strAppCompressing != ""
			DetailPrint "Processing binary files ($strAppCompressing)..."
		${Else}
			DetailPrint "Processing binary files..."
		${EndIf} 
		SetDetailsPrint ListOnly
		StrCpy $intCurrentFileProcessing 0
		
	ProcessFiles:
		${RecFindOpen} "." $0 $1					;   $0 = current dir;  $1 = current file
		${RecFindFirst}
;		DetailPrint "File: .$0\$1"
		
		IntOp $intCurrentFileProcessing $intCurrentFileProcessing * 100
		IntOp $intPercentDone $intCurrentFileProcessing / $intFilesToProcess
		IntOp $intCurrentFileProcessing $intCurrentFileProcessing / 100
		RealProgress::SetProgress /NOUNLOAD $intPercentDone
		${TBProgress} $intPercentDone
		
		${WordFind} "$EXCLUDEFILES" "|$1|" "E+1{" $2
		IfErrors +3
			DetailPrint "Skipping: $0\$1 (appinfo.ini exclusion)"
			Goto NextFile
		${WordFind} "$1" "." -1 $2					;   $2 = current file extension
;		DetailPrint "ext=[$2]"
		${WordFind} ${EXTZIP} "|$2|" "E+1{" $3
		IfErrors +2
			StrCmp $ACTION "recompress" CheckSize NextFile
		StrCmp $ACTION "recompress" NextFile
		${WordFind} "$EXCLUDEEXTS" "|$2|" "E+1{" $3
		IfErrors 0 NextFile
		${WordFind} "$INCLUDEEXTS" "|$2|" "E+1{" $3
		IfErrors 0 CheckSize

			Goto NextFile
			;ClearErrors
			;FileOpen $4 ".$0\$1" r
			;IfErrors 0 +3
			;	DetailPrint "Skipping: $0\$1 (unable to open)"
			;	Goto NextFile
			;FileRead $4 $3 2
			;FileClose $4
			;StrCmp $3 "MZ" CompressFile NextFile
		CheckSize:
			StrCmp $ACTION "uncompress" CompressFile
			${GetSizeSilent} `$COMPRESSDIRECTORY$0` "/M=$1 /S=0B /G=0" $R1 $R2 $R3
			;MessageBox MB_OK|MB_ICONEXCLAMATION "`$COMPRESSDIRECTORY$0` `/M=$1 /S=0B /G=0` $R1 $R2 $R3"
			IntCmp $R1 $intFileSizeCutOff NextFile NextFile CompressFile
			
		CompressFile:
			StrCmp $ACTION "recompress" RecompressZIP
			DetailPrint "$ACTIONDISPLAY: $0\$1"
			nsExec::ExecToStack `"$EXEDIR\App\bin\upx.exe" $UPXCMDLINE ".$0\$1"`
			Pop $3  ;    exit code
			Pop $R3	;    UPX output
			IntOp $intCurrentFileProcessing $intCurrentFileProcessing + 1
			StrCmp $3 "error" 0 +6
				MessageBox MB_OK|MB_ICONEXCLAMATION "Unable to execute UPX ($EXEDIR\App\bin\upx.exe)$\n$\nTry reinstalling ${APPNAME}."
				DetailPrint " "
				DetailPrint "***  Aborted!  ***"
				RealProgress::SetProgress /NOUNLOAD 100
				Abort
			StrCmp $3 "0" UPX_Exec_OK
				${WordFind} "$R3" "$\n" +7 $R3		;   7th line of output
				${WordFind} "$R3" ": " -1 $R3		;   last field
				StrCpy $R3 $R3 -1					;   trim CR
				DetailPrint "  ^-- Skipped: $R3"
				Goto NextFile
			UPX_Exec_OK:
			StrCmp $COMPRESSTYPEDECOMPRESS "1" NextFile
				StrCpy $2 $1 -1						;   $2 = left(filename,len(filename)-1)
				SetDetailsPrint ListOnly
				nsExec::ExecToStack `"$EXEDIR\App\bin\upx.exe" -t ".$0\$1"`
				Pop $3	;   exit code
				Pop $R3	;   UPX output
				StrCmp $3 "error" CompressError
				StrCmp $3 "0" 0 CompressError
					SetDetailsPrint none
					Delete ".$0\$2~"
					Goto NextFile
			CompressError:
				${WordFind} "$R3" "$\n" +7 $R3		;   7th line of output
				${WordFind} "$R3" ": " -1 $R3		;   last field
				StrCpy $R3 $R3 -1					;   trim CR
				DetailPrint "  ^-- Skipped: $R3"
				SetDetailsPrint none
				Delete ".$0\$1"
				Rename ".$0\$2~" ".$0\$1"
				Goto NextFile
		RecompressZIP:
			DetailPrint "Recompressing: $0\$1"
			;DetailPrint "          Extracting..."
			SetDetailsPrint none
			RMDir /r ${ZIPTEMP}
			CreateDirectory ${ZIPTEMP}
			SetDetailsPrint ListOnly
			nsExec::Exec `"$EXEDIR\App\bin\7za.exe" x ".$0\$1" -o"${ZIPTEMP}"`
			Pop $3	;   exit code
			StrCmp $3 "error" 0 +6
				MessageBox MB_OK|MB_ICONEXCLAMATION "Unable to execute 7-Zip ($EXEDIR\App\bin\7za.exe)$\n$\nTry reinstalling ${APPNAME}."
				DetailPrint " "
				DetailPrint "***  Aborted!  ***"
				RealProgress::SetProgress /NOUNLOAD 100
				Abort
			;DetailPrint "          Compressing..."
			nsExec::Exec `"$EXEDIR\App\bin\7za.exe" a -tzip ".$0\$1~" "${ZIPTEMP}\*" -r -mx=7`
			Pop $3	;   exit code
			IntOp $intCurrentFileProcessing $intCurrentFileProcessing + 1
			StrCmp $3 "error" RecompressError
			StrCmp $3 "0" 0 RecompressError
				nsExec::Exec `"$EXEDIR\App\bin\7za.exe" t  ".$0\$1~"`
				Pop $3
				StrCmp $3 "error" RecompressError
				StrCmp $3 "0" 0 RecompressError
					SetDetailsPrint none
					Delete ".$0\$1"
					Rename ".$0\$1~" ".$0\$1"
					Goto NextFile
			RecompressError:
				DetailPrint "  ^-- Skipped: Recompression issue"
				SetDetailsPrint none
				Delete ".$0\$1~"
		NextFile:
			SetDetailsPrint ListOnly
			${RecFindNext}
		${RecFindClose}
		
		StrCmp $ACTION "compress" 0 CompressionDone
		StrCmp $RECOMPRESSJARZIP "1" 0 CompressionDone
			DetailPrint "done;"
			DetailPrint " "
			SetDetailsPrint both
			${If} $strAppCompressing != ""
				DetailPrint "Processing JAR and ZIP files ($strAppCompressing)..."
			${Else}
				DetailPrint "Processing JAR and ZIP files..."
			${EndIf} 
			SetDetailsPrint ListOnly
			StrCpy $ACTION "recompress"
			Goto ProcessFiles

	CompressionDone:
		SetDetailsPrint none
		RMDir /r ${ZIPTEMP}
		SetDetailsPrint ListOnly
		DetailPrint "done."
		DetailPrint " "
		;=== Get Size after compressing
		DetailPrint "Verifying file and directory counts..."
		${GetSize} `$COMPRESSDIRECTORY` "/M=*.* /S=0K /G=1" $SIZEAFTERCOMPRESSING $FILESAFTERCOMPRESSING $DIRSAFTERCOMPRESSING ;=== Current installation size
		SetDetailsPrint none
		;IntOp $DIRSBEFORECOMPRESSING $DIRSBEFORECOMPRESSING + 1
		;IntOp $DIRSAFTERCOMPRESSING $DIRSAFTERCOMPRESSING + 1
		IntCmp $FILESBEFORECOMPRESSING $FILESAFTERCOMPRESSING "" CompressionSuccessfulWithError CompressionSuccessfulWithError
		IntCmp $DIRSBEFORECOMPRESSING $DIRSAFTERCOMPRESSING CompressionSuccessfulWithoutError CompressionSuccessfulWithError CompressionSuccessfulWithError
			
	CompressionSuccessfulWithError:
		${If} $strAppCompressing != ""
			StrCpy $FINISHTITLE "An Error Occured\r\n($strAppCompressing)"
		${Else}
			StrCpy $FINISHTITLE "An Error Occured"
		${EndIf} 
		StrCpy $FINISHTEXT "ERROR: The numbers of files or directories changed.  Some files may be missing or temp files may be left behind.\r\n" 
		IntOp $0 $SIZEBEFORECOMPRESSING - $SIZEAFTERCOMPRESSING
		StrCpy $FINISHTEXT "$FINISHTEXTSize Before: $SIZEBEFORECOMPRESSING Kb ($FILESBEFORECOMPRESSING files in $DIRSBEFORECOMPRESSING directories)\r\nSize After: $SIZEAFTERCOMPRESSING Kb ($FILESAFTERCOMPRESSING files in $DIRSAFTERCOMPRESSING directories)\r\nSpace Saved: $0 Kb"
		Goto TheEnd
	
	CompressionSuccessfulWithoutError:
		${If} $strAppCompressing != ""
			StrCpy $FINISHTITLE "Processing Complete\r\n($strAppCompressing)"
		${Else}
			StrCpy $FINISHTITLE "Processing Complete"
		${EndIf} 
		IntOp $0 $SIZEBEFORECOMPRESSING - $SIZEAFTERCOMPRESSING
		StrCpy $FINISHTEXT "$FINISHTEXTSize Before: $SIZEBEFORECOMPRESSING Kb ($FILESBEFORECOMPRESSING files in $DIRSBEFORECOMPRESSING directories)\r\nSize After: $SIZEAFTERCOMPRESSING Kb\r\nSpace Saved: $0 Kb\r\n\r\n"
		StrCpy $FINISHTEXT "$FINISHTEXTPlease verify that all files are working properly."
		Goto TheEnd
	
	TheEnd:
		RealProgress::SetProgress /NOUNLOAD 100
		${TBProgress_State} NoProgress 
SectionEnd

Function RunOnFinish
	Exec `$EXEDIR\PortableApps.comAppCompactor.exe`
FunctionEnd

Function .onGUIEnd
	RealProgress::Unload
FunctionEnd