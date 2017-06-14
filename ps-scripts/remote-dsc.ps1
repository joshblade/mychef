#This script is dependent on the creation of a MOF file, such as softinstall.ps1
#I have placed the contents of that file here for use as an example
<#
#################################READ THIS#################################
execute this portion of the script as a seperate script, it will output a MOF file in the directory defined
 
              Configuration SoftInstall{
    Import-DscResource -ModuleName "PSDesiredStateConfiguration"
    Import-DscResource -ModuleName "xPSDesiredStateConfiguration"
              
              
              node "Localhost"{
           package SQLSysClrTypes
           {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs\ise\Prerequisites\SQL2012-SysCLRTypes\SQLSysClrTypes.msi"
            Name = "Microsoft System CLR Types for SQL Server 2012 (x64)"
            ProductId = "F1949145-EB64-4DE7-9D81-E6D27937146C"
           } 
 
           package ReportViewer2012
           {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs\ise\Prerequisites\ReportViewer2012\ReportViewer.msi"
            Name = "Microsoft Report Viewer 2012 Runtime"
            ProductId = "C58378BC-0B7B-474E-855C-9D02E5E75D71"
           }
 
              }
              }
SoftInstall -OutputPath 'D:\rburke\minor'
#Start-DscConfiguration -Path D:\rburke\minor -Wait -Force -Verbose
 
#>
 
Add-Pssnapin -name vmware*
Get-Module -Name vmware.* -ListAvailable | Import-Module
Connect-VIServer -Server "vsphere.reisys.com" -User reisys\robert.burke -Password Deeana87!
#Amer.reisystems.com\vmware.readonly
$vms = Get-VM -Name * | where name -Like "hsa-ers-*" | select $_.value
$vhost = $vms -split ' '
 
foreach($vm in $vhost){
mkdir "\\$vm\y$\rburke\minor\" -ErrorAction SilentlyContinue
copy 'G:\rburke\localhost.mof' -Destination "\\$vm\y$\rburke\minor\"
Invoke-Command -computername $vm -scriptblock {Start-DscConfiguration -Path "y:\rburke\minor\" -Wait -Force -Verbose} -ErrorAction SilentlyContinue
 
}