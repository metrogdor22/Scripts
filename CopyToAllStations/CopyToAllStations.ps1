# This script copies the contents of the source directory into the destination directory of computers listed in WorkstationList.txt.
# Please report any bugs or suggestions to Drew Hutchins (Drew.Hutchins@JohnHCarter.com)

$version = "v0.1 - 2021-08-09"
$instructions = "Instructions: Populate WorkstationList.txt with target computers, and place desired files in source directory (FilesToBeCopied by default). Enter the source and destination directories when prompted. Text in [brackets] are default values, which will be used if no value is specified. Typical usage is copying the contents of the FilesToBeCopied folder into the D:\ControlWorx folder on all target machines. Program output is saved to CopyToAllStations.txt"

""
Write-Host "CopyToAllStations $version" -ForegroundColor Green
Write-Host $instructions -ForegroundColor Cyan
""

$computers = gc "WorkstationList.txt"

# Remove existing log file
if (Test-Path "CopyToAllStations.txt"){del "CopyToAllStations.txt"}

# Prompt for source directory. Default is "FilesToBeCopied\"
$source = Read-Host -Prompt "Source Directory [FilesToBeCopied\]"
if ([string]::IsNullOrWhiteSpace($source)){
	$source = "FilesToBeCopied\"
}

# Prompt for destination directory. Default is "D$\ControlWorx"
$destination = Read-Host -Prompt "Destination Directory [D$\ControlWorx]"
if ([string]::IsNullOrWhiteSpace($destination)){
	$destination = "D$\ControlWorx"
}

""

foreach ($computer in $computers) {
	if (Test-Connection $computer -Count 1 -Quiet){
		# Connection is good
		"$computer" | Tee-Object -FilePath "CopyToAllStations.txt" -Append

		if (Test-Path -Path \\$computer\$destination){
			# Destination exists
			"Copy started at $(Get-Date -Format "HH:mm:ss")" | Tee-Object -FilePath "CopyToAllStations.txt" -Append
			robocopy $source \\$computer\$destination /E | Out-Null
			"Copy finished at $(Get-Date -Format "HH:mm:ss")" | Tee-Object -FilePath "CopyToAllStations.txt" -Append
			
		} else {
			# Destination does not exist
			"Destination does not exist." | Tee-Object -FilePath "CopyToAllStations.txt" -Append
		}
		"" | Tee-Object -FilePath "CopyToAllStations.txt" -Append

	} else {
		# Connection is not good
		"Could not connect to $computer" | Tee-Object -FilePath "CopyToAllStations.txt" -Append
		"" | Tee-Object -FilePath "CopyToAllStations.txt" -Append
	}
}

.\CopyToAllStations.txt