# This script returns a list of all DeltaV/Plant LAN NICs on every computer in WorkstationList.

$computers = gc "WorkstationList.txt"

if (Test-Path "Interfaces.txt") { Remove-Item "Interfaces.txt" }

foreach ($computer in $computers) {
	if (Test-Connection $computer -count 1 -quiet){
		$computer
		Add-Content "Interfaces.txt" $computer

	$interfaces = Get-WMIObject -class Win32_NetworkAdapter -computername $computer | Where {($_.NetConnectionID -ne $null) -and ($_.NetConnectionID -ne "Spare")} | Select-Object NetConnectionID,DeviceID

		ForEach ($interface in $interfaces) {
			$index = $interface.DeviceID
			$IP = (Get-WMIObject -class Win32_NetworkAdapterConfiguration -computername $computer -Filter Index=$index).IPAddress
			Write-Host $interface.NetConnectionID = $IP

			Add-Content ".\Interfaces.txt" -Value ($interface.NetConnectionID + " = " + $IP)
		}
	}
	else {
		"Could not connect to $computer"
		Add-Content "Interfaces.txt" "Could not connect to $computer"
	}

		""
		Add-Content "Interfaces.txt" ([Environment]::NewLine + [Environment]::NewLine)
}


.\Interfaces.txt