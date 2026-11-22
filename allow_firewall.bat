@echo off
net session >nul 2>&1
if errorlevel 1 (
  echo Right-click this file and choose "Run as administrator".
  pause
  exit /b 1
)
netsh advfirewall firewall add rule name="SpendWise API 8000" dir=in action=allow protocol=TCP localport=8000 profile=private,public
echo.
echo Done. Windows Firewall now allows your phone to reach the backend on port 8000.
pause
