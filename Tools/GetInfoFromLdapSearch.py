# https://github.com/manesec/tools4mane
# write by @manesec.

import subprocess
import argparse
import sys

print("""
 ▄▀▀▄ ▄▀▄  ▄▀▀█▄   ▄▀▀▄ ▀▄  ▄▀▀█▄▄▄▄  ▄▀▀▀▀▄  ▄▀▀█▄▄▄▄  ▄▀▄▄▄▄  
█  █ ▀  █ ▐ ▄▀ ▀▄ █  █ █ █ ▐  ▄▀   ▐ █ █   ▐ ▐  ▄▀   ▐ █ █    ▌ 
▐  █    █   █▄▄▄█ ▐  █  ▀█   █▄▄▄▄▄     ▀▄     █▄▄▄▄▄  ▐ █      
  █    █   ▄▀   █   █   █    █    ▌  ▀▄   █    █    ▌    █      
▄▀   ▄▀   █   ▄▀  ▄▀   █    ▄▀▄▄▄▄    █▀▀▀    ▄▀▄▄▄▄    ▄▀▄▄▄▄▀ 
█    █    ▐   ▐   █    ▐    █    ▐    ▐       █    ▐   █     ▐  
▐    ▐            ▐         ▐                 ▐        ▐        
        Enum infomation from ldap search - Tools4me by @manesec.
                        Version: 20220626
                https://github.com/manesec/tools4mane
---------------------------------------------------------------""")

def print_header(header):
    print("="*70)
    print("#     " + header)
    print("="*70)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Enum all information from ldapsearch.',\
    formatter_class=argparse.RawDescriptionHelpFormatter,\
    epilog="""\
Example:
  ./GetInfoFromLdapSearch.py -H <ldap_ip>
""")

    parser.add_argument('--host', '-H', type=str, required=True, help='LDAP Hosts')
    input_parser = parser.parse_args()

    # Banner Grab
    print_header("Grab LDAP Banner")
    output = subprocess.getoutput("nmap -p 389 --script ldap-search -Pn %s" % (input_parser.host))
    print(output)

    # LdapSearch
    print_header("LdapSearch")
    output = subprocess.getoutput("ldapsearch -h %s -x" % (input_parser.host))
    print(output)


    print_header("LdapSearch Naming Context Dump")
    output = subprocess.getoutput("ldapsearch -x -h %s -s base namingcontexts" % (input_parser.host))
    print(output)

    # enum namingcontexts
    namingContexts = []
    for line in output.split("\n"):
        if (line.find("namingContexts:")!=-1):
            namingContexts.append(line.replace("namingContexts:","").strip())
    if (len(namingContexts) == 0):
        print("[!] No found naming contexts.")
        sys.exit(0)

    # enum each 
    for namingContext in namingContexts:
        print_header("namingcontext: %s" % namingContext)
        output = subprocess.getoutput("ldapsearch -h %s -x -b '%s'" % (input_parser.host,namingContext))
        print(output)    

    
