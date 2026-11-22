@echo off
setlocal
cd /d "%~dp0backend"
if not exist ".venv\Scripts\python.exe" (
  echo Run setup.bat first.
  pause
  exit /b 1
)
echo Testing the running backend. Start start_backend.bat first if you have not.
echo.
".venv\Scripts\python.exe" smoke_test.py
pause
