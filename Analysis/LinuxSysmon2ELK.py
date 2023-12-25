# Read sysmon linux from syslog to elk.

# LinuxSysmon2ELK.py <syslog>

import json,sys,requests
import xmltodict

INDEX = ["sysmon"]

def import_to_elk(data):
    data = """{ "index" : { "_index" : "%s" } } \n%s\n\n \r\n""" % (INDEX[0],json.dumps(data))
    proxies = {
       'http': 'http://127.0.0.1:8080',
       'https': 'http://127.0.0.1:8080',
    }
    burp0_url = "http://127.0.0.1:9200/_bulk?pretty"
    burp0_headers = {"Authorization": "Basic ZWxhc3RpYzpjaGFuZ2VtZQ==", "User-Agent": "curl/7.88.1", "Accept": "*/*", "Content-Type": "application/json", "Connection": "close"}
    burp0_json=data
    req = requests.post(burp0_url, headers=burp0_headers, data=burp0_json,verify=False).text

with open(sys.argv[1]) as fd:
    for line in fd.read().split('\x0a'):
        try:
            if (line.find("sysmon") == -1):
                continue
            line = line.strip()
            record = line.split('sysmon:')[1]
            doc = xmltodict.parse(record)
            import_to_elk(doc)
        except:
            print("Error: " + line)
            continue
