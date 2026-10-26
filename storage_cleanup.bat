@echo off
chcp 65001 > nul
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "storage_cleanup.ps1"
pause
