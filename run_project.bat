@echo off
title A.T.E Smart Repair System - Setup and Runner
color 0E

echo ======================================================================
echo           A.T.E Smart Repair System - Setup and Runner
echo ======================================================================
echo.

REM 1. Check if Node.js is installed
echo [1/4] Checking Node.js installation...
where node >nul 2>&1
if errorlevel 1 (
    color 0C
    echo ------------------------------------------------------------------
    echo [ERROR] Node.js is not installed on this system!
    echo Please download and install Node.js (LTS version) first.
    echo ------------------------------------------------------------------
    echo.
    echo Press any key to open the Node.js download page in your browser...
    pause >nul
    start https://nodejs.org/
    exit
)

echo Node.js is installed!
echo Version:
node -v
echo.

REM 2. Install project dependencies
echo [2/4] Installing project libraries (npm install)...
echo This might take a minute depending on your internet connection.
echo Please wait...
echo.
call npm install
if errorlevel 1 (
    color 0C
    echo [ERROR] Failed to install project libraries!
    echo Please check your internet connection and try running this file again.
    pause
    exit
)

echo.
echo [SUCCESS] Libraries installed successfully!
echo.

REM 3. Build the React frontend
echo [3/4] Compiling frontend assets (npm run build)...
call npm run build
if errorlevel 1 (
    color 0C
    echo [ERROR] Failed to build the React frontend!
    pause
    exit
)

echo.
echo [SUCCESS] Frontend compilation completed!
echo.

REM 4. Start the Application Server
echo [4/4] Starting the A.T.E Smart Repair Server...
color 0A
echo ======================================================================
echo  Server is starting! 
echo  Once started, please open your browser and go to:
echo.
echo  --> http://localhost:8080
echo ======================================================================
echo.
call npm start
pause