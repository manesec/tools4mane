# https://www.geeksforgeeks.org/python-convert-string-to-unicode-characters/
# Python3 code to demonstrate working of
# Convert String to unicode characters
# using join() + format() + ord()
import re
 
# initializing string
test_str = 'geeksforgeeks'
 
# printing original String
print("The original string is : " + str(test_str))
 
# using format to perform required formatting
res = ''.join(r'\u{:04X}'.format(ord(chr)) for chr in test_str)
 
# printing result
print("The unicode converted String : " + str(res))