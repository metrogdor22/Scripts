# This script pulls the historized tag names out of PHIST.SCR.

New-Item -Force "PHIST-Dump.txt"

$file = "D:\DeltaV\DVDATA\download\PHIST.SCR"

foreach ($line in (gc $file | Where {$_ -match 'PATH='})){
    $line = $line.split("=")[1]
    $line = $line.substring(1, $line.length - 2)
    $line | Tee-Object -Append "PHIST-Dump.txt"
}