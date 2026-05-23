@echo off
setlocal enabledelayedexpansion

set "PROJECT_DIR=%~dp0.."
set "THIRD_DIR=%~dp0"
set "SOURCE_DIR=%~dp0source"

if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (set "ARCH=win64") else (set "ARCH=win32")

call :ensure_vcpkg
if %ERRORLEVEL% neq 0 exit /b 1

if "%1"=="" goto :list

set /a TOTAL=0
for %%a in (%*) do set /a TOTAL+=1
set /a CURRENT=0

for %%a in (%*) do (
    set /a CURRENT+=1
    set "NAME=%%a"

    if /I "!NAME!"=="all" (
        call :run_one qt5
        if !ERRORLEVEL! neq 0 exit /b 1
        call :run_one yaml-cpp
        if !ERRORLEVEL! neq 0 exit /b 1
    ) else (
        call :run_one "!NAME!"
        if !ERRORLEVEL! neq 0 exit /b 1
    )
)
echo All done.
goto :eof

rem ============================================================
rem Find or install vcpkg
rem ============================================================
:ensure_vcpkg
    if defined VCPKG_ROOT (
        if exist "%VCPKG_ROOT%\vcpkg.exe" goto :found
    )

    for %%d in (
        "D:\code\vcpkg"
        "D:\vcpkg"
        "C:\vcpkg"
        "C:\dev\vcpkg"
        "%USERPROFILE%\vcpkg"
    ) do (
        if exist "%%~d\vcpkg.exe" (
            set "VCPKG_ROOT=%%~d"
            goto :found
        )
    )

    where vcpkg >nul 2>&1
    if %ERRORLEVEL% equ 0 (
        for /f "delims=" %%i in ('where vcpkg') do set "VCPKG_ROOT=%%~dpi"
        if "!VCPKG_ROOT:~-1!"=="\" set "VCPKG_ROOT=!VCPKG_ROOT:~0,-1!"
        goto :found
    )

    echo [env] vcpkg not found. Install it first:
    echo   git clone https://github.com/Microsoft/vcpkg.git C:\vcpkg
    echo   cd C:\vcpkg ^&^& bootstrap-vcpkg.bat
    echo   set VCPKG_ROOT=C:\vcpkg
    exit /b 1

:found
    set "VCPKG_EXE=%VCPKG_ROOT%\vcpkg.exe"
    echo [env] vcpkg: %VCPKG_ROOT%

    rem Save VCPKG_ROOT before vcvars overwrites it
    set "SAVED_VCPKG_ROOT=%VCPKG_ROOT%"

    rem Activate VS environment so vcpkg can find the compiler
    set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
    if exist "!VSWHERE!" (
        for /f "usebackq tokens=*" %%i in (`"!VSWHERE!" -latest -property installationPath 2^>nul`) do set "VS_DIR=%%i"
        if defined VS_DIR (
            set "VCVARS=!VS_DIR!\VC\Auxiliary\Build\vcvars64.bat"
            if exist "!VCVARS!" (
                echo [env] Activating VS: !VS_DIR!
                call "!VCVARS!" >nul 2>&1
            )
        )
    )

    rem Restore VCPKG_ROOT (vcvars64 may have overwritten it)
    set "VCPKG_ROOT=%SAVED_VCPKG_ROOT%"
    exit /b 0

:run_one
    set "SCRIPT=%SOURCE_DIR%\%~1.bat"
    if not exist "!SCRIPT!" (
        echo Unknown library: %~1
        echo Available: qt5, yaml-cpp
        exit /b 1
    )
    echo [!CURRENT!/%TOTAL%] %~1
    call "!SCRIPT!"
    if !ERRORLEVEL! neq 0 exit /b 1
    echo.
    goto :eof

:list
    echo Available libraries:
    for %%f in ("%SOURCE_DIR%\*.bat") do echo   %%~nf
    echo.
    echo Usage: setup.bat [library ...]  e.g. setup.bat qt5 yaml-cpp
    echo         setup.bat all
    goto :eof
