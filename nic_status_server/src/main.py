from flask import Flask

import os
import json
import time

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, World!"


@app.route("/<nic>/stat")
def status(nic):
    rx_stream = os.popen("cat /sys/class/net/{}/statistics/rx_bytes".format(nic))
    rx_bytes = rx_stream.read().strip()
    tx_stream = os.popen("cat /sys/class/net/{}/statistics/tx_bytes".format(nic))
    tx_bytes = tx_stream.read().strip()
    result = {
        "time": time.time(),
        "rx_bytes": int(rx_bytes),
        "tx_bytes": int(tx_bytes)
    }
    return json.dumps(result)

