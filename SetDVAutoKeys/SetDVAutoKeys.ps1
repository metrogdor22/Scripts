# This script sets the AutoDvLogon, AutoLaunchOperatorInterface, and AutoSwitchingEnabled registry keys on all computers in WorkstationList.
# Please report any bugs or suggestions to Drew Hutchins (Drew.Hutchins@JohnHCarter.com)

$version = "v0.1 - 2022-01-07"
$instructions = "Instructions: Populate WorkstationList.txt with target computers. Enter the desired settings for each key when prompted. Text in [brackets] are default values, which will be used if no value is specified. Program output is saved to SetDVAutoKeys.txt"

""
Write-Host "SetDVAutoKeys $version" -ForegroundColor Green
Write-Host $instructions -ForegroundColor Cyan
""

$computers = gc "WorkstationList.txt"

# Remove existing log file
if (Test-Path "SetDVAutoKeys.txt"){del "SetDVAutoKeys.txt"}

# Prompt for key settings
$AutoDvLogon = Read-Host -Prompt "AutoDvLogon [1] "
if ([string]::IsNullOrWhiteSpace($AutoDvLogon)){
	$AutoDvLogon = 1
}
$AutoLaunchOperatorInterface = Read-Host -Prompt "AutoLaunchOperatorInterface [0] "
if ([string]::IsNullOrWhiteSpace($AutoLaunchOperatorInterface)){
	$AutoLaunchOperatorInterface = 0
}
$AutoSwitchingEnabled = Read-Host -Prompt "AutoSwitchingEnabled [0] "
if ([string]::IsNullOrWhiteSpace($AutoSwitchingEnabled)){
	$AutoSwitchingEnabled = 0
}

""

foreach ($computer in $computers) {
	$computer
	Add-Content "SetDVAutoKeys.txt" $computer

	if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
		$reg=[Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$computer)
		$regkey='SOFTWARE\WOW6432Node\FRSI\DeltaV\CurrentVersion'
		$key = $reg.OpenSubKey($regkey, $true)
		
		# Set AutoDvLogon
		$key.SetValue("AutoDvLogon", $AutoDvLogon)
		if ($key.GetValue("AutoDvLogon") -eq $AutoDvLogon){
			"AutoDvLogon = $AutoDvLogon" | Tee-Object -FilePath "SetDVAutoKeys.txt" -Append
		} else {
			"Could not set AutoDvLogon" | Tee-Object -FilePath "SetDVAutoKeys.txt" -Append
		}

		# Set AutoLaunchOperatorInterface
		$key.SetValue("AutoLaunchOperatorInterface", $AutoLaunchOperatorInterface)
		if ($key.GetValue("AutoLaunchOperatorInterface") -eq $AutoLaunchOperatorInterface){
			"AutoLaunchOperatorInterface = $AutoLaunchOperatorInterface" | Tee-Object -FilePath "SetDVAutoKeys.txt" -Append
		} else {
			"Could not set AutoLaunchOperatorInterface" | Tee-Object -FilePath "SetDVAutoKeys.txt" -Append
		}

		# Set AutoSwitchingEnabled
		$key.SetValue("AutoSwitchingEnabled", $AutoSwitchingEnabled)
		if ($key.GetValue("AutoSwitchingEnabled") -eq $AutoSwitchingEnabled){
			"AutoSwitchingEnabled = $AutoSwitchingEnabled" | Tee-Object -FilePath "SetDVAutoKeys.txt" -Append
		} else {
			"Could not set AutoSwitchingEnabled" | Tee-Object -FilePath "SetDVAutoKeys.txt" -Append
		}

		
	} else {
		"Could not connect to $computer" | Tee-Object -FilePath "SetDVAutoKeys.txt" -Append
	}


	"" | Tee-Object -FilePath "SetDVAutoKeys.txt" -Append
}


.\SetDVAutoKeys.txt