#https://microsoft.gointeract.io/interact/index?interaction=1461173234028-3884f8602eccbe259104553afa8415434b4581-05d1&accountId=microsoft&loadFrom=CDN&appkey=196de13c-e946-4531-98f6-2719ec8405ce&Language=English&name=pana&CountryCode=en-US&Click%20To%20Call%20Caller%20Id=+16265860337&startedFromSmsToken=e9dmQhQ&dnis=1&token=UEuUbt

$productKey = "PRODUCT KEY"
$workstation = "WORKSTATION NAME"

"" > installationID.txt

# Running the slmgr.vbs commands with cscript is what enables this script to read the output
cscript C:\Windows\System32\slmgr.vbs $workstation /ipk $productKey | out-null

# Parse the InstallationID from the output
$dtiOutput = cscript C:\Windows\System32\slmgr.vbs $workstation /dti
$arr = $dtiOutput -split ":"
$installationID = $arr[4].Trim()

# Split the InstallationID into 7-digit chunks
$($installationID -split '(.{7})') > installationID.txt

pause

$activationID = Get-Content "activationID.txt"
cscript C:\Windows\System32\slmgr.vbs $workstation /atp $activationID.Trim() | out-null
$dliOutput = cscript C:\Windows\System32\slmgr.vbs $workstation /dli
$arr = $dliOutput -split "Status"

$arr[8]