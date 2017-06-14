<#
.AUTHOR:
Robert Burke
EMAIL: robert.burke@reisystems.com 
.SYNOPSIS:
   <Script queries VMWare for a list of servers that fit our requirement,ie.. hsa-is*-utl*>
.DESCRIPTION:This script will query VMWare for the identified server type and then copy the IIS logs from that server to the destination
   
.PARAMETER: <paramName>
   <Description of script parameter>
.EXAMPLE:
   <An example of using the script>
#>
#Install VMWare powershell module
Add-PSSnapin VMware.VimAutomation.Core
#Establish connection with the VMWare server
Connect-VIServer -Server "vsphere.reisys.com" -User reisys\robert.burke -Password ###########
#Query VMWare for the servers we require
$vms = Get-VM -Name * | where name -Like "hsa-is*-utl*" | select $_.value
#############################
#Pulling the names from VMWare seemed to ad some wierd spaces which caused my loop to fail,
#after I added this split everything started working correctly
$vhost = $vms -split ' '
#############################
$myDate = (Get-date).AddDays(-1)
foreach($vm in $vhost){
#Get the folder contents and then select files older than number
$frompath = Get-ChildItem "\\$vm\Y$\Privateroot\logfiles\W3SVC\*.log" | where-object {$_.LastWriteTime.Date -gt (get-date).adddays(-180).Date}

#This splits the hostname after the last '-' and uses the last text to create a folder in the destination to represent each env
$foldername = $vm.Split('-')[-1]
#Takes share plus the foldername and copies the files to that directory
$toPath = "\\hrsafs.reisys.com\adminftp\IISLOGS\IISLOGS_Internal\$foldername"
#
IF (Test-Path $toPath) {
copy $frompath -Destination $toPath 
}
else 
{
mkdir $toPath
copy $frompath -Destination $toPath 

}
}