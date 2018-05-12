@ECHO OFF
set "FF=%~dp0"
set FF_XPORT=11
set DISPLAY=127.0.0.1:%FF_XPORT%.0
set "XLOCALEDIR=%FF%bin\VcXsrv\locale"
set "XLOCALELIBDIR=%XLOCALEDIR%"
set "HOME=%FF%"
set "PYTHONHOME=%FF%"
set "PYTHONPATH=%FF%lib\python2.7"
set AUTOTRACE=potrace
::set FF_PORTABLE=TRUE

::Set this to your language code to change the FontForge UI language
::See share/locale/ for a list of supported language codes
::set LANGUAGE=en

::Only add to path once
if not defined FF_PATH_ADDED (
set "PATH=%FF%;%FF%\bin;%PATH:"=%"
set FF_PATH_ADDED=TRUE
)

if exist "%FF%\bin\VcXsrv_util.exe" (
    "%FF%\bin\VcXsrv_util.exe" -exists || (
        start /B "" "%FF%\bin\VcXsrv\vcxsrv.exe" :%FF_XPORT% -multiwindow -clipboard -silent-dup-error
    )

    "%FF%\bin\VcXsrv_util.exe" -wait
)

"%FF%\bin\fontforge.exe" -nosplash %*

if exist "%FF%\bin\VcXsrv_util.exe" (
    "%FF%\bin\VcXsrv_util.exe" -close
)
:: bye

