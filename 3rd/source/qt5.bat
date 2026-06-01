@echo off
rem Qt5 third-party library -- download pre-built via aqtinstall

set "DEST=%THIRD_DIR%%ARCH%\qt5"
if exist "%DEST%\bin\Qt5Core.dll" (
    echo   [qt5] already installed at %DEST%
    exit /b 0
)

if "%QT5_ARCH%"==""    set "QT5_ARCH=win64_msvc2019_64"
if "%QT5_VERSION%"=="" set "QT5_VERSION=5.15.2"

echo   [qt5] installing Qt %QT5_VERSION% for %QT5_ARCH%...

rem Find a working Python (skip Windows App Exec Alias stub)
set "PYTHON_EXE="
for %%d in (
    "%LOCALAPPDATA%\Programs\Python\Python312\python.exe"
    "%LOCALAPPDATA%\Programs\Python\Python311\python.exe"
    "%LOCALAPPDATA%\Programs\Python\Python313\python.exe"
    "C:\Python312\python.exe"
    "C:\Python311\python.exe"
) do (
    if exist "%%~d" (
        set "PYTHON_EXE=%%~d"
        goto :python_found
    )
)
where python >nul 2>&1
if %ERRORLEVEL% equ 0 (
    rem App Exec Alias stub? verify it actually works
    python -c "exit(0)" >nul 2>&1
    if !ERRORLEVEL! equ 0 set "PYTHON_EXE=python"
)
if defined PYTHON_EXE goto :python_found
echo   [qt5] ERROR: python not found (install from python.org or run: winget install Python.Python.3.12^)
exit /b 1

:python_found
echo   [qt5] using Python: %PYTHON_EXE%

echo   [qt5] installing aqtinstall...
%PYTHON_EXE% -m pip install aqtinstall -q 2>&1
if %ERRORLEVEL% neq 0 (
    echo   [qt5] ERROR: pip install aqtinstall failed
    exit /b 1
)

set "AQT_TMP=%THIRD_DIR%.tmp_qt5"
if exist "%AQT_TMP%" rmdir /s /q "%AQT_TMP%"

echo   [qt5] downloading (this may take a while)...
%PYTHON_EXE% -m aqt install-qt windows desktop %QT5_VERSION% %QT5_ARCH% --outputdir "%AQT_TMP%"
if %ERRORLEVEL% neq 0 (
    echo   [qt5] ERROR: download failed, try again or check network
    if exist "%AQT_TMP%" rmdir /s /q "%AQT_TMP%"
    exit /b 1
)

rem aqt output structure: .tmp_qt5/5.15.2/msvc2019_64/{bin,include,lib,plugins,...}
set "AQT_SRC=%AQT_TMP%\%QT5_VERSION%\%QT5_ARCH%"
if not exist "%AQT_SRC%" (
    for /d %%d in ("%AQT_TMP%\%QT5_VERSION%\*") do set "AQT_SRC=%%d"
)

echo   [qt5] organizing...

rem The cmake configs expect the structure:
rem   3rd/win64/qt5/{bin,include,lib,plugins,mkspecs}
rem   cmake files reference ../../bin/Qt5Core.dll relative to lib/cmake/Qt5Core/

if exist "%DEST%" rmdir /s /q "%DEST%"
xcopy /s /e /q /y "%AQT_SRC%\*" "%DEST%\" >nul

rmdir /s /q "%AQT_TMP%"
echo   [qt5] done
exit /b 0
