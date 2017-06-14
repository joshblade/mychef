#Description: This script is the beginning of a push environment for DSC
$servers = "HSA-ERS-UAT6","HSA-EIS-UAT6","HSA-IS-UAT6","HSA-IS2-UAT6","HSA-DB-UAT6"
$resource1 = "\\hrsafs\ise\requiredDSCModules\*"
$resource2 = "\\hrsafs\ise\NTFSPermission"

$ISScript = "Y:\UAT\Script\uat-is-config.psm1"
$DBScript = "Y:\UAT\Script\UAT-DB.psm1"
$ERSScript = "Y:\UAT\Script\uat-ers-config.psm1"
$EISScript = "Y:\UAT\Script\uat-eis-config.psm1"
$SBXScript = "Y:\UAT\Script\UAT-SBX.psm1"

$OutputFolder = "Y:\UAT\ConfigOutput"
$envUAT = "Y:\UAT\Script\EnvUAT.psd1"
$resource = "Y:\UAT\Resource"

Remove-Module uat-is-config
Remove-Module uat-db
Remove-Module uat-ers-config
Remove-Module uat-eis-config
Remove-Module uat-sbx

Import-Module -Name $ISScript
Import-Module -Name $DBScript
Import-Module -Name $EISScript
Import-Module -Name $ERSScript
Import-Module -Name $SBXScript
remove-item "$OutputFolder\*.*"

UatISConfig -OutputPath $OutputFolder -ConfigurationData $envUAT
UatDBConfig -OutputPath $OutputFolder -ConfigurationData $envUAT
UatEISConfig -OutputPath $OutputFolder -ConfigurationData $envUAT
UatERSConfig -OutputPath $OutputFolder -ConfigurationData $envUAT
SBXALL -OutputPath $OutputFolder -ConfigurationData $envUAT



foreach($server in $servers){

$dest1 = "\\$server\c$\Program Files\WindowsPowerShell\Modules"
$dest2 = "\\$server\C$\Windows\System32\WindowsPowerShell\v1.0\Modules\PSDesiredStateConfiguration\DSCResources"
copy $resource1 $dest1
copy $resource2 $dest2

}
Start-DscConfiguration -ComputerName hsa-sbx-10 -Path $OutputFolder -Wait -Verbose -force
Start-DscConfiguration -ComputerName hsa-sbx-10 -UseExisting -wait -verbose



Remove-DscConfigurationDocument -CimSession hsa-sbx-10 -Stage Pending

Get-DscLocalConfigurationManager -CimSession hsa-sbx-10

Get-Service -ComputerName hsa-sbx-10 -Name "winmgmt" | Restart-Service -Force

Restart-Computer -ComputerName hsa-sbx-10 -Force 

isep "Y:\UAT\Script\EnvUAT.psd1"
