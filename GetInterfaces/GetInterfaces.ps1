# This script queries every computer in WorkstationList for the Name, IP, MAC, and Metric of each NIC.
# Please report any bugs or suggestions to Drew Hutchins (Drew.Hutchins@JohnHCarter.com)

$version = "v0.1 - 2021-08-09"

""
Write-Host "GetInterfaces $version" -ForegroundColor Green
""

$computers = gc "WorkstationList.txt"

# Remove existing log file
if (Test-Path "Interfaces.txt"){del "Interfaces.txt"}

foreach ($computer in $computers) {
	if (Test-Connection $computer -Count 1 -Quiet){
		# Connection successful
		$computer | Tee-Object -FilePath "Interfaces.txt" -Append

		$interfaces = Get-WMIObject -class Win32_NetworkAdapter -computername $computer | Where {$_.NetConnectionID -ne $null} | Select-Object InterfaceIndex

		foreach ($interface in $interfaces) {

			$Name = Get-WMIObject -class Win32_NetworkAdapter -computername $computer | Where InterfaceIndex -eq $interface.InterfaceIndex | Select NetConnectionID
			$IP = Get-WMIObject -class Win32_NetworkAdapterConfiguration -computername $computer | Where InterfaceIndex -eq $interface.InterfaceIndex | Select IPAddress
			$MAC = Get-WMIObject -class Win32_NetworkAdapterConfiguration -computername $computer | Where InterfaceIndex -eq $interface.InterfaceIndex | Select MACAddress
			$Metric= Get-WMIObject -class Win32_NetworkAdapterConfiguration -computername $computer | Where InterfaceIndex -eq $interface.InterfaceIndex | Select IPConnectionMetric
			
			if ($IP.IPAddress -eq $null) {
				$IP.IPAddress = "0.0.0.0"
			}
			if ($MAC.MACAddress -eq $null) {
				$MAC.MACAddress = "00:00:00:00:00:00"
			}
			if ($Metric.IPConnectionMetric -eq $null) {
				$Metric.IPConnectionMetric = "Auto"
			}
			
			$outString = $Name.NetConnectionID + "	" +  $IP.IPAddress + "	" + $MAC.MACAddress + "	" + $Metric.IPConnectionMetric
			$outString | Tee-Object -FilePath "Interfaces.txt" -Append

		}
	} else {
		# Connection unsuccessful
		"Could not connect to $computer" | Tee-Object -FilePath "Interfaces.txt" -Append
	}

		"" | Tee-Object -FilePath "Interfaces.txt" -Append
		"" | Tee-Object -FilePath "Interfaces.txt" -Append
}

.\Interfaces.txt