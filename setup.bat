@echo off
setlocal
cd /d "%~dp0"
echo ==== SpendWise one-time setup ====
echo.

where node >nul 2>nul
if errorlevel 1 (
  echo [X] Node.js was not found. Install the LTS version from https://nodejs.org and run this again.
  goto :fail
)

set "PY="
where py >nul 2>nul
if not errorlevel 1 set "PY=py -3"
if not defined PY (
  where python >nul 2>nul
  if not errorlevel 1 set "PY=python"
)
if not defined PY (
  echo [X] Python was not found. Install Python 3.10 or newer from https://www.python.org and tick Add python.exe to PATH.
  goto :fail
)

echo [1/2] Setting up the backend...
pushd backend
if not exist ".venv\Scripts\python.exe" (
  %PY% -m venv .venv
  if errorlevel 1 goto :fail
)
".venv\Scripts\python.exe" -m pip install --upgrade pip
".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 goto :fail
popd

echo.
echo [2/2] Setting up the mobile app (this takes a few minutes)...
pushd mobile
call npm install
if errorlevel 1 goto :fail
call npx --yes expo install --fix
if errorlevel 1 goto :fail
popd

echo.
echo ==== Setup complete ====
echo Next: double-click start_backend.bat, then start_app.bat
pause
exit /b 0

:fail
echo.
echo [X] Setup did not finish. Read the message above, fix it, and run setup.bat again.
pause
exit /b 1
