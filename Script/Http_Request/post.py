#!/usr/bin/env python3

import requests
import json
 
apiUrl = "http://10.129.95.200/api/getColleagues"
headers = {"Content-Type": "application/json"}


while True:
    input_str = input("$ ")
    
    data = {"name": input_str}

    jsonData = json.dumps(data)
     
    res = requests.post(url=apiUrl, data=jsonData, headers=headers)
     
    print(res.text)

