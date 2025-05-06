from flask import Flask
import socket
from datetime import datetime

app = Flask(__name__)

@app.route("/")
def hello_world():
    server_ip = socket.gethostbyname(socket.gethostname())
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return f"Hello, World!<br>Server IP: {server_ip}<br>Timestamp: {timestamp}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
