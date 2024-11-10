
$users = Get-ChildItem "C:\Users"
foreach ($user in $users) {
    " ========== $user =========" ;
    $folders = Get-ChildItem -Directory -force "C:\Users\$user\AppData\Roaming\Microsoft\Protect\" -ErrorAction SilentlyContinue; 
	foreach ($folder in $folders) {
		"C:\Users\$user\AppData\Roaming\Microsoft\Protect\$folder"
		Get-ChildItem -force "C:\Users\$user\AppData\Roaming\Microsoft\Protect\$folder" -ErrorAction SilentlyContinue | foreach {$_.Fullname}
	}
	
	$folders = Get-ChildItem -Directory -force "C:\Users\$user\AppData\Local\Microsoft\Protect\" -ErrorAction SilentlyContinue
	foreach ($folder in $folders) {
		"C:\Users\$user\AppData\Local\Microsoft\Protect\$folder"
		Get-ChildItem -force "C:\Users\$user\AppData\Local\Microsoft\Protect\$folder" -ErrorAction SilentlyContinue | foreach {$_.Fullname}
	}
}
