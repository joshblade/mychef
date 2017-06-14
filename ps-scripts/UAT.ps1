$ISScript = "Y:\UAT\Script\uat-is-config.psm1"
$DBScript = "Y:\UAT\Script\UAT-DB.psm1"
$SBXScript = "Y:\UAT\Script\UAT-SBX.psm1"

$OutputFolder = "Y:\UAT\ConfigOutput"
$envUAT = "Y:\UAT\Script\EnvUAT.psd1"
$resource = "Y:\UAT\Resource"

Remove-Module uat-is-config
Remove-Module uat-db
Remove-Module uat-sbx
Import-Module -Name $ISScript
Import-Module -Name $DBScript
Import-Module -Name $SBXScript
remove-item "$OutputFolder\*.*"

UatISConfig -OutputPath $OutputFolder -ConfigurationData $envUAT
UatDBConfig -OutputPath $OutputFolder -ConfigurationData $envUAT
SBXALL -OutputPath $OutputFolder -ConfigurationData $envUAT

Copy-Item -Path "$resource\*" -Recurse -Destination '\\hsa-sbx-10\c$\Program Files\WindowsPowerShell\Modules' -Force
Copy-Item -Path "$Resource\NTFSPermission" -Recurse -Destination '\\hsa-sbx-10\C$\Windows\System32\WindowsPowerShell\v1.0\Modules\PSDesiredStateConfiguration\DSCResources\'

Start-DscConfiguration -ComputerName localhost -Path $OutputFolder -Wait -Verbose -force
Start-DscConfiguration -ComputerName hsa-sbx-10 -UseExisting -wait -verbose



Remove-DscConfigurationDocument -CimSession hsa-sbx-10 -Stage Pending

Get-DscLocalConfigurationManager -CimSession hsa-sbx-10

Get-Service -ComputerName hsa-sbx-10 -Name "winmgmt" | Restart-Service -Force

Restart-Computer -ComputerName hsa-sbx-10 -Force 


