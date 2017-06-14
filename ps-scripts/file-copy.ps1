#Description: Simple script to copy a file from one place to another.
$servers = "HSA-ERS-UAT6","HSA-EIS-UAT6","HSA-IS-UAT6","HSA-IS2-UAT6","HSA-DB-UAT6"
$resource1 = "\\hrsafs\ise\requiredDSCModules\*"
$resource2 = "\\hrsafs\ise\NTFSPermission"

foreach($server in $servers){

$dest1 = "\\$server\c$\Program Files\WindowsPowerShell\Modules"
$dest2 = "\\$server\C$\Windows\System32\WindowsPowerShell\v1.0\Modules\PSDesiredStateConfiguration\DSCResources"
copy $resource1 $dest1 -Force
copy $resource2 $dest2 -Force

}