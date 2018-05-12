!macro CustomCodePostInstall
	${If} ${FileExists} "$INSTDIR\Data\settings\FreeCommander.ini"
		${IfNot} ${FileExists} "$INSTDIR\Data\settings\ColorSchemas\*.*"
			CreateDirectory "$INSTDIR\Data\settings\ColorSchemas"
			CopyFiles /SILENT "$INSTDIR\App\DefaultData\settings\ColorSchemas\*.*" "$INSTDIR\Data\settings\ColorSchemas"
		${EndIf}
	${EndIf}
!macroend
