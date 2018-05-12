@ECHO off

echo Building Xenon File Manager Portable
echo.
echo.
echo If you are using an OS before windows xp you will need to pass the path to the autoit dir as a parameter.
echo.
echo Checking for AutoIt installation.

if not .%1==. (
if exist "%1\Aut2Exe\Aut2exeA.exe" set autoitdir=%1 else goto noparam
) else goto noparam

goto build

:noparam

for /F "tokens=2* delims=	 " %%A IN ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt" /v InstallDir') DO SET autoitdir=%%B

if not exist "%autoitdir%\Aut2Exe\Aut2ExeA.exe" goto nopath

:build

echo.
echo.
echo AutoIt installation found.
echo AutoIt Directory: %autoitdir%
echo.
echo Building Unicode Launcher
"%autoitdir%\Aut2Exe\Aut2exeA.exe" /in XenonPortable.au3 /out ..\..\App\XenonPortable64.exe /icon xenon.ico /x64 /pack /comp 4
echo Building Unicode Launcher
"%autoitdir%\Aut2Exe\Aut2exeA.exe" /in XenonPortable.au3 /out ..\..\App\XenonPortableW.exe /icon xenon.ico /unicode /pack /comp 4
echo Building ANSI Launcher
"%autoitdir%\Aut2Exe\Aut2exeA.exe" /in XenonPortable.au3 /out ..\..\App\XenonPortableA.a3x /icon xenon.ico /ansi /comp 4
rem echo Building OS Detection Launcher


rem This is commented out because it should be compiled
rem in SciTE4AutoIt3 so the resource hacking works.
rem "%autoitdir%\Aut2Exe\Aut2exeA.exe" /in XenonPortableOS.au3 /out ..\..\XenonPortable.exe /icon xenon.ico /ansi /pack /comp 4


exit /b 0

:nopath

exit /b 1