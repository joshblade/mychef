#Start of checksum resource that can be used in conjunction with package resource to validate software
$someString = "Hello World!"
#$somestring = Get-content -path path | where description -like 'softwarename'
#internally generated checksums are contained in csv(encrypted?) with SoftwareName, Description, CheckSum
$md5 = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$utf8 = new-object -TypeName System.Text.UTF8Encoding
$hash = [System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($someString)))

$someFilePath = '\\hrsafs.reisys.com\ise\Prerequisites\AccessDatabaseEngine_x64.exe'
$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($someFilePath)))
$lowerHash = $hash.Replace('-', '')
$lowerHash.ToLower()