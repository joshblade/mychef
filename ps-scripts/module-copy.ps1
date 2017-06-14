#Description: Copies the required DSC and RM modules to the required directories

$compinfo = Get-WmiObject -Class Win32_ComputerSystem -ComputerName 'localhost' 
$domain = $compinfo.Domain          

IF($domain -eq 'reisys.com'){$SourceShare = '\\hrsafs.reisys.com\ISE\requiredDSCModules'}
ELSEIF($domain -eq 'amer.reisystems.com'){$SourceShare = '\\hrsafs.reisys.com\ISE\requiredDSCModules'}
ELSEIF($domain -eq 'hrsa.gov') {$SourceShare = "\\ehb-fs1\ISE\Prerequisites\requiredDSCModules"}
ELSEIF($domain -eq 'oitnet.local') {$SourceShare = "\\ehb-perf-p1\ISE\Prerequisites\requiredDSCModules"}

#$servers = 'hsa-eis-perf4','hsa-is-perf4','hsa-ers-uat','hsa-is2-perf4'
$servers = 'HSA-ERS-UAT6.amer.reisystems.com'
#get-content 'y:\rburke\serverlist.txt'
#'ehb-perf-p1'
foreach($server in $servers){
<#
These 2 need to be in C:\Windows\System32\WindowsPowerShell\v1.0\Modules\
cAssemblyManager
xReleaseManagement

This one need to be in C:\Program Files\WindowsPowerShell\Modules\
xWebAdministration
#>
#$server Destination server to copy TO
#$sourceShare source of software to be copied

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