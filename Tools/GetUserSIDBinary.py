#!/usr/bin/env python3
"""
# write by @manesec.
This script uses Impacket's LDAP library to query an Active Directory domain controller
for a specified user's SID. It retrieves the binary SID (e.g. 0x0105000000000005150000004b2233992a9592e91111a99da4f040000)
and converts it into its string representation (e.g. S-1-5-21-...).

It supports both NTLM and Kerberos authentication (including the -no-pass option).

Example:
    python3 getUserSIDBinary.py -target-user htb-student manesec.htb/mane:passwprd@dc01.manesec.htb
"""

from __future__ import print_function, unicode_literals

import argparse
import logging
import sys
import struct

from datetime import datetime

from impacket import version
from impacket.examples import logger
from impacket.examples.utils import parse_credentials
from impacket.ldap import ldap, ldapasn1
from impacket.smbconnection import SMBConnection, SessionError


def convert_sid(sid_bytes):
    """
    Converts a binary SID to its string representation.
    SID structure:
        1 byte: Revision
        1 byte: Sub-authority count
        6 bytes: IdentifierAuthority (big-endian)
        Then: SubAuthority count (4 bytes each, little-endian)
    """
    if len(sid_bytes) < 8:
        raise ValueError("SID bytes too short!")
    revision = sid_bytes[0]
    sub_authority_count = sid_bytes[1]
    identifier_authority = int.from_bytes(sid_bytes[2:8], byteorder='big')
    sid_str = "S-%d-%d" % (revision, identifier_authority)
    for i in range(sub_authority_count):
        start = 8 + i * 4
        if len(sid_bytes) < start + 4:
            raise ValueError("SID bytes truncated while reading sub-authority #%d" % (i + 1))
        sub_auth = struct.unpack('<I', sid_bytes[start:start + 4])[0]
        sid_str += "-%d" % sub_auth
    return sid_str


class GetUserSID:
    def __init__(self, username, password, domain, options):
        self.options = options
        self.__username = username
        self.__password = password
        self.__domain = domain
        self.__target = None
        self.__lmhash = ''
        self.__nthash = ''
        self.__aesKey = options.aesKey
        self.__doKerberos = options.k
        # in this script, -dc-ip is self.__kdcIP and -dc-host is self.__kdcHost
        self.__kdcIP = options.dc_ip
        self.__kdcHost = options.dc_host

        # The target user we wish to query
        self.__targetUser = options.target_user

        if options.hashes is not None:
            self.__lmhash, self.__nthash = options.hashes.split(':')

        # Create the baseDN from the domain (e.g. example.com -> dc=example,dc=com)
        domainParts = self.__domain.split('.')
        self.baseDN = ','.join('dc=%s' % part for part in domainParts)

    def getMachineName(self, target):
        try:
            s = SMBConnection(target, target)
            s.login('', '')
        except OSError as e:
            if 'timed out' in str(e):
                raise Exception('The connection timed out. Perhaps port 445/TCP is closed. '
                                'Try specifying the correct NetBIOS name or FQDN with -dc-host')
            else:
                raise
        except SessionError as e:
            if 'STATUS_NOT_SUPPORTED' in str(e):
                raise Exception('SMB request not supported. Possibly NTLM is disabled. '
                                'Try specifying the correct NetBIOS name or FQDN with -dc-host')
            else:
                raise
        except Exception:
            if s.getServerName() == '':
                raise Exception('Error during anonymous login to %s' % target)
        else:
            s.logoff()
        return s.getServerName()

    def processRecord(self, record):
        """
        Process a single LDAP record: retrieve the sAMAccountName and objectSid,
        convert the binary SID into a string representation, and print both.
        """
        if not isinstance(record, ldapasn1.SearchResultEntry):
            return

        userName = None
        objectSidBinary = None
        try:
            for attribute in record['attributes']:
                attr_type = str(attribute['type'])
                if attr_type.lower() == 'samaccountname':
                    userName = attribute['vals'][0].asOctets().decode('utf-8')
                elif attr_type.lower() == 'objectsid':
                    objectSidBinary = attribute['vals'][0].asOctets()
            if userName is None:
                userName = "<unknown>"
            if objectSidBinary is None:
                logging.error("objectSid not found for user %s" % userName)
                return
            # Convert binary SID to hex string (e.g. 0x...)
            sid_hex = "0x" + objectSidBinary.hex()
            # Convert binary SID to standard string format
            sid_str = convert_sid(objectSidBinary)
            print("[+] %s:" % userName)
            print("    Binary SID: %s" % sid_hex)
            print("    String SID: %s" % sid_str)
        except Exception as e:
            logging.error("Error processing record: %s" % str(e))
            return

    def run(self):
        # Determine target DC name/IP
        if self.__kdcHost is not None:
            self.__target = self.__kdcHost
        else:
            if self.__kdcIP is not None:
                self.__target = self.__kdcIP
            else:
                self.__target = self.__domain

            if self.__doKerberos:
                logging.info('Getting machine hostname from %s' % self.__target)
                self.__target = self.getMachineName(self.__target)

        # Connect to LDAP
        try:
            ldap_url = 'ldap://%s' % self.__target
            ldapConnection = ldap.LDAPConnection(ldap_url, self.baseDN, self.__kdcIP)
            if not self.__doKerberos:
                ldapConnection.login(self.__username, self.__password, self.__domain,
                                     self.__lmhash, self.__nthash)
            else:
                ldapConnection.kerberosLogin(self.__username, self.__password, self.__domain,
                                             self.__lmhash, self.__nthash, self.__aesKey,
                                             kdcHost=self.__kdcIP)
        except ldap.LDAPSessionError as e:
            if 'strongerAuthRequired' in str(e):
                # Try SSL
                ldap_url = 'ldaps://%s' % self.__target
                ldapConnection = ldap.LDAPConnection(ldap_url, self.baseDN, self.__kdcIP)
                if not self.__doKerberos:
                    ldapConnection.login(self.__username, self.__password, self.__domain,
                                         self.__lmhash, self.__nthash)
                else:
                    ldapConnection.kerberosLogin(self.__username, self.__password, self.__domain,
                                                 self.__lmhash, self.__nthash, self.__aesKey,
                                                 kdcHost=self.__kdcIP)
            else:
                raise

        logging.info("Querying LDAP on %s for user '%s'" % (self.__target, self.__targetUser))

        # Build search filter for the target user
        searchFilter = "(&(objectClass=user)(sAMAccountName=%s))" % self.__targetUser

        try:
            # Request only the sAMAccountName and objectSid attributes
            ldapConnection.search(searchFilter=searchFilter,
                                    attributes=['sAMAccountName', 'objectSid'],
                                    sizeLimit=0,
                                    perRecordCallback=self.processRecord)
        except ldap.LDAPSearchError as e:
            logging.error("LDAP search error: %s" % str(e))
        finally:
            ldapConnection.close()


if __name__ == '__main__':
    print(version.BANNER)

    parser = argparse.ArgumentParser(
        description="Query target domain for a user's SID and convert it from binary to string format."
    )

    parser.add_argument('target', action='store',
                        help='domain[/username[:password]] (e.g. domain.com/username:password)')

    parser.add_argument('-target-user', required=True,
                        help='The domain user whose SID you want to query (sAMAccountName)')

    # Authentication group
    auth_group = parser.add_argument_group('authentication')
    auth_group.add_argument('-hashes', metavar="LMHASH:NTHASH",
                            help='NTLM hashes, format is LMHASH:NTHASH')
    auth_group.add_argument('-no-pass', action="store_true",
                            help="Don't ask for password (useful for Kerberos with -k)")
    auth_group.add_argument('-k', action="store_true",
                            help="Use Kerberos authentication. Grabs credentials from ccache file (KRB5CCNAME) "
                                 "based on target parameters. If valid credentials cannot be found, "
                                 "it will use the ones specified on the command line")
    auth_group.add_argument('-aesKey', metavar="hex key",
                            help='AES key to use for Kerberos Authentication (128 or 256 bits) No TEST')

    # Connection group
    conn_group = parser.add_argument_group('connection')
    conn_group.add_argument('-dc-ip', metavar='ip address',
                            help='IP Address of the domain controller. If omitted, the domain part specified in '
                                 'the target parameter is used')
    conn_group.add_argument('-dc-host', metavar='hostname',
                            help='Hostname of the domain controller to use. If omitted, the domain part specified '
                                 'in the target parameter will be used')

    # Debug and timestamp options
    parser.add_argument('-ts', action='store_true', help='Adds timestamp to every logging output')
    parser.add_argument('-debug', action='store_true', help='Turn DEBUG output ON')

    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(1)

    options = parser.parse_args()

    # Initialize logger output
    logger.init(options.ts)
    if options.debug:
        logging.getLogger().setLevel(logging.DEBUG)
        logging.debug("Debug mode is ON")
    else:
        logging.getLogger().setLevel(logging.INFO)

    # Parse the target string: domain[/username[:password]]@dc
    domain, username, password = parse_credentials(options.target)

    logging.debug("Domain: %s " % domain)
    logging.debug("Username: %s " % username)
    logging.debug("Password: %s " % password)

    if domain == '':
        logging.critical('Domain must be specified!')
        sys.exit(1)

    if username == '':
        logging.critical('Username must be specified in target parameter!')
        sys.exit(1)

    if password == '' and not options.no_pass and options.hashes is None and options.aesKey is None:
        from getpass import getpass
        password = getpass("Password:")

    if options.aesKey is not None:
        options.k = True

    try:
        executor = GetUserSID(username, password, domain, options)
        executor.run()
    except Exception as e:
        logging.error(str(e))
        if logging.getLogger().level == logging.DEBUG:
            import traceback
            traceback.print_exc()