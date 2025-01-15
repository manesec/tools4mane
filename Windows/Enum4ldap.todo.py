# TODO 

from ldap3 import *
import sys

class Enum4Ldap():

    def startEnum(self):
        pass

    def __init__(self, ip, username, password):
        self.server = Server(ip,get_info = ALL)
        self.conn = Connection(self.server, user=username, password=password)

        self.default_naming_context = None

        if self.conn.bind() : 
            print("[*] Bind OK!")

            # Search for the default naming context
            self.conn.search(search_base='', search_filter='(objectClass=*)', search_scope='BASE', attributes=['defaultNamingContext'])

            # Extract and print the default naming context
            if self.conn.entries:
                self.default_naming_context = self.conn.entries[0]['defaultNamingContext']
                print('[*] Default Naming Context:', self.default_naming_context)
            else:
                print('[Error] No default naming context found.')
                sys.exit()

        else:
            print("[*] Bind failed!")

if __name__ == "__main__":
    ip = "10.129.42.188"
    username = ""
    password = ""
    Enum4Ldap(ip, username, password)
