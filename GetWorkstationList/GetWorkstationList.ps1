# This script uses the DT.SCR file to generate a list of DeltaV servers and workstations.
# Please report any bugs or suggestions to Drew Hutchins (Drew.Hutchins@JohnHCarter.com)

$version = "v0.1 - 2021-08-09"

""
Write-Host "GetWorkstationList $version" -ForegroundColor Green
""

$file = "D:\DeltaV\DVData\download\DT.SCR"

# Remove existing log file
if (Test-Path "WorkstationList.txt"){del "WorkstationList.txt"}

# Effectively Ctrl+F with trimming
foreach ($line in (gc $file | Where-Object {$_ -match 'TYPE=WS'})){
	$line = $line.split(" ")[2]
	$line = $line.substring(5,$line.length-6)
	$line | Tee-Object -FilePath "WorkstationList.txt" -Append
}

.\WorkstationList.txt