New-AzureVM -
New-AzureVMConfig


$subScription = Set-AzureSubscription -SubscriptionName '[your subscription name]' -SubscriptionId '[your subscription id]'

Get-AzureVMImage -

Get-AzureVMChefExtension 

#Start
Add-AzureAccount
New-AzureStorageAccount –StorageAccountName 'rei150east' -Location 'East US' 
Get-AzureSubscription
Set-AzureSubscription -SubscriptionId '765843cc-b249-4a49-bf05-ac76e27dab94' -SubscriptionName 'Microsoft Azure Enterprise' -CurrentStorageAccountName 'rei150east'

Get-AzureVMImage | Select-Object -Property ImageFamily, ImageName, PublishedDate | Where-Object { $_.ImageFamily -like 'Windows Server*' } | Sort-Object -Property PublishedDate -Descending | Select-Object -First 1 | Format-List
$image = 'ad072bd3082149369c449ba5832401ae__Windows-Server-RDSHwO365P-on-Windows-Server-2012-R2-20170301-2103'
$vmname = 'REI-EHB-rweb1'
$vmsize = 'Small'
$vm1 = New-AzureVMConfig -ImageName $image -Name $vmname -InstanceSize $vmsize
$cred = Get-Credential -Message 'Type the local administrator account username and password:'
$vm1 | Add-AzureProvisioningConfig -Windows -AdminUsername $cred.GetNetworkCredential().Username -Password $cred.GetNetworkCredential().Password
$svcname='rei150eastservice'
New-AzureService -ServiceName $svcname -Label 'reirbPowerShellTest' -Location 'East US'
New-AzureVM  –ServiceName $svcname -VMs $vm1 -WaitForBoot
#Finish, this creates a VM from my desktop to MS Azure Cloud


Copy-Item D:\Documents\Scripts\PowerShell\azure-testing.ps1 \\rei150eastservice.cloudapp.net\C$

get-AzureProvisioningConfig 