#!/bin/bash
# Move to the directory where this script is located to ensure paths resolve correctly
cd "$(dirname "$0")"

# Set window title on macOS terminal
echo -n -e "\033]0;A.T.E Smart Repair System - Setup & Runner\007"

clear
echo "======================================================================"
echo "      A.T.E Smart Repair System - Setup & Runner (macOS)"
echo "======================================================================"
echo ""

# 1. Check if Node.js is installed
echo "[1/4] Checking Node.js installation..."
if ! command -v node &> /dev/null
then
    echo "------------------------------------------------------------------"
    echo "[ERROR] Node.js is not installed on this system!"
    echo "Please download and install Node.js (LTS version) first."
    echo "------------------------------------------------------------------"
    echo ""
    echo "Press Enter to open the Node.js download page in your browser..."
    read
    open https://nodejs.org/
    exit 1
fi

echo "Node.js is installed!"
echo "Version: $(node -v)"
echo ""

# 2. Install project dependencies
echo "[2/4] Installing project libraries (npm install)..."
echo "This might take a minute depending on your internet connection."
echo "Please wait..."
echo ""
npm install
if [ $? -ne 0 ]; then
    echo ""
    echo "[ERROR] Failed to install project libraries!"
    echo "Please check your internet connection and try again."
    read -p "Press Enter to exit..."
    exit 1
fi

echo ""
echo "[SUCCESS] Libraries installed successfully!"
echo ""

# 3. Build the React frontend
echo "[3/4] Compiling frontend assets (npm run build)..."
npm run build
if [ $? -ne 0 ]; then
    echo ""
    echo "[ERROR] Failed to build the React frontend!"
    read -p "Press Enter to exit..."
    exit 1
fi

echo ""
echo "[SUCCESS] Frontend compilation completed!"
echo ""

# 4. Start the Application Server
echo "[4/4] Starting the A.T.E Smart Repair Server..."
echo "======================================================================"
echo " Server is starting!" 
echo " Once started, please open your browser and go to:"
echo ""
echo " --> http://localhost:8080"
echo "======================================================================"
echo ""

npm start
