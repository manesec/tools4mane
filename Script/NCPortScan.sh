#!/bin/bash
# https://github.com/manesec/tools4mane
# write by Mane.

echo " ▄▀▀▄ ▄▀▄  ▄▀▀█▄   ▄▀▀▄ ▀▄  ▄▀▀█▄▄▄▄  ▄▀▀▀▀▄  ▄▀▀█▄▄▄▄  ▄▀▄▄▄▄  
█  █ ▀  █ ▐ ▄▀ ▀▄ █  █ █ █ ▐  ▄▀   ▐ █ █   ▐ ▐  ▄▀   ▐ █ █    ▌ 
▐  █    █   █▄▄▄█ ▐  █  ▀█   █▄▄▄▄▄     ▀▄     █▄▄▄▄▄  ▐ █      
  █    █   ▄▀   █   █   █    █    ▌  ▀▄   █    █    ▌    █      
▄▀   ▄▀   █   ▄▀  ▄▀   █    ▄▀▄▄▄▄    █▀▀▀    ▄▀▄▄▄▄    ▄▀▄▄▄▄▀ 
█    █    ▐   ▐   █    ▐    █    ▐    ▐       █    ▐   █     ▐  
▐    ▐            ▐         ▐                 ▐        ▐        
                  Using nc to scan all the port.
                        Version: 20220224
                https://github.com/manesec/tools4mane
--------------------------------------------------------------"

command -v nc >/dev/null

if [ $? -ne 0 ]; then
    echo "[ERR] No found nc command in your system."
    exit 1
fi

if [ "$1" == "" ]
then
    echo "Usage: ./NCPortScan.sh [IP]"
    exit 0
else
    echo "[+] Start to scanning $1 ..."
    nc -nvz $1 1-65535 > /tmp/$1.mane 2>&1
fi
tac /tmp/$1.mane
rm -rf /tmp/$1.mane
exit 0