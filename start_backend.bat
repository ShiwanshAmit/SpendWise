@echo off
setlocal
cd /d "%~dp0backend"
if not exist ".venv\Scripts\python.exe" (
  echo The backend is not set up yet. Run setup.bat first.
  pause
  exit /b 1
)
echo.
echo SpendWise backend is starting on port 8000
echo   On this PC:  http://localhost:8000/docs
echo   Your PC's IPv4 address^(es^) - the Wi-Fi one is what your phone uses:
ipconfig | findstr /c:"IPv4"
echo.
echo Keep this window open while you use the app. Press Ctrl+C to stop.
echo.
".venv\Scripts\python.exe" -m uvicorn main:app --host 0.0.0.0 --port 8000
pause
