# This script queries every computer in WorkstationList for the installed programs and features. The results are filtered to return only DeltaV Workstation hotfixes.

if (Test-Path "InstalledHotfixes.txt"){del "InstalledHotfixes.txt"}

$computers = gc "WorkstationList.txt"

foreach ($computer in $computers) {
	$computer
	Add-Content "InstalledHotfixes.txt" $computer

	if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
		$regkey='SOFTWARE\microsoft\windows\currentversion\uninstall'
		$reg=[Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$computer)
		$keylist=$reg.OpenSubKey($regkey)

		foreach ($key in $keylist.GetSubKeyNames()){
			$tempkey = $keylist.OpenSubKey($key)

			#### Modify this if statement to change the filtering criteria. ####
			if ($tempkey.GetValue('DisplayName') -like "DeltaV*WS*") {
				$tempkey.GetValue('DisplayName')
				Add-Content "InstalledHotfixes.txt" $tempkey.GetValue('DisplayName')
			}
	
		}
		
	} else {
		"Could not connect to $computer"
		Add-Content "InstalledHotfixes.txt" "Could not connect to $computer"
	}


	""
	Add-Content "InstalledHotfixes.txt" ""
}


.\InstalledHotfixes.txt