#! /bin/bash
# https://github.com/manesec/tools4mane
# write by @manesec.

echo " ▄▀▀▄ ▄▀▄  ▄▀▀█▄   ▄▀▀▄ ▀▄  ▄▀▀█▄▄▄▄  ▄▀▀▀▀▄  ▄▀▀█▄▄▄▄  ▄▀▄▄▄▄  
█  █ ▀  █ ▐ ▄▀ ▀▄ █  █ █ █ ▐  ▄▀   ▐ █ █   ▐ ▐  ▄▀   ▐ █ █    ▌ 
▐  █    █   █▄▄▄█ ▐  █  ▀█   █▄▄▄▄▄     ▀▄     █▄▄▄▄▄  ▐ █      
  █    █   ▄▀   █   █   █    █    ▌  ▀▄   █    █    ▌    █      
▄▀   ▄▀   █   ▄▀  ▄▀   █    ▄▀▄▄▄▄    █▀▀▀    ▄▀▄▄▄▄    ▄▀▄▄▄▄▀ 
█    █    ▐   ▐   █    ▐    █    ▐    ▐       █    ▐   █     ▐  
▐    ▐            ▐         ▐                 ▐        ▐        
                  sync the time via rpcclient
                        Version: 20231009
                https://github.com/manesec/tools4mane
--------------------------------------------------------------"

if [ "$EUID" -ne 0 ]
  then echo "[!] Please run as root"
  exit
fi

command -v rpcclient >/dev/null

if [ $? -ne 0 ]; then
    echo "[ERR] No found rpcclient command in your system."
    exit 1
fi

usage() { 
    echo 'rpcsynctime.sh -u <user> -p <password> -i host'
    exit 0
}

######################### CHECK OPTION #######################
while getopts ":u:i:p:" o; do
    case "${o}" in
        u)
            u=${OPTARG}
            ;;
        p)
            p=${OPTARG}
            ;;
        i)
            i=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${p}" ] || [ -z "${u}" ] || [ -z "${i}" ]; then
    usage
fi


####################### RUN ###########################
echo "[*] Getting Remote Clocking With rpcclient ..."

exec_rpc=`rpcclient  -U "$u%$p" -c "queryuser $u" $i | grep "Logon Time" `

if [ -z "${exec_rpc}" ] ; then
    echo "[ERR] Error to fetching the result."
    exit 1
fi

sync_time=`echo $exec_rpc | cut -d ':' -f 2-`

echo "[*] Updating:$sync_time"
date -s "$sync_time" > /dev/null
echo "OK"