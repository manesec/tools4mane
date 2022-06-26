# https://github.com/manesec/tools4mane
# write by Mane.

import argparse
import poplib
import sys

print("""
 ▄▀▀▄ ▄▀▄  ▄▀▀█▄   ▄▀▀▄ ▀▄  ▄▀▀█▄▄▄▄  ▄▀▀▀▀▄  ▄▀▀█▄▄▄▄  ▄▀▄▄▄▄  
█  █ ▀  █ ▐ ▄▀ ▀▄ █  █ █ █ ▐  ▄▀   ▐ █ █   ▐ ▐  ▄▀   ▐ █ █    ▌ 
▐  █    █   █▄▄▄█ ▐  █  ▀█   █▄▄▄▄▄     ▀▄     █▄▄▄▄▄  ▐ █      
  █    █   ▄▀   █   █   █    █    ▌  ▀▄   █    █    ▌    █      
▄▀   ▄▀   █   ▄▀  ▄▀   █    ▄▀▄▄▄▄    █▀▀▀    ▄▀▄▄▄▄    ▄▀▄▄▄▄▀ 
█    █    ▐   ▐   █    ▐    █    ▐    ▐       █    ▐   █     ▐  
▐    ▐            ▐         ▐                 ▐        ▐        
          List email from pop3 server - Tools4me by Mane.
                        Version: 20220228
                https://github.com/manesec/tools4mane
---------------------------------------------------------------""")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Fast Read Email from pop3 server.',\
    formatter_class=argparse.RawDescriptionHelpFormatter,\
    epilog="""\
Example:
  # Enum all email: 
  ./ListPop3Email.py -u "<username>" -p "<pass>" -H "<host>" -a
  # list email 
  ./ListPop3Email.py -u "<username>" -p "<pass>" -H "<host>" 
  # Read email 
  ./ListPop3Email.py -u "<username>" -p "<pass>" -H "<host>" -r <number>
""")


    parser.add_argument('--user','-u', type=str, required=True, help="POP3 Username")
    parser.add_argument('--passwd', '-p', type=str, required=True, help='POP3 Password')
    parser.add_argument('--host', '-H', type=str, required=True, help='POP3 Hosts')
    parser.add_argument('--port', '-P', type=int, default=110, help='POP3 Port')
    parser.add_argument('--all', '-a', action=argparse.BooleanOptionalAction, help='POP3 Enum All Email')
    parser.add_argument('--read', '-r', type=int,default=0, help='POP3 Read num from Email')
    input_parser = parser.parse_args()

    PopMail = poplib.POP3(input_parser.host,input_parser.port) 
    PopMail.user(input_parser.user)
    PopMail.pass_(input_parser.passwd)

    POPEmailNumber , _  = PopMail.stat()
    print("Total Email Number: %s" %(POPEmailNumber))

    if (input_parser.read != 0):
        print("-"*63)
        print("# Email %s" % (input_parser.read))
        for message in PopMail.retr(input_parser.read)[1]:
            print (message.decode('utf-8'))
        sys.exit(0)
    if(input_parser.all):
        for num in range(1,POPEmailNumber+1):
            print("-"*63)
            print("# Email %s" % (num))
            for message in PopMail.retr(num)[1]:
                print (message.decode('utf-8'))



