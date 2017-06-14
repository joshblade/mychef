Add-Pssnapin -name vmware*
Get-Module -Name vmware.* -ListAvailable | Import-Module
Connect-VIServer -Server "vsphere.reisys.com" -User reisys\robert.burke -Password JesusIsLord1
#Amer.reisystems.com\vmware.readonly
$vms = Get-VM -Name * | where {($_.name -Like "hsa-*is*-perf*") -or ($_.name -Like "hsa-ers-perf*") -or ($_.name -Like "hsa-*is*-uat*") -or ($_.name -Like "hsa-ers-uat*")}  | select $_.value
#{($_.name -Like "hsa-*is*-utl*") -or ($_.name -Like "hsa-ers-utl*") -or ($_.name -Like "hsa-*is*-perf*") -or ($_.name -Like "hsa-ers-perf*") -or ($_.name -Like "hsa-*is*-uat*") -or ($_.name -Like "hsa-ers-uat*")}  | select $_.value



$vhost = $vms -split ' '
$compinfo = Get-WmiObject -Class Win32_ComputerSystem -ComputerName 'localhost' | select Name, Domain
$domain = $compinfo.Domain          

IF($domain -eq 'reisys.com'){$SourceShare = '\\hrsafs.reisys.com\ISE\requiredDSCModules'}
ELSEIF($domain -eq 'amer.reisystems.com'){$SourceShare = '\\hrsafs.reisys.com\ISE\requiredDSCModules'}
ELSEIF($domain -eq 'hrsa.gov') {$SourceShare = "\\ehb-fs1\ISE\Prerequisites\requiredDSCModules"}
ELSEIF($domain -eq 'oitnet.local') {$SourceShare = "\\ehb-perf-p1\ISE\Prerequisites\requiredDSCModules"}

foreach($server in $vhost) {
Copy-Item "$SourceShare\cAssemblyManager" -Container -Recurse -Destination "\\$server\C$\Windows\System32\WindowsPowerShell\v1.0\Modules\" -Force -ErrorAction SilentlyContinue 
Copy-Item "$SourceShare\xReleaseManagement" -Container -Recurse -Destination "\\$server\c$\Windows\System32\WindowsPowerShell\v1.0\Modules\" -Force
Copy-Item "$SourceShare\xWebAdministration" -Container -Recurse -Destination "\\$server\C$\Program Files\WindowsPowerShell\Modules\" -Force
Copy-Item "$SourceShare\cSQLServer" -Container -Recurse -Destination "\\$server\C$\Program Files\WindowsPowerShell\Modules\" -Force
Copy-Item "$SourceShare\cWebAdministration" -Container -Recurse -Destination "\\$server\C$\Program Files\WindowsPowerShell\Modules\" -Force
Copy-Item "$SourceShare\NTFSPermission" -Container -Recurse -Destination "\\$server\C$\Windows\System32\WindowsPowerShell\v1.0\Modules\PSDesiredStateConfiguration\DSCResources" -Force
Copy-Item "$SourceShare\PackageManagement" -Container -Recurse -Destination "\\$server\C$\Program Files\WindowsPowerShell\Modules\" -Force
Copy-Item "$SourceShare\PowerShellGet" -Container -Recurse -Destination "\\$server\C$\Program Files\WindowsPowerShell\Modules\" -Force
Copy-Item "$SourceShare\vNext" -Container -Recurse -Destination "\\$server\C$\Program Files\WindowsPowerShell\Modules\" -Force
Copy-Item "$SourceShare\xPSDesiredStateConfiguration" -Container -Recurse -Destination "\\$server\C$\Program Files\WindowsPowerShell\Modules\" -Force
Copy-Item "$SourceShare\xPSNTFS" -Container -Recurse -Destination "\\$server\C$\Program Files\WindowsPowerShell\Modules\" -Force
Copy-Item "$SourceShare\xRemoteDesktopAdmin" -Container -Recurse -Destination "\\$server\C$\Program Files\WindowsPowerShell\Modules\" -Force
Copy-Item "$SourceShare\xSmbShare" -Container -Recurse -Destination "\\$server\C$\Program Files\WindowsPowerShell\Modules\" -Force
Copy-Item "$SourceShare\xSQLServer" -Container -Recurse -Destination "\\$server\C$\Program Files\WindowsPowerShell\Modules\" -Force
Copy-Item "$SourceShare\xTimeZone" -Container -Recurse -Destination "\\$server\C$\Program Files\WindowsPowerShell\Modules\" -Force
Copy-Item "$SourceShare\cIISBaseConfig" -Container -Recurse -Destination "\\$server\C$\Program Files\WindowsPowerShell\Modules\" -Force
}