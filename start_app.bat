@echo off
setlocal
cd /d "%~dp0mobile"
if not exist node_modules (
  echo The app is not set up yet. Run setup.bat first.
  pause
  exit /b 1
)
echo Starting the SpendWise mobile app...
echo Scan the QR code with Expo Go, or press "a" to open the Android emulator.
echo.
call npx expo start
pause
