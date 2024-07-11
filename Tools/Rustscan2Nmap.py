#!/usr/bin/python3
# https://github.com/manesec/tools4mane
# write by @manesec.

import os,sys

print("""
 _¯¯_ _¯_  _¯¯¦_   _¯¯_ ¯_  _¯¯¦____  _¯¯¯¯_  _¯¯¦____  _¯____  
¦  ¦ ¯  ¦ ¦ _¯ ¯_ ¦  ¦ ¦ ¦ ¦  _¯   ¦ ¦ ¦   ¦ ¦  _¯   ¦ ¦ ¦    ¦ 
¦  ¦    ¦   ¦___¦ ¦  ¦  ¯¦   ¦_____     ¯_     ¦_____  ¦ ¦      
  ¦    ¦   _¯   ¦   ¦   ¦    ¦    ¦  ¯_   ¦    ¦    ¦    ¦      
_¯   _¯   ¦   _¯  _¯   ¦    _¯____    ¦¯¯¯    _¯____    _¯____¯ 
¦    ¦    ¦   ¦   ¦    ¦    ¦    ¦    ¦       ¦    ¦   ¦     ¦  
¦    ¦            ¦         ¦                 ¦        ¦        
              Rustscan 2 Nmap - Tools4me by @manesec.
                           Version: 0.1
                https://github.com/manesec/tools4mane
---------------------------------------------------------------""")

if (len(sys.argv) < 2):
    print("Usage: python3 rustscan2nmap.py result.txt")
    sys.exit(1)

"""
result file format:
    192.168.1.222 -> [135,139,445,2994,5985,47001,49664,49665,49666,49667,49668,49669,49670]
    192.168.1.221 -> [80,135,139,443,445,3387,5504,5985,10000,47001,49664,49665,49666,49667,49668,49669,49670,49672,49673,49674,49675,49680]
    192.168.1.225 -> [21,80,8090]
"""


isRoot = os.geteuid() == 0

result = sys.argv[1]

with open(result, 'r') as f:
    for line in f:
        line = line.strip()
        if (line == ""): continue

        if ("->" in line):
            ip = line.split(" -> ")[0]
            ports = line.split(" -> ")[1].strip("[]").split(",")

            print("\n\n---------------------------------------------------------------")
            print("IP: " + ip)
            command = "nmap "+ ("-sS" if isRoot else "") + " -Pn -sC -sV -p" + ",".join(ports) + " " + ip
            print("$ "+ command)
            print("---------------------------------------------------------------\n")
            os.system(command)

