# find magic hash for hashes of the form 0e[0-9]*
# example for md5


import hashlib
import re
import string
import itertools

wantedHashesPattern = re.compile(r"^0e([0-9]*)$")
salt = 'it6z'
maxLength = 6
passwordCharacters = string.ascii_letters + string.digits + string.punctuation

for i in range(1, maxLength + 1):
    for password in itertools.product(passwordCharacters, repeat = i):
        password = ''.join(password)
        hashInput = salt + password
        hash = hashlib.md5(hashInput.encode()).hexdigest()
        if wantedHashesPattern.match(hash):
            print(f"{password} ---> {hash}")
            break
    else:
        continue
    break