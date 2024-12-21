#! /bin/python3
# https://github.com/manesec/tools4mane
# write by @manesec.

import sys

print("""
 ▄▀▀▄ ▄▀▄  ▄▀▀█▄   ▄▀▀▄ ▀▄  ▄▀▀█▄▄▄▄  ▄▀▀▀▀▄  ▄▀▀█▄▄▄▄  ▄▀▄▄▄▄  
█  █ ▀  █ ▐ ▄▀ ▀▄ █  █ █ █ ▐  ▄▀   ▐ █ █   ▐ ▐  ▄▀   ▐ █ █    ▌ 
▐  █    █   █▄▄▄█ ▐  █  ▀█   █▄▄▄▄▄     ▀▄     █▄▄▄▄▄  ▐ █      
  █    █   ▄▀   █   █   █    █    ▌  ▀▄   █    █    ▌    █      
▄▀   ▄▀   █   ▄▀  ▄▀   █    ▄▀▄▄▄▄    █▀▀▀    ▄▀▄▄▄▄    ▄▀▄▄▄▄▀ 
█    █    ▐   ▐   █    ▐    █    ▐    ▐       █    ▐   █     ▐  
▐    ▐            ▐         ▐                 ▐        ▐        

              Xor Tools - Tools4me by @manesec
                    Version: 20220607
            https://github.com/manesec/tools4mane
---------------------------------------------------------------
Example:
    key with hex: 0xfa
    python3 xor_tools.py sleep.bin fa sleep.bin.test
""")

def xor_encrypt_decrypt(input_file, key_hex, output_file):
    key = bytes.fromhex(key_hex)
    key_length = len(key)
    
    with open(input_file, 'rb') as f:
        data = f.read()
    
    xor_data = bytes([b ^ key[i % key_length] for i, b in enumerate(data)])
    
    with open(output_file, 'wb') as f:
        f.write(xor_data)

def main():
    if len(sys.argv) != 4:
        print("Usage: xor_tools.py <input> <key> <output>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    key_hex = sys.argv[2]
    output_file = sys.argv[3]
    
    xor_encrypt_decrypt(input_file, key_hex, output_file)

if __name__ == "__main__":
    main()
