#################################################################################################
# RecFind.nsh - Recursive FindFirst, FindNext, FindClose.
#  by Afrow UK
#
# Last modified 5th July 2005

; Usage:
; ------------------------------------------------------------
; ${RecFindOpen} "Dir\Path" $CurrentDirVar $CurrentFileVar
;  ... Do stuff with $CurrentDirVar ...
; ${RecFindFirst}
;  ... Do stuff with $CurrentFileVar ...
; ${RecFindNext}
; ${RecFindClose}

; Notes:
; ------------------------------------------------------------

; Looping is handled by the macro's internally.

; ${RecFindOpen} opens a search in a new directory in the tree.
;  The macro's will loop back to this instruction when a new
;  directory is opened for searching.

; ${RecFindFirst} gets file names out of the current directory.
;  The macro's will loop back to this instruction when a new file
;  is found.

; ${RecFindNext} gets the next file in the current directory, and loops to
;  ${RecFindFirst} again.

; ${RecFindClose} closes the search and clears the stack.

; Example 1:
; ------------------------------------------------------------
; ${RecFindOpen} "C:\Dir" $R0 $R1
;  DetailPrint "Dir: C:\Dir$R0"
; ${RecFindFirst}
;  DetailPrint "File: C:\Dir$R0\$R1"
; ${RecFindNext}
; ${RecFindClose}

; Example 2:
; ------------------------------------------------------------
; ${RecFindOpen} "C:\Dir" $R0 $R1
;  DetailPrint "Dir: C:\Dir$R0"
; ${RecFindFirst}
;  DetailPrint "File: C:\Dir$R0\$R1"
;  StrCmp $R1 "a_file.txt" Found
; ${RecFindNext}
;  Found:
; ${RecFindClose}

#################################################################################################

!ifndef RecFind-Included
!define RecFind-Included

Var RecFindVar1
Var RecFindVar2

!macro RecFindOpen DirVar CurrentDirVar CurrentFileVar

 !define Local       "${__LINE__}"
 !define Dir         "${DirVar}"
 !define CurrentDir  "${CurrentDirVar}"
 !define CurrentFile "${CurrentFileVar}"

  !define RecFindOpenSet

 StrCpy $RecFindVar2 1
 Push ""

 "nextDir${Local}:"
 Pop "${CurrentDir}"
 IntOp $RecFindVar2 $RecFindVar2 - 1

!macroend
!define RecFindOpen "!insertmacro RecFindOpen"

!macro RecFindFirst

 !ifndef RecFindOpenSet
  !error "Incorrect use of RecFind commands!"
 !else
  !define RecFindFirstSet
 !endif

 ClearErrors
 FindFirst $RecFindVar1 "${CurrentFile}" "${Dir}${CurrentDir}\*.*"
 IfErrors "Done${Local}"

  "checkFile${Local}:"
  StrCmp ${CurrentFile} .  "nextFile${Local}"
  StrCmp ${CurrentFile} .. "nextFile${Local}"

  IfFileExists "${Dir}${CurrentDir}\${CurrentFile}\*.*" 0 +4
   Push "${CurrentDir}\${CurrentFile}"
   IntOp $RecFindVar2 $RecFindVar2 + 1
    Goto "nextFile${Local}"

!macroend
!define RecFindFirst "!insertmacro RecFindFirst"

!macro RecFindNext

 !ifndef RecFindOpenSet | RecFindFirstSet
  !error "Incorrect use of RecFind commands!"
 !else
  !define RecFindNextSet
 !endif

 "nextFile${Local}:"

 ClearErrors
 FindNext $RecFindVar1 "${CurrentFile}"
 IfErrors 0 "checkFile${Local}"

 StrCmp $RecFindVar2 0 +3
 FindClose $RecFindVar1
 Goto "nextDir${Local}"

!macroend
!define RecFindNext "!insertmacro RecFindNext"

!macro RecFindClose

 !ifndef RecFindOpenSet | RecFindFirstSet | RecFindNextSet
  !error "Incorrect use of RecFind commands!"
 !else
  !undef RecFindOpenSet
  !undef RecFindFirstSet
  !undef RecFindNextSet
 !endif

 "Done${Local}:"
 FindClose $RecFindVar1

 StrCmp $RecFindVar2 0 +4
  Pop $RecFindVar1
  IntOp $RecFindVar2 $RecFindVar2 - 1
  Goto -3

 !undef CurrentFile
 !undef CurrentDir
 !undef Dir
 !undef Local

!macroend
!define RecFindClose "!insertmacro RecFindClose"

!endif