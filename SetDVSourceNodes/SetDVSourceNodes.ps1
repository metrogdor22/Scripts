# This script sets the EventNode and HistorianNode registry keys on all computers in WorkstationList.
# Please report any bugs or suggestions to Drew Hutchins (Drew.Hutchins@JohnHCarter.com)

$version = "v0.1 - 2022-05-22"
$instructions = "Instructions: Populate WorkstationList.txt with target computers. Enter the desired settings for each key when prompted. Program output is saved to SetDVAutoKeys.txt"

""
Write-Host "SetDVSourceNodes $version" -ForegroundColor Green
Write-Host $instructions -ForegroundColor Cyan
""

$computers = gc "WorkstationList.txt"

# Remove existing log file
if (Test-Path "SetDVSourceNodes.txt"){del "SetDVSourceNodes.txt"}

# Edit these two lines to change the default values
$EventNodeDefault = ""
$HistorianNodeDefault = ""

# Prompt for key settings
$EventNode = Read-Host -Prompt "EventNode "
if ([string]::IsNullOrWhiteSpace($EventNode)){
	$EventNode = $EventNodeDefault
}
$HistorianNode = Read-Host -Prompt "HistorianNode "
if ([string]::IsNullOrWhiteSpace($HistorianNode)){
	$HistorianNode = $HistorianNodeDefault
}

""

foreach ($computer in $computers) {
	$computer
	Add-Content "SetDVSourceNodes.txt" $computer

	if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
		$reg=[Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('CurrentUser',$computer)
		$regkey='SOFTWARE\FRSI\DeltaV\CurrentVersion\PHV\SourceNodes'
		$key = $reg.OpenSubKey($regkey, $true)
		
		# Set EventNode
		$key.SetValue("EventNode", $EventNode)
		if ($key.GetValue("EventNode") -eq $EventNode){
			"EventNode = $EventNode" | Tee-Object -FilePath "SetDVSourceNodes.txt" -Append
		} else {
			"Could not set EventNode" | Tee-Object -FilePath "SetDVSourceNodes.txt" -Append
		}

		# Set HistorianNode
		$key.SetValue("HistorianNode", $HistorianNode)
		if ($key.GetValue("HistorianNode") -eq $HistorianNode){
			"HistorianNode = $HistorianNode" | Tee-Object -FilePath "SetDVSourceNodes.txt" -Append
		} else {
			"Could not set HistorianNode" | Tee-Object -FilePath "SetDVSourceNodes.txt" -Append
		}


		
	} else {
		"Could not connect to $computer" | Tee-Object -FilePath "SetDVSourceNodes.txt" -Append
	}


	"" | Tee-Object -FilePath "SetDVSourceNodes.txt" -Append
}


.\SetDVSourceNodes.txt