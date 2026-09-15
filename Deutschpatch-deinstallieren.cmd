@echo off
setlocal EnableExtensions DisableDelayedExpansion
chcp 65001 >nul
title Trivia Murder Party 3 - Deutschpatch deinstallieren
set "GAME_DIR=%~dp0"

echo.
echo Trivia Murder Party 3 - Deutschpatch-Uninstaller
echo =================================================
echo.

if not exist "%GAME_DIR%TMP3.exe" (
    echo FEHLER: Lege dieses Skript neben TMP3.exe ab und starte es erneut.
    echo.
    pause
    exit /b 1
)

tasklist /FI "IMAGENAME eq TMP3.exe" /NH 2>nul | find /I "TMP3.exe" >nul
if not errorlevel 1 goto :game_running
tasklist /FI "IMAGENAME eq TMP3-Win64-Shipping.exe" /NH 2>nul | find /I "TMP3-Win64-Shipping.exe" >nul
if not errorlevel 1 goto :game_running

echo Der Deutschpatch wird nun entfernt.
echo.
choice /C JN /N /M "Deutschpatch jetzt deinstallieren? [J/N] "
if errorlevel 2 exit /b 0

del /F /Q "%GAME_DIR%config.dat" >nul 2>&1
del /F /Q "%GAME_DIR%Deutschpatch-installieren.ps1" >nul 2>&1
del /F /Q "%GAME_DIR%TMP3\Config\Windows\WindowsGame.ini" >nul 2>&1
del /F /Q "%GAME_DIR%TMP3\Content\Paks\TMP3-German*" >nul 2>&1
rd /S /Q "%GAME_DIR%TMP3\Content\Localization\Game\de" >nul 2>&1

set "CONTENT=%GAME_DIR%TMP3\Content\TMP3\LooseData\Content"
del /F /Q "%CONTENT%\Localization.json" >nul 2>&1
del /F /Q "%CONTENT%\TMP3*.json" >nul 2>&1
del /F /Q "%CONTENT%\VO.json" >nul 2>&1
rd /S /Q "%CONTENT%\VO" >nul 2>&1

if exist "%GAME_DIR%config.dat" goto :cleanup_failed
if exist "%GAME_DIR%TMP3\Config\Windows\WindowsGame.ini" goto :cleanup_failed
if exist "%GAME_DIR%TMP3\Content\Paks\TMP3-German*" goto :cleanup_failed
if exist "%GAME_DIR%TMP3\Content\Localization\Game\de" goto :cleanup_failed
if exist "%CONTENT%\Localization.json" goto :cleanup_failed
if exist "%CONTENT%\TMP3*.json" goto :cleanup_failed
if exist "%CONTENT%\VO.json" goto :cleanup_failed
if exist "%CONTENT%\VO" goto :cleanup_failed

echo.
echo Deutschpatch erfolgreich entfernt. Die Steam-Dateiprüfung wird gestartet.
echo.
start "" "steam://validate/3048060"
(goto) 2>nul & del /F /Q "%~f0"

:cleanup_failed
echo FEHLER: Nicht alle Patchdateien konnten entfernt werden.
echo Starte den Deinstaller erneut, gegebenenfalls als Administrator.
echo.
pause
exit /b 1

:game_running
echo FEHLER: Trivia Murder Party 3 läuft noch. Beende das Spiel und versuche es erneut.
echo.
pause
exit /b 1
