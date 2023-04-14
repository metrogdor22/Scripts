# Removes ampersands in a SysRegData XML file.
$folder = Read-Host -Prompt "Folder containing the XML"

try {
    $file = Get-ChildItem -Path $folder -Filter "*SysRegData*xml" -ErrorAction Stop | Select -First 1
} catch [System.Exception] {
    "Could not locate file."
    break
}

if ($file -ne $null){
    "Replacing & in $file..."
    
    (Get-Content "$folder\$file").replace("&","") | Set-Content "$folder\$file"

    "Done."
} else {
    "Could not locate file."
}