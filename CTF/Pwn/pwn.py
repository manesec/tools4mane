from pwn import *
import time

#proc = process("./callme")
proc = gdb.debug("./callme32",'b pwnme')

time.sleep(1)
print(proc.recv())



payload = ""


proc.sendline(payload)
proc.interactive()
