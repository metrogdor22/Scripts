# This script queries every computer in WorkstationList for the service tag.
# Please report any bugs or suggestions to Drew Hutchins (Drew.Hutchins@JohnHCarter.com)

# Changelog
# v0.1 (2022-04-06) - Initial release

$version = "v0.1 - 2022-04-06"
$instructions = "Instructions: Populate WorkstationList.txt with target computers, then run the script."

""
Write-Host "GetServiceTag $version" -ForegroundColor Green
Write-Host $instructions -ForegroundColor Cyan
""

$computers = gc "WorkstationList.txt"

# Remove existing log file
if (Test-Path "ServiceTags.txt"){del "ServiceTags.txt"}

foreach ($computer in $computers) {

	if (Test-Connection $computer -Count 1 -Quiet){
		# Connection successful
		$computer | Tee-Object -FilePath "ServiceTags.txt" -Append
		
		# Get the SerialNumber object
		$serviceTag = Get-WmiObject -ComputerName $computer -Class Win32_Bios | Select SerialNumber

		# Get the actual SerialNumber (service tag) as a string
		$serviceTag = $serviceTag.SerialNumber

		$serviceTag | Tee-Object -FilePath "ServiceTags.txt" -Append

	} else {
		# Connection unsuccessful
		"Coult not connect to $computer" | Tee-Object -FilePath "ServiceTags.txt" -Append
	}

	"" | Tee-Object -FilePath "ServiceTags.txt" -Append
}

.\ServiceTags.txt