# You can just copy and paste the code below in powershell

$process = Get-WmiObject Win32_Process | Select-Object ProcessName, ExecutablePath, CommandLine;

while($true)
{
  Start-Sleep 0.1;
  $process2 = Get-WmiObject Win32_Process | Select-Object ProcessName, ExecutablePath, CommandLine;
  $obj = Compare-Object -ReferenceObject $process -DifferenceObject $process2;
  $process = $process2;
  if ($obj) {
	$ProcessName = $obj.InputObject.ProcessName;
	$ExecutablePath = $obj.InputObject.ExecutablePath;
	$CommandLine = $obj.InputObject.CommandLine;
	
	if (([string]::IsNullOrEmpty($CommandLine)))
	{
		if (([string]::IsNullOrEmpty($ExecutablePath))){ 
			$CommandLine = $ProcessName;
		}else{
			$CommandLine = $ExecutablePath ;
		}
	}
	if ($obj.SideIndicator -eq "=>") { 
		"[+] " + $CommandLine ;
	} else { 
		"[-] " + $CommandLine ;
	}  
  }
}