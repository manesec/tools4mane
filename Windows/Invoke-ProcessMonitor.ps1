# You can just copy and paste the code below in powershell



# Check Detection Method
$detectMethod = 0;

try {
	$process = Get-WmiObject Win32_Process -ErrorAction Stop;
	$detectMethod = 1;
} catch { "[!] Permission Denied for WMI, Using Get-Process ..." }

try {
	$process = Get-Process -ErrorAction Stop;
	$detectMethod = 2;
} catch { "[!] Permission Denied for Get-Process, Giving up ..." }

# Method 1: WMI
if ($detectMethod -eq 1) {

	$process = Get-WmiObject Win32_Process | Select-Object ProcessName, ProcessId, ExecutablePath, CommandLine;

	while($true)
	{
		Start-Sleep 0.1;
		$timestamp = Get-Date -Format "HH:mm:ss"; 
		$process2 = Get-WmiObject Win32_Process | Select-Object ProcessName, ProcessId, ExecutablePath, CommandLine;
		
		$obj = Compare-Object -ReferenceObject $process -DifferenceObject $process2;
		$process = $process2;
		if ($obj) {
			$ProcessName = $obj.InputObject.ProcessName;
			$ExecutablePath = $obj.InputObject.ExecutablePath;
			$CommandLine = $obj.InputObject.CommandLine;
			$ProcessId = $obj.InputObject.ProcessId;
			
			if (([string]::IsNullOrEmpty($CommandLine)))
			{
				if (([string]::IsNullOrEmpty($ExecutablePath))){ 
					$CommandLine = $ProcessName;
				}else{
					$CommandLine = $ExecutablePath ;
				}
			}
			if ($obj.SideIndicator -eq "=>") { 
				Write-Host "[$timestamp] STARTED: PID: $ProcessId - Path: $CommandLine" -ForegroundColor Green; 
				
			} else { 
				Write-Host "[$timestamp] STOPPED: PID: $ProcessId - Path: $CommandLine" -ForegroundColor Red; 
			}  
		}
	}
}

# Method 2: Get-Process
if ($detectMethod -eq 2) {

	$previousList = Get-Process | Select-Object -Property Id, Name, Path -ErrorAction SilentlyContinue;

	while ($true) {
		Start-Sleep -Seconds 0.1;
		$currentList = Get-Process | Select-Object -Property Id, Name, Path -ErrorAction SilentlyContinue;
		$differences = Compare-Object -ReferenceObject $previousList -DifferenceObject $currentList -Property Id -PassThru;
		
		if ($differences) {
			$timestamp = Get-Date -Format "HH:mm:ss"; 
			
			foreach ($process in $differences) {
				
				$pathDisplay = $process.Path;
				if ([string]::IsNullOrEmpty($pathDisplay)) {
					$pathDisplay = "[Path not accessible]"; 
				}

				if ($process.SideIndicator -eq "=>") {
					Write-Host "[$timestamp] STARTED: $($process.Name) (PID: $($process.Id)) - Path: $pathDisplay" -ForegroundColor Green; 
				}
				elseif ($process.SideIndicator -eq "<=") {
					Write-Host "[$timestamp] STOPPED: $($process.Name) (PID: $($process.Id)) - Path: $pathDisplay" -ForegroundColor Red; 
				}
			}
		}
		$previousList = $currentList;
	}
}