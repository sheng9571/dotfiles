@echo off
setlocal EnableExtensions
for %%I in ("%~dp0..") do set "SRC=%%~fI"
if defined AI_WORKFLOW_HOME (set "TARGET=%AI_WORKFLOW_HOME%") else (set "TARGET=%USERPROFILE%")
if not defined TARGET (
  echo USERPROFILE or AI_WORKFLOW_HOME is required. 1>&2
  exit /b 1
)
set "MANAGED=%TARGET%\.agent-workflow"
set "MARKER=%MANAGED%\.installed-by-engineering-loop"

if not exist "%MARKER%" (
  if exist "%MANAGED%" goto collision
  if exist "%TARGET%\.codex\AGENTS.md" for %%F in ("%TARGET%\.codex\AGENTS.md") do if not "%%~zF"=="0" goto collision
  if exist "%TARGET%\.claude\CLAUDE.md" for %%F in ("%TARGET%\.claude\CLAUDE.md") do if not "%%~zF"=="0" goto collision
  if exist "%TARGET%\.agents\skills\engineering-loop" goto collision
  if exist "%TARGET%\.claude\skills\engineering-loop" goto collision
  if exist "%TARGET%\.agents\skills\session-handover" goto collision
  if exist "%TARGET%\.claude\skills\session-handover" goto collision
  if exist "%TARGET%\.codex\agents\planner.toml" goto collision
  if exist "%TARGET%\.codex\agents\coder.toml" goto collision
  if exist "%TARGET%\.codex\agents\reviewer.toml" goto collision
  if exist "%TARGET%\.claude\agents\planner.md" goto collision
  if exist "%TARGET%\.claude\agents\coder.md" goto collision
  if exist "%TARGET%\.claude\agents\reviewer.md" goto collision
)

for %%D in ("%MANAGED%\roles" "%MANAGED%\engineering-loop" "%TARGET%\.codex\agents" "%TARGET%\.claude\agents" "%TARGET%\.agents\skills\engineering-loop" "%TARGET%\.claude\skills\engineering-loop" "%TARGET%\.agents\skills\session-handover" "%TARGET%\.claude\skills\session-handover") do (
  if not exist "%%~D" mkdir "%%~D" || exit /b 1
)
copy /Y "%SRC%\AGENTS.md" "%MANAGED%\AGENTS.md" >nul || exit /b 1
copy /Y "%SRC%\roles\*.md" "%MANAGED%\roles\" >nul || exit /b 1
copy /Y "%SRC%\engineering-loop\*.md" "%MANAGED%\engineering-loop\" >nul || exit /b 1
copy /Y "%SRC%\AGENTS.md" "%TARGET%\.codex\AGENTS.md" >nul || exit /b 1
copy /Y "%SRC%\AGENTS.md" "%TARGET%\.claude\CLAUDE.md" >nul || exit /b 1
copy /Y "%SRC%\adapters\codex\*.toml" "%TARGET%\.codex\agents\" >nul || exit /b 1
copy /Y "%SRC%\adapters\claude\*.md" "%TARGET%\.claude\agents\" >nul || exit /b 1
copy /Y "%SRC%\engineering-loop\*.md" "%TARGET%\.agents\skills\engineering-loop\" >nul || exit /b 1
copy /Y "%SRC%\engineering-loop\*.md" "%TARGET%\.claude\skills\engineering-loop\" >nul || exit /b 1
copy /Y "%SRC%\session-handover\SKILL.md" "%TARGET%\.agents\skills\session-handover\SKILL.md" >nul || exit /b 1
copy /Y "%SRC%\session-handover\SKILL.md" "%TARGET%\.claude\skills\session-handover\SKILL.md" >nul || exit /b 1
> "%MARKER%" echo Managed by agent-workflow dotfiles. Reinstall updates these files.
echo Installed engineering-loop and session-handover for Codex and Claude Code in "%TARGET%"
exit /b 0

:collision
echo Existing configuration found. No files changed. Back it up or merge it before installation. 1>&2
exit /b 1

