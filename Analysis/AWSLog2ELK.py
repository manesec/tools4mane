#!/usr/bin/env python

# Simple Script to import AWS log to ELK.
# SEE: https://manesec.github.io/2023/12/19/2023-12-elk-and-json/

import requests,os,json

IMPORT_DIR = "/home/mane/Downloads/x/x-cloudtrail"

def found_json():
    json_file_lists = []
    for  dirpath, dirnames, filenames in os.walk(IMPORT_DIR):
        for filename in [f for f in filenames if f.endswith(".json")]:
            json_file_lists.append(os.path.join(dirpath, filename))

    total_files = len(json_file_lists)
    print("[*] Found %s json files." % (total_files))

    index = 0
    for json_file in json_file_lists:
        print("[%s/%s] Reading %s ..." % (index,total_files,filename))
        process_json_file(json_file)
        index = index +  1

def process_json_file(filename):
    with open(filename, 'r') as f:
        data = f.read()
        j = json.loads(data)["Records"]
        print("[*] Importing %s Records ..." % (len(j)))
        for records in j:
            import_to_elk(records)

def import_to_elk(data):
    data = """{ "index" : { "_index" : "test" } } \n%s\n\n \r\n""" % (json.dumps(data))
    proxies = {
       'http': 'http://127.0.0.1:8080',
       'https': 'http://127.0.0.1:8080',
    }
    burp0_url = "http://127.0.0.1:9200/_bulk?pretty"
    burp0_headers = {"Authorization": "Basic ZWxhc3RpYzpjaGFuZ2VtZQ==", "User-Agent": "curl/7.88.1", "Accept": "*/*", "Content-Type": "application/json", "Connection": "close"}
    burp0_json=data
    requests.post(burp0_url, headers=burp0_headers, data=burp0_json,verify=False)

found_json()