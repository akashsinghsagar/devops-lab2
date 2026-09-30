import os
import socket
from datetime import datetime, timezone
from flask import Flask, jsonify

app = Flask(__name__)
visits = 0

@app.route("/")
def index():
    global visits
    visits += 1
    return jsonify({
        "data_dir": "/data",
        "hostname": socket.gethostname(),
        "message": "Hello from the Lab 2 containerized Python app!",
        "time_utc": datetime.now(timezone.utc).isoformat(),
        "visits_recorded_in_this_container": visits
    })

@app.route("/health")
def health():
    return jsonify({"status": "ok"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)