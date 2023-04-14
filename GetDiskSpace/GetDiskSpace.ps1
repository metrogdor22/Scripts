# This script queries every computer in WorkstationList for the free space on all disks.
# Please report any bugs or suggestions to Drew Hutchins (Drew.Hutchins@JohnHCarter.com)

$version = "v0.1 - 2021-08-09"

""
Write-Host "GetDiskSpace $version" -ForegroundColor Green
""

$computers = gc "WorkstationList.txt"

# Remove existing log file
if (Test-Path "GetDiskSpace.txt"){del "GetDiskSpace.txt"}

foreach ($computer in $computers) {

	if (Test-Connection $computer -Count 1 -Quiet){
		# Connection successful
		$computer | Tee-Object -FilePath "GetDiskSpace.txt" -Append

		$disks = Get-WmiObject win32_logicaldisk -ComputerName $computer
		foreach ($disk in $disks){
			# If the VolumeName is not blank
			if (![string]::IsNullOrEmpty($disk.VolumeName)){
				$outString = $disk.VolumeName + " " + $($([Math]::Round($disk.FreeSpace / 1GB)).ToString())
				$outString | Tee-Object -FilePath "GetDiskSpace.txt" -Append
			}
		}

	} else {
		# Connection unsuccessful
		"Coult not connect to $computer" | Tee-Object -FilePath "GetDiskSpace.txt" -Append
	}

	"" | Tee-Object -FilePath "GetDiskSpace.txt" -Append
}

.\GetDiskSpace.txt