$filename = $args[0]
$filenameprefix = $args[1]
$srcpath = $args[2] + "\"
$destpath = $args[3] + "\"
$src= $srcpath + $filename
$dest=$destpath + $filenameprefix + "_" +( Get-Date -Format dd_MM_yyyy_hh_m_ss ) + ".csv"
$src
$dest
Copy-Item -Path $src -Destination $dest -Force -ErrorAction Stop
