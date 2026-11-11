@echo off
title GatherTrail - Enviar pontos confirmados
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Contribute.ps1"
echo.
pause
