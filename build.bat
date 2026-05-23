@echo off
setlocal enabledelayedexpansion

set "PROJECT_DIR=%~dp0"
set "OUTPUT_DIR=%PROJECT_DIR%output"

if "%1"=="" goto :usage

if /I "%1"=="build" (
    if not exist "%PROJECT_DIR%build" mkdir "%PROJECT_DIR%build"
    cd /d "%PROJECT_DIR%build"
    cmake ..
    if %ERRORLEVEL% neq 0 exit /b 1
    cmake --build . --config Release --parallel
    if %ERRORLEVEL% neq 0 exit /b 1
    goto :eof
)

if /I "%1"=="clean" (
    if exist "%PROJECT_DIR%build" rmdir /s /q "%PROJECT_DIR%build"
    if exist "%OUTPUT_DIR%" rmdir /s /q "%OUTPUT_DIR%"
    goto :eof
)

if /I "%1"=="build_and_run" (
    if not exist "%PROJECT_DIR%build" mkdir "%PROJECT_DIR%build"
    cd /d "%PROJECT_DIR%build"
    cmake ..
    if %ERRORLEVEL% neq 0 exit /b 1
    cmake --build . --config Release --parallel
    if %ERRORLEVEL% neq 0 exit /b 1
    start "" "%OUTPUT_DIR%\mainboard.exe"
    goto :eof
)

if /I "%1"=="clean_3rd" (
    if exist "%PROJECT_DIR%3rd" (
        pushd "%PROJECT_DIR%3rd"
        for /d %%i in (*) do (
            if /I not "%%i"=="source" (
                rmdir /s /q "%%i"
            )
        )
        popd
    )
    goto :eof
)

:usage
echo Usage: build.bat {build^|clean^|build_and_run^|clean_3rd}
exit /b 1
