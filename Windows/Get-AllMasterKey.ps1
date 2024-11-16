$searchDir = "C:\Users"
$users = Get-ChildItem $searchDir
foreach ($user in $users) {
    " ========== $user - Master Key =========" ;
    $folders = Get-ChildItem -Directory -force "$searchDir\$user\AppData\Roaming\Microsoft\Protect\" -ErrorAction SilentlyContinue; 
	foreach ($folder in $folders) {
		"$searchDir\$user\AppData\Roaming\Microsoft\Protect\$folder"
		Get-ChildItem -force "$searchDir\$user\AppData\Roaming\Microsoft\Protect\$folder" -ErrorAction SilentlyContinue | foreach {$_.Fullname}
	}
	
	$folders = Get-ChildItem -Directory -force "$searchDir\$user\AppData\Local\Microsoft\Protect\" -ErrorAction SilentlyContinue
	foreach ($folder in $folders) {
		"$searchDir\$user\AppData\Local\Microsoft\Protect\$folder"
		Get-ChildItem -force "$searchDir\$user\AppData\Local\Microsoft\Protect\$folder" -ErrorAction SilentlyContinue | foreach {$_.Fullname}
	}
	
    " ========== $user - Secret =========" ;
	Get-ChildItem -force "$searchDir\$user\AppData\Roaming\Microsoft\Credentials" -ErrorAction SilentlyContinue | foreach {$_.Fullname}	
	
}
