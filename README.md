# Chisel and Flask Server Setup Script

This repository contains a bash script (`setup.sh`) that automates the process of downloading Chisel for Linux and Windows, setting up a Chisel server, and setting up a Python server to serve the Chisel client files.

## What is this script?

The script does the following:

1. Downloads the Chisel client for Linux and Windows.
2. Sets up a Chisel server running on port 1337.
3. Sets up a Python  server running on port 5000. This server serves the Chisel client files and shuts down after a client has downloaded a file.
4. Once the Python server shuts down, the Chisel server is started.

## Why is it useful?

This script can be useful in situations where you want to distribute the Chisel client to other users via a web server, and then start a Chisel server that they can connect to. It automates the process of downloading the clients, setting up the servers, and managing their lifecycles.

## How to run the script


1. Make the script executable:

    ```bash
    chmod +x setup.sh
    ```

2. Run the script with sudo:

    ```bash
    sudo ./setup.sh
    ```

## Example

After running the script, you can download the Chisel client from the Flask server with curl:

```bash
curl http://your-server-ip:5000/files/chisel_linux > chisel_linux
curl http://your-server-ip:5000/files/chisel_windows > chisel_windows
