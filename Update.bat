@echo off
setlocal
title ForagerOre - Atualizador
rem Baixa a versao mais recente do GitHub e atualiza esta pasta. Nao precisa de git.
rem Seus dados (veios memorizados) ficam em WTF\SavedVariables e nao sao tocados.

set "REPO=cleytoncl3/ForagerOre"
set "BRANCH=main"
set "DEST=%~dp0"
set "TMP_DIR=%TEMP%\ForagerOre_update"

echo.
echo  ForagerOre - atualizando a partir de github.com/%REPO%
echo.
echo  Feche o WoW antes de atualizar (ou de /reload depois).
echo.

if exist "%TMP_DIR%" rmdir /s /q "%TMP_DIR%"
mkdir "%TMP_DIR%"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;" ^
  "Invoke-WebRequest -UseBasicParsing -Uri 'https://github.com/%REPO%/archive/refs/heads/%BRANCH%.zip' -OutFile '%TMP_DIR%\repo.zip';" ^
  "Expand-Archive -Path '%TMP_DIR%\repo.zip' -DestinationPath '%TMP_DIR%\x' -Force"
if errorlevel 1 goto :fail

for /d %%D in ("%TMP_DIR%\x\*") do set "SRC=%%D"
if not defined SRC goto :fail

rem /XF Update.bat: nao sobrescreve o proprio script enquanto ele roda
robocopy "%SRC%" "%DEST%." /E /XF Update.bat /XD .git /NFL /NDL /NJH /NJS /NP >nul
if errorlevel 8 goto :fail

rmdir /s /q "%TMP_DIR%"
echo  Pronto! ForagerOre atualizado. Entre no jogo ou de /reload.
echo.
pause
exit /b 0

:fail
echo.
echo  ERRO: nao foi possivel atualizar. Verifique sua internet e tente de novo.
echo.
pause
exit /b 1
