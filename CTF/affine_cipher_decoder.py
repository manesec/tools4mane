# affine cipher decoder
# This is (123 * x + 18) % 256

# Input like : 7e0a9372ec49a3f6930ed8723f9df6f6720ed8d89dc4937222ec7214d89d1e0e352ce0aa6ec82bf622227bb70e7fb7352249b7d893c493d8539dec8fb7935d490e7f9d22ec89b7a322ec8fd80e7f8921
decode_str = ""


def encryption(msg):
    ct = []
    for char in msg:
        ct.append((123 * ord(char) + 18) % 256)
    return bytes(ct)

tables_dict = {}

for x in range(32,126):
    tables_dict[encryption(chr(x)).hex()] = chr(x)

import re

lists = (re.findall(".{2}",decode_str))

for ch in lists:
    if (ch in tables_dict.keys()):
        print(tables_dict[ch],end='')
        continue 
    print(ch,end='')