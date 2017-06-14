#Install VMWare powershell module
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer -Server "vsphere.reisys.com" -User reisys\robert.burke -Password Temp_123
$vms = Get-VM -Name * | where name -Like "hsa-is*-utl*" | select $_.value
$vhost = $vms -split ' '
$myDate = (Get-date).AddDays(-1)
foreach($vm in $vhost){
$frompath = Get-ChildItem "\\$vm\Y$\Privateroot\logfiles\W3SVC\*.log" | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-3)}


$foldername = $vm.Split('-')[-1]

$toPath = "\\hrsafs.reisys.com\adminftp\IISLOGS\IISLOGS_Internal\$foldername"
#Down to here works perfectly
IF (Test-Path $toPath) {
copy $frompath -Destination $toPath 
}
else 
{
mkdir $toPath
copy $frompath -Destination $toPath 
#| where ($_.CreationTime -gt ($(Get-Date).AddDays(-1)))
}
}
