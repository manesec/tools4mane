# https://github.com/manesec/tools4me
# write by Mane.

from http.server import BaseHTTPRequestHandler, HTTPServer
import argparse

print("""
 ▄▀▀▄ ▄▀▄  ▄▀▀█▄   ▄▀▀▄ ▀▄  ▄▀▀█▄▄▄▄  ▄▀▀▀▀▄  ▄▀▀█▄▄▄▄  ▄▀▄▄▄▄  
█  █ ▀  █ ▐ ▄▀ ▀▄ █  █ █ █ ▐  ▄▀   ▐ █ █   ▐ ▐  ▄▀   ▐ █ █    ▌ 
▐  █    █   █▄▄▄█ ▐  █  ▀█   █▄▄▄▄▄     ▀▄     █▄▄▄▄▄  ▐ █      
  █    █   ▄▀   █   █   █    █    ▌  ▀▄   █    █    ▌    █      
▄▀   ▄▀   █   ▄▀  ▄▀   █    ▄▀▄▄▄▄    █▀▀▀    ▄▀▄▄▄▄    ▄▀▄▄▄▄▀ 
█    █    ▐   ▐   █    ▐    █    ▐    ▐       █    ▐   █     ▐  
▐    ▐            ▐         ▐                 ▐        ▐        
                Fake Redirect - Tools4me by Mane.
                        Version: 20220201
                https://github.com/manesec/tools4me
---------------------------------------------------------------""")

redirect_fake_url = "https://github.com/manesec/tools4me/"
class HttpHandler(BaseHTTPRequestHandler):
    global redirect_fake_url
    def _set_response(self):
        self.send_response(301)
        self.send_header('Location', redirect_fake_url)
        self.end_headers()

    def do_GET(self):
        self._set_response()

    def do_POST(self):
        self._set_response()

def HttpServerRun(server_class=HTTPServer, handler_class=HttpHandler,ip='',port=80,redirect=''):
    global redirect_fake_url
    redirect_fake_url = redirect 
    server_address = (ip, port)
    httpd = server_class(server_address, handler_class)
    print("[*] Server start on %s:%s ..." %(ip,port))
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Always return 301')
    parser.add_argument('--port', '-p', type=int, default=80, help='port to listen on')
    parser.add_argument('--ip', '-i', default="", help='host interface to listen on')
    parser.add_argument('--url','-u', type=str, required=True)
    input_parser = parser.parse_args()
    HttpServerRun(ip=input_parser.ip,port=input_parser.port,redirect=input_parser.url)