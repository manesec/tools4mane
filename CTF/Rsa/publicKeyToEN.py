# RSA: publicKey to E and N
## Try to attack d and decrypt the ciphertext.

## If e is very large, it can lead to a small private exponent d.
## However, a small d leads to a broken RSA encryption as described in this paper
## Paper: https://crypto.stanford.edu/~dabo/pubs/papers/RSA-survey.pdf

from Crypto.PublicKey import RSA
from Crypto.Util.number import long_to_bytes, bytes_to_long

publicKey = """-----BEGIN PUBLIC KEY-----
MIIBHzANBgkqhkiG9w0BAQEFAAOCAQwAMIIBBwKBgQMwO3kPsUnaNAbUlaubn7ip
4pNEXjvUOxjvLwUhtybr6Ng4undLtSQPCPf7ygoUKh1KYeqXMpTmhKjRos3xioTy
23CZuOl3WIsLiRKSVYyqBc9d8rxjNMXuUIOiNO38ealcR4p44zfHI66INPuKmTG3
RQP/6p5hv1PYcWmErEeDewKBgGEXxgRIsTlFGrW2C2JXoSvakMCWD60eAH0W2PpD
qlqqOFD8JA5UFK0roQkOjhLWSVu8c6DLpWJQQlXHPqP702qIg/gx2o0bm4EzrCEJ
4gYo6Ax+U7q6TOWhQpiBHnC0ojE8kUoqMhfALpUaruTJ6zmj8IA1e1M6bMqVF8sr
lb/N
-----END PUBLIC KEY-----"""

def get_pubkey(f):
    key = RSA.importKey(publicKey)
    return (key.n, key.e)

N, e = get_pubkey('./key.pub')

print(f'{e = }')
print(f'{N = }')


## Example output: e = 68180928631284147212820507192605734632035524131139938618069575375591806315288775310503696874509130847529572462608728019290710149661300246138036579342079580434777344111245495187927881132138357958744974243365962204835089753987667395511682829391276714359582055290140617797814443530797154040685978229936907206605

## Exploit ##

# We need to find a "d" value to decrypt the ciphertext.
# $ curl -O https://raw.githubusercontent.com/orisano/owiener/master/owiener.py

def get_ciphertext(file):
    with open(file, 'rb') as ct:
        return bytes_to_long(ct.read())

def decrypt_rsa(N, e, d, content):
    pt = pow(ct, d, N)
    return long_to_bytes(pt)

if True:
    # Attack to d
    import owiener
    print("\n")
    d = owiener.attack(e, N)
    print("Found d = %s " % d)

    # If success, decrypt the ciphertext, flag.enc is a encryption file.
    ct = get_ciphertext('./flag.enc')
    pt = decrypt_rsa(N, e, d, ct)
    print("Decrypted message: %s" % pt)
