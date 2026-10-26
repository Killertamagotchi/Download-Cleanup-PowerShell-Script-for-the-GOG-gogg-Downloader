@echo off
chcp 65001 > nul
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File " "download_all_games.ps1"
echo Press any key to exit...
pause > nul
