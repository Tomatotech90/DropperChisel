#!/bin/bash

# Make sure to run this script with sudo

# Download Chisel for Linux and Windows
wget https://github.com/jpillora/chisel/releases/download/v1.7.6/chisel_1.7.6_linux_amd64.gz -O chisel_linux.gz
wget https://github.com/jpillora/chisel/releases/download/v1.7.6/chisel_1.7.6_windows_amd64.gz -O chisel_windows.gz

# Unzip the downloaded files
gunzip chisel_linux.gz
gunzip chisel_windows.gz

# Make the Linux version executable
chmod +x chisel_linux

# Set up a Python Flask server
# Assuming Python and Flask are already installed
mkdir static
mv chisel_linux static/
mv chisel_windows static/

echo "
from flask import Flask, send_from_directory, session, request, jsonify
from flask_session import Session
from werkzeug.exceptions import BadRequest
from werkzeug.serving import run_simple
import os

app = Flask(__name__, static_folder='static')

app.secret_key = 'supersecretkey'
app.config['SESSION_TYPE'] = 'filesystem'
Session(app)

@app.route('/files/<path:path>')
def send_file(path):
    session['downloaded'] = True
    return send_from_directory('static', path)

@app.route('/shutdown', methods=['POST'])
def shutdown():
    if session.get('downloaded'):
        session.pop('downloaded')
        shutdown_server()
        return 'Server shutting down...'
    else:
        raise BadRequest()

def shutdown_server():
    os.kill(os.getpid(), signal.SIGINT)

if __name__ == '__main__':
    run_simple('0.0.0.0', 5000, app)
" > server.py

# Start the Python Flask server
python3 server.py > flask.log 2>&1 &

# Wait for the user to download the file and shut down the server
while true; do
    if curl -X POST http://localhost:5000/shutdown 2>/dev/null; then
        break
    fi
    sleep 1
done

# Start the Chisel server on port 1337
./chisel_linux server --port 1337 > chisel.log 2>&1 &
