@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Deutschpatch-installieren.ps1" "%~dp0."
if errorlevel 1 (
    echo.
    echo Installation fehlgeschlagen.
) else (
    echo.
    echo Das Fenster kann jetzt geschlossen werden.
)
pause
