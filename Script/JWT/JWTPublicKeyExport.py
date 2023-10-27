#!/usr/bin/env python3

# Export JWT Key with n and e.

# write by manesec & chatgpt.

from Crypto.PublicKey import RSA
import json
from base64 import urlsafe_b64decode

def get_public_key():
    with open('jwks.json') as file:
        data = json.load(file)
        
        # Assuming there is only one key in the 'keys' array
        key = data['keys'][0]
        
        modulus = int.from_bytes(urlsafe_b64decode(key['n'] + '=='), 'big')
        exponent = int.from_bytes(urlsafe_b64decode(key['e'] + '=='), 'big')
        
        # Construct the RSA public key
        public_key = RSA.construct((modulus, exponent))
        
        return public_key

# Usage example
public_key = get_public_key()
print(public_key.export_key().decode())
