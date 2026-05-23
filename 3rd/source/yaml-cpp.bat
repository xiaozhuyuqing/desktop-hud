@echo off
rem yaml-cpp third-party library -- via vcpkg

set "DEST=%THIRD_DIR%%ARCH%\yaml-cpp"
if exist "%DEST%\include\yaml-cpp" (
    echo   [yaml-cpp] already installed at %DEST%
    exit /b 0
)

echo   [yaml-cpp] installing via vcpkg...

"!VCPKG_EXE!" install yaml-cpp --triplet x64-windows
if !ERRORLEVEL! neq 0 (
    echo   [yaml-cpp] ERROR: vcpkg install failed
    exit /b 1
)

echo   [yaml-cpp] copying from vcpkg...

echo   [yaml-cpp] VCPKG_ROOT=%VCPKG_ROOT%

rem vcpkg can put artifacts in two places; try packages first (newer vcpkg), then installed
set "VCPKG_SRC="
set "CANDIDATE=%VCPKG_ROOT%\packages\yaml-cpp_x64-windows"
if exist "!CANDIDATE!\include\yaml-cpp\yaml.h" set "VCPKG_SRC=!CANDIDATE!"
if not defined VCPKG_SRC (
    set "CANDIDATE=%VCPKG_ROOT%\installed\x64-windows"
    if exist "!CANDIDATE!\include\yaml-cpp\yaml.h" set "VCPKG_SRC=!CANDIDATE!"
)
if not defined VCPKG_SRC (
    echo   [yaml-cpp] ERROR: cannot find vcpkg install tree
    exit /b 1
)

echo   [yaml-cpp] source: !VCPKG_SRC!
mkdir "%DEST%\include" 2>nul
mkdir "%DEST%\lib"     2>nul
xcopy /s /e /q /y "!VCPKG_SRC!\include\yaml-cpp\*" "%DEST%\include\yaml-cpp\" >nul
if exist "!VCPKG_SRC!\bin\yaml-cpp.dll" (
    copy /y "!VCPKG_SRC!\bin\yaml-cpp.dll" "%DEST%\lib\" >nul
)
if exist "!VCPKG_SRC!\lib\yaml-cpp.lib" (
    copy /y "!VCPKG_SRC!\lib\yaml-cpp.lib" "%DEST%\lib\" >nul
)

echo   [yaml-cpp] done
exit /b 0
