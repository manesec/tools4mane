# https://github.com/manesec/tools4mane
# write by @manesec.

from operator import ge
import re
import argparse
from types import prepare_class
import requests
from concurrent.futures import ThreadPoolExecutor
import subprocess

print("""
 ▄▀▀▄ ▄▀▄  ▄▀▀█▄   ▄▀▀▄ ▀▄  ▄▀▀█▄▄▄▄  ▄▀▀▀▀▄  ▄▀▀█▄▄▄▄  ▄▀▄▄▄▄  
█  █ ▀  █ ▐ ▄▀ ▀▄ █  █ █ █ ▐  ▄▀   ▐ █ █   ▐ ▐  ▄▀   ▐ █ █    ▌ 
▐  █    █   █▄▄▄█ ▐  █  ▀█   █▄▄▄▄▄     ▀▄     █▄▄▄▄▄  ▐ █      
  █    █   ▄▀   █   █   █    █    ▌  ▀▄   █    █    ▌    █      
▄▀   ▄▀   █   ▄▀  ▄▀   █    ▄▀▄▄▄▄    █▀▀▀    ▄▀▄▄▄▄    ▄▀▄▄▄▄▀ 
█    █    ▐   ▐   █    ▐    █    ▐    ▐       █    ▐   █     ▐  
▐    ▐            ▐         ▐                 ▐        ▐        
            Guess PID From Url With Curl - Tools4me by @manesec.
                           Version: 0.1
                https://github.com/manesec/tools4mane
---------------------------------------------------------------""")

parser = argparse.ArgumentParser(description='Using for guess process in linux when have injection from web.',\
    formatter_class=argparse.RawDescriptionHelpFormatter,\
    epilog="""\
Example:
  # Normal scan.
  GuessPIDFromUrlCurl.py -u "to curl tools"
  # Filted all include *nofound*.
  GuessPIDFromUrlCurl.py -u "http://null/?proc={PID}/cmdline" -E *nofound*
  # Filted all include *nofound* start pid in 100 to 6000.
  GuessPIDFromUrlCurl.py -u "http://null/?proc={PID}/cmdline" -s 100 -e 6000 -E ^nofound 
  # (.*) will be return.
  GuessPIDFromUrlCurl.py -u "http://null/?proc={PID}/cmdline" -s 100 -e 6000 -G /proc/(.*) 
  # select with field number.
  GuessPIDFromUrlCurl.py -u "http://null/?proc={PID}/cmdline" -s 100 -e 6000 -G /proc/(.*)/(.*) -F 2

""")

parser.add_argument('-u',"--cmd",type=str, metavar="url", required=True, help="What command pass with curl (Flag:{PID})")
parser.add_argument('-t',"--thread",type=int,metavar="num",default=10,help="number of threads (Default:10)")
parser.add_argument('-E',"--exclude",type=str,metavar="str",help="if exits those str, it will be filterd using regular format")
parser.add_argument('-G',"--grep",type=str,metavar="str",help="grep from return message and using <spaces> and using regular format")
parser.add_argument('-F',"--fields",type=int,metavar="num",default=1,help="select only these fields (Default:1)")
parser.add_argument('-s','--start',type=int,metavar="num",default=1,help="guess PID start from (Default:1)")
parser.add_argument('-e','--end',type=int,metavar="num",default=65536,help="guess PID to num (Default:65536)")
parser.add_argument('-c','--code',type=int,metavar="num",default=0,help="accept http code (Default:200) or (0 = all)")
parser.add_argument('-o','--output',type=str,metavar="str",help="output to file")


args = parser.parse_args()
# print("Args: " + str(args))
save_output = ""

def fetch_thread(pid):
    global args
    global save_output
    cmd = args.cmd.replace("{PID}",str(pid)).strip()

    try:
        getexitcode, output=subprocess.getstatusoutput("/usr/bin/curl -s " + cmd)
        if (getexitcode != 0):
            return

        get = output
  
        if (args.exclude!=None):
            if (get.find(args.exclude)!=-1):
                return
        if (args.grep != None):
            get = re.search(args.grep,get).group(args.fields)

        if (get.strip() == ""):
            return
       
        output_thread = "[%s] %s" % (pid,get.strip())
        if (args.output != None):
            save_output = save_output + output_thread + "\n"
        print(output_thread)
    except Exception as e:
        pass


print("[+] Starting threads ...")
with ThreadPoolExecutor(max_workers=args.thread) as threadpool:
    for x in range(args.start,args.end+1):
        threadpool.submit(fetch_thread,x)

if (args.output != None):
    print("[+] Saving in %s ..." % (args.output))
    f = open(args.output,'w')
    f.writelines(save_output)
    f.close()

print("[!] All tasks complete.")

