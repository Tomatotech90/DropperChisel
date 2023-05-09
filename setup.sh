#!/bin/bash

# Check for root privileges
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Check for Python
command -v python3 >/dev/null 2>&1 || { echo >&2 "Python 3 is required but it's not installed. Aborting."; exit 1; }

echo "Downloading Chisel for Linux and Windows..."
wget https://github.com/jpillora/chisel/releases/download/v1.7.6/chisel_1.7.6_linux_amd64.gz -O chisel_linux.gz
wget https://github.com/jpillora/chisel/releases/download/v1.7.6/chisel_1.7.6_windows_amd64.gz -O chisel_windows.gz

echo "Unzipping the downloaded files..."
gunzip chisel_linux.gz
gunzip chisel_windows.gz

# Rename the decompressed files to remove .gz extension
mv chisel_1.7.6_linux_amd64 chisel_linux
mv chisel_1.7.6_windows_amd64 chisel_windows

echo "Making the Linux version executable..."
chmod +x chisel_linux

echo "Setting up a Python HTTP server..."
mkdir static
mv chisel_linux static/
mv chisel_windows static/

echo "Starting the Python HTTP server..."
cd static
nohup python3 -m http.server 5000 > ../http.log 2>&1 &
echo $! > ../http.pid
cd ..
echo "Python HTTP server is up and running at http://localhost:5000"

# Wait for server to start
sleep 10

# Check if server is running
if ! curl --output /dev/null --silent --head --fail http://localhost:5000
then
    echo "Python HTTP server didn't start correctly. Please check http.log for details."
    exit 1
fi

# Wait for user to download the file
echo "Waiting for user to download the file..."
read -p "Press enter to continue once the file has been downloaded..."

# Kill the HTTP server
echo "Shutting down Python HTTP server..."
kill $(cat http.pid) && rm http.pid

echo "Starting the Chisel server on port 1337..."
nohup ./static/chisel_linux server --port 1337 > chisel.log 2>&1 &
echo "Chisel server is up and running at http://localhost:1337"
