Add-Pssnapin -name vmware*
Get-Module -Name vmware.* -ListAvailable | Import-Module
Connect-VIServer -Server "vsphere.reisys.com" -User reisys\robert.burke -Password JesusIsLord1
#Amer.reisystems.com\vmware.readonly
$vms = Get-VM -Name * | where {($_.name -Like "hsa-db-*") -or ($_.name -Like "hsa-txn-*") -or ($_.name -Like "hsa-ods-*") -or ($_.name -Like "hsa-sbx-*")} | select $_.value
#$vms = 'hsa-sbx-01','hsa-sbx-03','hsa-sbx-12','hsa-sbx-13'
$servers = $vms -split ' '
foreach($server in $servers) {
$driveinfo = Get-WmiObject Win32_LogicalDisk -ComputerName $server -Filter 'DriveType = 3'
foreach($drive in $driveinfo) {

$drivename = $drive.deviceID 
$disksize = ($drive.size /1024/1024/1024)
$freespace = ($drive.freespace /1024/1024/1024)
$disksizegb = [math]::Round($disksize)
$freespacegb = [math]::Round($freespace)
$present = @"
Servername, Drive, DiskSize, Freespace
$env:COMPUTERNAME, $drivename, $disksizegb, $freespacegb
"@
$present | out-file 'C:\rburke\drivespace.csv' -Append ascii


}
}