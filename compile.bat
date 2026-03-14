@echo off
setlocal EnableDelayedExpansion

REM === CONFIGURATION ===
set "MAIN_TEX=main.tex"
set "OUTPUT_DIR=outputs"
set "VERSION_FILE=version.txt"
set "KEEP_BUILDS=5"

REM === GET DATE ===
for /f %%a in ('powershell -command "Get-Date -Format yyyy-MM-dd"') do set "DATE=%%a"

REM === READ CURRENT VERSION ===
if not exist "%VERSION_FILE%" (
    > "%VERSION_FILE%" echo(v1
)

set /p CURRENT_VERSION=<"%VERSION_FILE%"
set "CURRENT_VERSION=%CURRENT_VERSION: =%"
if "%CURRENT_VERSION%"=="" set "CURRENT_VERSION=v1"

set VERSION_NUM=%CURRENT_VERSION:~1%
if "%VERSION_NUM%"=="" set "VERSION_NUM=1"

set /a NEW_VERSION_NUM=VERSION_NUM + 1
set "NEW_VERSION=v!NEW_VERSION_NUM!"

> "%VERSION_FILE%" echo(!NEW_VERSION!

REM === CREATE OUTPUT FOLDER ===
set "BUILD_DIR=%OUTPUT_DIR%\report_%CURRENT_VERSION%_%DATE%"
if not exist "%BUILD_DIR%" (
    mkdir "%BUILD_DIR%"
)

REM === COMPILE (requires pdflatex to be in PATH) ===
pdflatex -output-directory="%BUILD_DIR%" "%MAIN_TEX%"
if errorlevel 1 goto :build_failed

pdflatex -output-directory="%BUILD_DIR%" "%MAIN_TEX%"
if errorlevel 1 goto :build_failed

REM === DONE ===
if exist "%BUILD_DIR%\main.pdf" (
    echo ✅ Build complete: %BUILD_DIR%\main.pdf
    echo Next version will be: %NEW_VERSION%

    set /a INDEX=0
    for /f "delims=" %%D in ('dir /b /ad /o-d "%OUTPUT_DIR%\report_*" 2^>nul') do (
        set /a INDEX+=1
        if !INDEX! GTR %KEEP_BUILDS% rd /s /q "%OUTPUT_DIR%\%%D"
    )
) else (
    echo ❌ Build failed.
    exit /b 1
)

exit /b 0

:build_failed
echo ❌ Build failed during pdflatex execution.
exit /b 1
