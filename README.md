# DropperChiselChisel and Flask Server Setup Script
This repository contains a bash script (setup.sh) that automates the process of downloading Chisel for Linux and Windows, setting up a Chisel server, and setting up a Flask server to serve the Chisel client files.

What is this script?
The script does the following:

Downloads the Chisel client for Linux and Windows.
Sets up a Chisel server running on port 1337.
Sets up a Python Flask server running on port 5000. This server serves the Chisel client files and shuts down after a client has downloaded a file.
Once the Flask server shuts down, the Chisel server is started.
Why is it useful?
This script can be useful in situations where you want to distribute the Chisel client to other users via a web server, and then start a Chisel server that they can connect to. It automates the process of downloading the clients, setting up the servers, and managing their lifecycles.

How to run the script
First, ensure that you have Python, Flask, and the flask-session package installed on your machine. You can install Flask and flask-session with pip:

bash
Copy code
pip install flask flask-session
Make the script executable:

bash
Copy code
chmod +x setup.sh
Run the script with sudo:

bash
Copy code
sudo ./setup.sh
Example
After running the script, you can download the Chisel client from the Flask server with curl:

bash
Copy code
curl http://your-server-ip:5000/files/chisel_linux > chisel_linux
curl http://your-server-ip:5000/files/chisel_windows > chisel_windows
Once a client has downloaded a file, the Flask server will shut down and the Chisel server will start on port 1337.


