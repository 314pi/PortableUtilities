!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\Data\settings"
	${AndIfNot} ${FileExists} "$INSTDIR\Data\ffs"
		CreateDirectory "$INSTDIR\Data\ffs"
		CreateDirectory "$INSTDIR\Data\deletions"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\Data\settings\LastRun.ffs_gui"
		Rename "$INSTDIR\Data\settings\LastRun.ffs_gui" "$INSTDIR\Data\ffs\LastRun.ffs_gui"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\Data\settings\LastRun.ffs_gui"
		Rename "$INSTDIR\Data\settings\LastSyncs.log" "$INSTDIR\Data\ffs\LastSyncs.log"
	${EndIf}
!macroend