!addplugindir `${PACKAGE}\Other\Source\Plugins`

${SegmentFile}

;=== START INTEGRITY CHECK 1.1 Var
	Var bolCustomIntegrityCheckStartUnsupported
	Var strCustomIntegrityCheckVersion
;=== END INTEGRITY CHECK

Var Exists_LEGACY_SMARTDEFRAGDRIVER
Var Exists_Services_SmartDefragBootTime
Var Exists_Services_SmartDefragDriver
Var Exists_SmartDefrag3_Update_Scheduled_Task
Var Exists_SmartDefrag_AutoAnalyze_Scheduled_Task
Var Exists_SmartDefrag_Update_Scheduled_Task


${Segment.OnInit}
	;=== START INTEGRITY CHECK 1.1 OnInit
	;Check for improper install/upgrade without running the PA.c Installer which can cause issues
	;Designed to not require ReadINIStrWithDefault which is not included in the PA.c Launcher code
	
	${If} ${FileExists} "$EXEDIR\App\AppInfo\appinfo.ini"
		${If} ${FileExists} "$EXEDIR\App\AppInfo\pac_installer_log.ini"
			ReadINIStr $R0 "$EXEDIR\App\AppInfo\pac_installer_log.ini" "PortableApps.comInstaller" "Info2"
			${If} $R0 == "This file was generated by the PortableApps.com Installer wizard and modified by the official PortableApps.com Installer TM Rare Ideas, LLC as the app was installed."
				StrCpy $R1 "true"
			${Else}
				StrCpy $R1 "false"
			${EndIf}
		${Else}
			StrCpy $R1 "false"
		${EndIf}
	${Else}
		StrCpy $R1 "true"
	${EndIf}
	
	${If} $R1 == "false"
		;Upgrade or install sans the PortableApps.com Installer which can cause compatibility issues
		ClearErrors
		ReadINIStr $0 "$EXEDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${If} ${Errors}
		${OrIf} $0 == ""
			StrCpy $0 "0.0.0.1"
			ClearErrors
		${EndIf}

		ClearErrors
		ReadINIStr $1 "$EXEDIR\Data\settings\${AppID}Settings.ini" "${AppID}Settings" "InvalidPackageWarningShown"
		${If} ${Errors}
		${OrIf} $1 == ""
			StrCpy $1 "0.0.0.0"
			ClearErrors
		${EndIf}

		${VersionCompare} $0 $1 $2
		${If} $2 == 1		
			MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 `Integrity Failure Warning: ${NamePortable} was installed or upgraded without using its installer and some critical files may have been modified.  This could cause data loss, personal data left behind on a shared PC, functionality issues, and/or may be a violation of the application's license. Neither the application publisher nor PortableApps.com will be responsible for any issues you encounter.$\r$\n$\r$\nWould you like to start ${NamePortable} in its current unsupported state?` IDYES CustomIntegrityCheckGotoStartAnyway IDNO CustomIntegrityCheckGotoDownloadQuestion
		
			CustomIntegrityCheckGotoDownloadQuestion:
			;Check to ensure we have a valid homepage before asking the user
			StrCpy $R0 ""
			${If} ${FileExists} "$EXEDIR\App\AppInfo\appinfo.ini"
				ReadINIStr $R0 "$EXEDIR\App\AppInfo\appinfo.ini" "Details" "Homepage"
			${EndIf}
			
			${If} $R0 == ""
				Abort
			${Else}
				StrCpy $R1 $R0 4
				${If} $R1 != "http"
				${AndIf} $R1 != "HTTP"
					StrCpy $R0 "http://$R0"
				${EndIf}
			${EndIf}
			
			MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON1 `Would you like to visit the ${NamePortable} homepage to download the app and upgrade your current install?` IDYES CustomIntegrityCheckGotoURL IDNO CustomIntegrityCheckGotoAbort

			CustomIntegrityCheckGotoURL:		
			ExecShell "open" $R0
			Abort
						
			CustomIntegrityCheckGotoAbort:
			Abort
	
			CustomIntegrityCheckGotoStartAnyway:
			StrCpy $bolCustomIntegrityCheckStartUnsupported true
			StrCpy $strCustomIntegrityCheckVersion $0
		${EndIf}
	${EndIf}
	;=== END INTEGRITY CHECK
!macroend

${SegmentPrePrimary}
	;=== START INTEGRITY CHECK 1.1 PrePrimary
	${If} $bolCustomIntegrityCheckStartUnsupported == true
		WriteINIStr "$EXEDIR\Data\settings\${AppID}Settings.ini" "${AppID}Settings" "InvalidPackageWarningShown" $strCustomIntegrityCheckVersion
	${EndIf}	
	;=== END INTEGRITY CHECK

	${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\SmartDefragBootTime" $R0
	${If} $R0 = 0
		StrCpy $Exists_Services_SmartDefragBootTime true
	${EndIf}
	
	${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\SmartDefragDriver" $R0
	${If} $R0 = 0
		StrCpy $Exists_Services_SmartDefragDriver true
	${EndIf}
	
	${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_SMARTDEFRAGDRIVER" $R0
	${If} $R0 = 0
		StrCpy $Exists_LEGACY_SMARTDEFRAGDRIVER true
	${EndIf}

	${If} ${FileExists} "$SYSDIR\Tasks\SmartDefrag3_Update"
		StrCpy $Exists_SmartDefrag3_Update_Scheduled_Task true
	${EndIf}
	
	${If} ${FileExists} "$SYSDIR\Tasks\SmartDefrag_AutoAnalyze"
		StrCpy $Exists_SmartDefrag_AutoAnalyze_Scheduled_Task true
	${EndIf}
	
	${If} ${FileExists} "$SYSDIR\Tasks\SmartDefrag_Update"
		StrCpy $Exists_SmartDefrag_Update_Scheduled_Task true
	${EndIf}
	
	Rename "$WINDIR\Tasks\SmartDefrag3_Update.job" "$WINDIR\Tasks\SmartDefrag3_Update-BackUpBySmartDefragPortable.job"
	Rename "$WINDIR\Tasks\SmartDefrag4_Update.job" "$WINDIR\Tasks\SmartDefrag4_Update-BackUpBySmartDefragPortable.job"
	Rename "$WINDIR\Tasks\SmartDefrag5_Update.job" "$WINDIR\Tasks\SmartDefrag5_Update-BackUpBySmartDefragPortable.job"
	Rename "$WINDIR\Tasks\SmartDefrag_Schedule.job" "$WINDIR\Tasks\SmartDefrag_Schedule-BackUpBySmartDefragPortable.job"
	Rename "$WINDIR\Tasks\SmartDefrag_Startup.job" "$WINDIR\Tasks\SmartDefrag_Startup-BackUpBySmartDefragPortable.job"
	Rename "$WINDIR\Tasks\SmartDefragUpdate.job" "$WINDIR\Tasks\SmartDefragUpdate-BackUpBySmartDefragPortable.job"
	Rename "$WINDIR\system32\drivers\SmartDefragDriver.sys" "$WINDIR\system32\drivers\SmartDefragDriver-BackUpBySmartDefragPortable.sys"
	Rename "$WINDIR\system32\SmartDefragBootTime.exe" "$WINDIR\system32\SmartDefragBootTime-BackUpBySmartDefragPortable.exe"
	;Rename "$WINDIR\system32\IObitSmartDefragExtension.dll" "$WINDIR\system32\IObitSmartDefragExtension-BackUpBySmartDefragPortable.dll"
!macroend

${SegmentPostPrimary}
	${IfNot} $Exists_LEGACY_SMARTDEFRAGDRIVER == true
		${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_SMARTDEFRAGDRIVER" $R0
		${If} $R0 = 0
			AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Enum\Root\LEGACY_SMARTDEFRAGDRIVER" "(BU)" "FullAccess"
			Pop $R0
			${If} $R0 == error
				Pop $R0
				;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
			${Else}
				${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_SMARTDEFRAGDRIVER" $R0
			${EndIf}
		${EndIf}
	${EndIf}
	
	${IfNot} $Exists_Services_SmartDefragDriver == true
		${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\SmartDefragDriver" $R0
		${If} $R0 = 0
			AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Services\SmartDefragDriver" "(BU)" "FullAccess"
			Pop $R0
			${If} $R0 == error
				Pop $R0
				;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
			${Else}
				${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Services\SmartDefragDriver" $R0
			${EndIf}
		${EndIf}
	${EndIf}

	${IfNot} $Exists_Services_SmartDefragBootTime == true
		${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\SmartDefragBootTime" $R0
		${If} $R0 = 0
			AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Services\SmartDefragBootTime" "(BU)" "FullAccess"
			Pop $R0
			${If} $R0 == error
				Pop $R0
				;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
			${Else}
				${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Services\SmartDefragBootTime" $R0
			${EndIf}
		${EndIf}
	${EndIf}
	
	
	${If} $Exists_SmartDefrag3_Update_Scheduled_Task != true
		nsExec::Exec /TIMEOUT=10000 `"schtasks.exe" /delete /tn SmartDefrag3_Update /f`
		Pop $0
	${EndIf}
	
	${If} $Exists_SmartDefrag_AutoAnalyze_Scheduled_Task != true
		nsExec::Exec /TIMEOUT=10000 `"schtasks.exe" /delete /tn SmartDefrag_AutoAnalyze /f`
		Pop $0
	${EndIf}
	
	${If} $Exists_SmartDefrag_Update_Scheduled_Task != true
		nsExec::Exec /TIMEOUT=10000 `"schtasks.exe" /delete /tn SmartDefrag_Update /f`
		Pop $0
	${EndIf}	
	
	Delete "$WINDIR\Tasks\SmartDefrag_Schedule.job"
	Delete "$WINDIR\Tasks\SmartDefrag_Startup.job"
	Delete "$WINDIR\Tasks\SmartDefragUpdate.job"
	Delete "$WINDIR\Tasks\SmartDefrag3_Update.job"
	Rename "$WINDIR\Tasks\SmartDefrag3_Update-BackUpBySmartDefragPortable.job" "$WINDIR\Tasks\SmartDefrag3_Update.job"
	Delete "$WINDIR\Tasks\SmartDefrag4_Update.job"
	Rename "$WINDIR\Tasks\SmartDefrag4_Update-BackUpBySmartDefragPortable.job" "$WINDIR\Tasks\SmartDefrag4_Update.job"
	Delete "$WINDIR\Tasks\SmartDefrag5_Update.job"
	Rename "$WINDIR\Tasks\SmartDefrag5_Update-BackUpBySmartDefragPortable.job" "$WINDIR\Tasks\SmartDefrag5_Update.job"
	Rename "$WINDIR\Tasks\SmartDefrag_Schedule-BackUpBySmartDefragPortable.job" "$WINDIR\Tasks\SmartDefrag_Schedule.job"
	Rename "$WINDIR\Tasks\SmartDefrag_Startup-BackUpBySmartDefragPortable.job" "$WINDIR\Tasks\SmartDefrag_Startup.job"
	Rename "$WINDIR\Tasks\SmartDefragUpdate-BackUpBySmartDefragPortable.job" "$WINDIR\Tasks\SmartDefragUpdate.job"
	Delete "$WINDIR\system32\drivers\SmartDefragDriver.sys"
	Rename "$WINDIR\system32\drivers\SmartDefragDriver-BackUpBySmartDefragPortable.sys" "$WINDIR\system32\drivers\SmartDefragDriver.sys"
	Delete "$WINDIR\system32\SmartDefragBootTime.exe"
	Rename "$WINDIR\system32\SmartDefragBootTime-BackUpBySmartDefragPortable.exe" "$WINDIR\system32\SmartDefragBootTime.exe"
	;Delete "$WINDIR\system32\IObitSmartDefragExtension.dll"
	;Rename "$WINDIR\system32\IObitSmartDefragExtension-BackUpBySmartDefragPortable.dll" "$WINDIR\system32\IObitSmartDefragExtension.dll"
	System::Call "wininet::DeleteUrlCacheEntryW(t'http://update.iobit.com/infofiles/smartdefrag/isd2update.upt')i .r2"
!macroend