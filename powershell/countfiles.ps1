$nbrfiles = (Get-ChildItem "\\usdc1-cegweb-3\FTP\AX\fromAX" -filter "*.csv").Count
write-host "CEGID_PROCESSING ="$nbrfiles

$nbrfiles = (Get-ChildItem "\\usdc1-cegweb-3\FTP\AX\fromAX\error" -filter "*.csv").Count
write-host "CEGID_ERROR ="$nbrfiles
