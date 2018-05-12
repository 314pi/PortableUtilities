/*
Modded GetSizeSilent to be silent as GetSizeSilent


______________________________________________________________________

                       File Functions Header v3.4
_____________________________________________________________________________

 2006 Shengalts Aleksander aka Instructor (Shengalts@mail.ru)

 See documentation for more information about the following functions.

 Usage in script:
 1. !include "FileFunc.nsh"
 2. [Section|Function]
      ${FileFunction} "Param1" "Param2" "..." $var
    [SectionEnd|FunctionEnd]


 FileFunction=[Locate|GetSizeSilent|DriveSpace|GetDrives|GetTime|GetFileAttributes|
               GetFileVersion|GetExeName|GetExePath|GetParameters|GetOptions|
               GetOptionsS|GetRoot|GetParent|GetFileName|GetBaseName|GetFileExt|
               BannerTrimPath|DirState|RefreshShellIcons]

_____________________________________________________________________________

                       Thanks to:
_____________________________________________________________________________

GetSizeSilent
	KiCHiK (Function "FindFiles")
DriveSpace
	sunjammer (Function "CheckSpaceFree")
GetDrives
	deguix (Based on his idea of Function "DetectDrives")
GetTime
	Takhir (Script "StatTest") and deguix (Function "FileModifiedDate")
GetFileVersion
	KiCHiK (Based on his example for command "GetDLLVersion")
GetParameters
	sunjammer (Based on his Function "GetParameters")
GetRoot
	KiCHiK (Based on his Function "GetRoot")
GetParent
	sunjammer (Based on his Function "GetParent")
GetFileName
	KiCHiK (Based on his Function "GetFileName")
GetBaseName
	comperio (Based on his idea of Function "GetBaseName")
GetFileExt
	opher (author)
RefreshShellIcons
	jerome tremblay (author)
*/


;_____________________________________________________________________________
;
;                         Macros
;_____________________________________________________________________________
;
; Change log window verbosity (default: 3=no script)
;
; Example:
; !include "FileFunc.nsh"
; !insertmacro Locate
; ${FILEFUNC_VERBOSE} 4   # all verbosity
; !insertmacro VersionCompare
; ${FILEFUNC_VERBOSE} 3   # no script

!ifndef FILEFUNCMOD_INCLUDED
!define FILEFUNCMOD_INCLUDED

!include Util.nsh

!macro GetSizeSilentCall _PATH _OPTIONS _RESULT1 _RESULT2 _RESULT3
	Push `${_PATH}`
	Push `${_OPTIONS}`
	${CallArtificialFunction} GetSizeSilent_
	Pop ${_RESULT1}
	Pop ${_RESULT2}
	Pop ${_RESULT3}
!macroend

!define GetSizeSilent `!insertmacro GetSizeSilentCall`
!define un.GetSizeSilent `!insertmacro GetSizeSilentCall`

!macro GetSizeSilent
!macroend

!macro un.GetSizeSilent
!macroend

!macro GetSizeSilent_	
	Exch $1
	Exch
	Exch $0
	Exch
	Push $2
	Push $3
	Push $4
	Push $5
	Push $6
	Push $7
	Push $8
	Push $9
	Push $R3
	Push $R4
	Push $R5
	Push $R6
	Push $R7
	Push $R8
	Push $R9
	ClearErrors

	StrCpy $R9 $0 1 -1
	StrCmp $R9 '\' 0 +3
	StrCpy $0 $0 -1
	goto -3
	IfFileExists '$0\*.*' 0 FileFunc_GetSizeSilent_error

	StrCpy $3 ''
	StrCpy $4 ''
	StrCpy $5 ''
	StrCpy $6 ''
	StrCpy $8 0
	StrCpy $R3 ''
	StrCpy $R4 ''
	StrCpy $R5 ''

	FileFunc_GetSizeSilent_option:
	StrCpy $R9 $1 1
	StrCpy $1 $1 '' 1
	StrCmp $R9 ' ' -2
	StrCmp $R9 '' FileFunc_GetSizeSilent_sizeset
	StrCmp $R9 '/' 0 -4

	StrCpy $9 -1
	IntOp $9 $9 + 1
	StrCpy $R9 $1 1 $9
	StrCmp $R9 '' +2
	StrCmp $R9 '/' 0 -3
	StrCpy $8 $1 $9
	StrCpy $8 $8 '' 2
	StrCpy $R9 $8 '' -1
	StrCmp $R9 ' ' 0 +3
	StrCpy $8 $8 -1
	goto -3
	StrCpy $R9 $1 2
	StrCpy $1 $1 '' $9

	StrCmp $R9 'M=' 0 FileFunc_GetSizeSilent_size
	StrCpy $4 $8
	goto FileFunc_GetSizeSilent_option

	FileFunc_GetSizeSilent_size:
	StrCmp $R9 'S=' 0 FileFunc_GetSizeSilent_gotosubdir
	StrCpy $6 $8
	goto FileFunc_GetSizeSilent_option

	FileFunc_GetSizeSilent_gotosubdir:
	StrCmp $R9 'G=' 0 FileFunc_GetSizeSilent_error
	StrCpy $7 $8
	StrCmp $7 '' +3
	StrCmp $7 '1' +2
	StrCmp $7 '0' 0 FileFunc_GetSizeSilent_error
	goto FileFunc_GetSizeSilent_option

	FileFunc_GetSizeSilent_sizeset:
	StrCmp $6 '' FileFunc_GetSizeSilent_default
	StrCpy $9 0
	StrCpy $R9 $6 1 $9
	StrCmp $R9 '' +4
	StrCmp $R9 ':' +3
	IntOp $9 $9 + 1
	goto -4
	StrCpy $5 $6 $9
	IntOp $9 $9 + 1
	StrCpy $1 $6 1 -1
	StrCpy $6 $6 -1 $9
	StrCmp $5 '' +2
	IntOp $5 $5 + 0
	StrCmp $6 '' +2
	IntOp $6 $6 + 0

	StrCmp $1 'B' 0 +4
	StrCpy $1 1
	StrCpy $2 bytes
	goto FileFunc_GetSizeSilent_default
	StrCmp $1 'K' 0 +4
	StrCpy $1 1024
	StrCpy $2 Kb
	goto FileFunc_GetSizeSilent_default
	StrCmp $1 'M' 0 +4
	StrCpy $1 1048576
	StrCpy $2 Mb
	goto FileFunc_GetSizeSilent_default
	StrCmp $1 'G' 0 FileFunc_GetSizeSilent_error
	StrCpy $1 1073741824
	StrCpy $2 Gb

	FileFunc_GetSizeSilent_default:
	StrCmp $4 '' 0 +2
	StrCpy $4 '*.*'
	StrCmp $7 '' 0 +2
	StrCpy $7 '1'

	StrCpy $8 1
	Push $0

	FileFunc_GetSizeSilent_nextdir:
	IntOp $8 $8 - 1
	Pop $R8
	FindFirst $0 $R7 '$R8\$4'
	IfErrors FileFunc_GetSizeSilent_show
	StrCmp $R7 '.' 0 FileFunc_GetSizeSilent_dir
	FindNext $0 $R7
	StrCmp $R7 '..' 0 FileFunc_GetSizeSilent_dir
	FindNext $0 $R7
	IfErrors 0 FileFunc_GetSizeSilent_dir
	FindClose $0
	goto FileFunc_GetSizeSilent_show

	FileFunc_GetSizeSilent_dir:
	IfFileExists '$R8\$R7\*.*' 0 FileFunc_GetSizeSilent_file
	IntOp $R5 $R5 + 1
	goto FileFunc_GetSizeSilent_findnext

	FileFunc_GetSizeSilent_file:
	StrCpy $R6 0
	StrCmp $5$6 '' 0 +3
	IntOp $R4 $R4 + 1
	goto FileFunc_GetSizeSilent_findnext
	FileOpen $9 '$R8\$R7' r
	IfErrors +3
	FileSeek $9 0 END $R6
	FileClose $9
	StrCmp $5 '' +2
	IntCmp $R6 $5 0 FileFunc_GetSizeSilent_findnext
	StrCmp $6 '' +2
	IntCmp $R6 $6 0 0 FileFunc_GetSizeSilent_findnext
	IntOp $R4 $R4 + 1
	System::Int64Op $R3 + $R6
	Pop $R3

	FileFunc_GetSizeSilent_findnext:
	FindNext $0 $R7
	IfErrors 0 FileFunc_GetSizeSilent_dir
	FindClose $0

	FileFunc_GetSizeSilent_show:
	StrCmp $5$6 '' FileFunc_GetSizeSilent_nosize
	System::Int64Op $R3 / $1
	Pop $9
	goto FileFunc_GetSizeSilent_subdir
	FileFunc_GetSizeSilent_nosize:
	
	FileFunc_GetSizeSilent_subdir:
	StrCmp $7 0 FileFunc_GetSizeSilent_preend
	FindFirst $0 $R7 '$R8\*.*'
	StrCmp $R7 '.' 0 FileFunc_GetSizeSilent_pushdir
	FindNext $0 $R7
	StrCmp $R7 '..' 0 FileFunc_GetSizeSilent_pushdir
	FindNext $0 $R7
	IfErrors 0 FileFunc_GetSizeSilent_pushdir
	FindClose $0
	StrCmp $8 0 FileFunc_GetSizeSilent_preend FileFunc_GetSizeSilent_nextdir

	FileFunc_GetSizeSilent_pushdir:
	IfFileExists '$R8\$R7\*.*' 0 +3
	Push '$R8\$R7'
	IntOp $8 $8 + 1
	FindNext $0 $R7
	IfErrors 0 FileFunc_GetSizeSilent_pushdir
	FindClose $0
	StrCmp $8 0 FileFunc_GetSizeSilent_preend FileFunc_GetSizeSilent_nextdir

	FileFunc_GetSizeSilent_preend:
	StrCmp $R3 '' FileFunc_GetSizeSilent_nosizeend
	System::Int64Op $R3 / $1
	Pop $R3
	FileFunc_GetSizeSilent_nosizeend:
	StrCpy $2 $R4
	StrCpy $1 $R5
	StrCpy $0 $R3
	goto FileFunc_GetSizeSilent_end

	FileFunc_GetSizeSilent_error:
	SetErrors
	StrCpy $0 ''
	StrCpy $1 ''
	StrCpy $2 ''

	FileFunc_GetSizeSilent_end:
	Pop $R9
	Pop $R8
	Pop $R7
	Pop $R6
	Pop $R5
	Pop $R4
	Pop $R3
	Pop $9
	Pop $8
	Pop $7
	Pop $6
	Pop $5
	Pop $4
	Pop $3
	Exch $2
	Exch
	Exch $1
	Exch 2
	Exch $0
!macroend

!endif