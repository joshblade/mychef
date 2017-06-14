#region #######################Login#######################
$reiAzureLoginCreds = get-credential -Message 'Your.Name@reisystems.com and your reisystems password' -UserName robert.burke@reisystems.com
Login-AzureRmAccount -Credential $reiAzureLoginCreds -TenantId '31996441-7546-4120-826b-df0c3e239671'
#endregion


#region #######################Parameters#######################
$environment = Read-Host -Prompt 'Please enter the type of environment, SBX, UTL..'
$server = Read-Host -Prompt 'Please enter the server name, ie.. REI-AZURE-SBX1'
#region Hostname validation
IF ($environment -eq 'sbx'){
$serverFile = 'D:\envTypes\sbxenvs.txt'
Out-File $serverFile $server -Append
}
IF ((Get-Content $serverFile | Where-Object { $_.Contains("$server") }) -eq $true) {
$lastLine = get-content $serverFile | select -Last '1'
#$nexthostname = $lastLine. 
Write-Host "$server hostname is already taken, the next available name would be $lastline + 1"
}
ELSEIF ($environment -eq 'utl'){
$serverFile = 'D:\envTypes\utlenvs.txt'
}
IF ((Get-Content $serverFile | Where-Object { $_.Contains("$server") }) -eq $true) {
$lastLine = get-content $serverFile | select -Last '1'
#$nexthostname = $lastLine. 
Write-Host "$server hostname is already taken, the next available name would be $lastline + 1"

}
#endregion
#region #######################Constants#######################
$location = 'eastus'
$myStorageAccountName = 'reidevopsstorage'
$networkRG = 'rg-vnet'
$myResourceGroup = 'rg-' + $server
$user = "devopsadmin"
$password = 'Password123$'
#2016 requires 12 chars: ReiGem#GemsUser1
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword)
#endregion
#region New resource Group
##########################New Resource Group##########################
#Create new resource group
New-AzureRmResourceGroup -Name $myResourceGroup -Location $location -Force
#endregion

#Automation information
$automationResourceGroupName = "rg-reiautomation" 
$AutomationAccountName = "reiazureauto"
#endregion

#region #######################Server Properties#######################
 
$AzureImage = Get-AzureRmVMImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Version '4.0.20170111'  -Location $location 
$vmsize = 'Standard_A1'
$osDiskVhdUri = "https://$myStorageAccountName.blob.core.windows.net/vhds/"+$server+"_os.vhd"
$appDiskVhdUri = "https://$myStorageAccountName.blob.core.windows.net/vhds/"+$server+"_app.vhd"
$osDiskName = $server+'_osDisk'
#$utlOSDisk = Add-AzureRmVMDataDisk -VM "$server" -Name "$server+'_osDisk'" -VhdUri "https://$myStorageAccountName.blob.core.windows.net/vhds/"+$server+"_os.vhd" -DiskSizeInGB '80'
#$utlAppDisk = Add-AzureRmVMDataDisk -VM "$server" -Name "$server+'_appDisk'" -VhdUri "https://$myStorageAccountName.blob.core.windows.net/vhds/"+$server+"_app.vhd" -DiskSizeInGB '100'

#endregion


#region #######################Network, Firewall#######################
$subnetId = '/subscriptions/765843cc-b249-4a49-bf05-ac76e27dab94/resourceGroups/rg-vnet/providers/Microsoft.Network/virtualNetworks/vnet/subnets/subnet-devops'
$pip = New-AzureRmPublicIpAddress -Name ('vip-' + $server) -ResourceGroupName $myResourceGroup -Location $location -AllocationMethod Dynamic -DomainNameLabel $server.ToLower()
$frontendIP = New-AzureRmLoadBalancerFrontendIpConfig -Name ($server + 'LB-Frontend') -PublicIpAddress $pip
$nic = New-AzureRmNetworkInterface -Force -Name ('nic-' + $server) -ResourceGroupName $myResourceGroup -Location $location -SubnetId $subnetId -PublicIpAddressId $pip.Id
#$nic = Get-AzureRmNetworkInterface -Name ('nic' + $vmname) -ResourceGroupName $myResourceGroup
$fqdn = (Get-AzureRmPublicIpAddress -ResourceGroupName $myResourceGroup).DnsSettings.Fqdn | Select-String -SimpleMatch $server


#######################Combine NIC, Network, Firewall, VM and put together a self contained system #######################
#Firewall rules
$inboundRDPNATRule1= New-AzureRmLoadBalancerInboundNatRuleConfig -Name RDP1 -FrontendIpConfiguration $frontendIP -Protocol TCP -FrontendPort 3389 -BackendPort 3389
$inboundPSRemotingNatRule1 = New-AzureRmLoadBalancerInboundNatRuleConfig -Name PSRemotingHTTP -FrontendIpConfiguration $frontendIP -Protocol Tcp -FrontendPort 5985 -BackendPort 5985
$inboundPSRemotingNatRule2 = New-AzureRmLoadBalancerInboundNatRuleConfig -Name PSRemotingHTTPS -FrontendIpConfiguration $frontendIP -Protocol Tcp -FrontendPort 5986 -BackendPort 5986
$inboundHTTPNatRule1 = New-AzureRmLoadBalancerInboundNatRuleConfig -Name HTTP -FrontendIpConfiguration $frontendIP -Protocol Tcp -FrontendPort 80 -BackendPort 80
$inboundHTTPSNatRule2 = New-AzureRmLoadBalancerInboundNatRuleConfig -Name HTTPS -FrontendIpConfiguration $frontendIP -Protocol Tcp -FrontendPort 443 -BackendPort 443
#endregion
#VM Config build
$vmconfig = New-AzureRmVMConfig -VMName $server -VMSize $vmsize | `
Set-AzureRmVMOperatingSystem -ComputerName $server  -Windows  -Credential $cred| `
Set-AzureRmVMSourceImage -PublisherName $AzureImage.PublisherName -Offer $AzureImage.Offer -Skus $AzureImage.Skus -Version latest | `
Set-AzureRmVMOSDisk -VhdUri $osDiskVhdUri -name ($server+'_osDisk') -CreateOption FromImage -Caching ReadWrite | `
Add-AzureRmVMNetworkInterface -Id $nic.Id 
#-VM  -Windows -ClientRb 'D:\Documents\Chef-Test\client.rb' -ValidationPem 'D:\Documents\Chef-Test\REIEHB-validator.pem'-ChefServerUrl $ChefServerUrl -ValidationClientName $ChefValidationClientName | Update-AzureVM
New-AzureRmVM -ResourceGroupName $myResourceGroup -Location $location -VM $vmconfig
#endregion

#region Extension configuration
#Set-AzureVMChefExtension -Windows -AutoUpdateChefClient -ValidationPem 'D:\Documents\Chef-Test\REIEHB-validator.pem'-ChefServerUrl $ChefServerUrl -ValidationClientName $ChefValidationClientName | Update-AzureVM
Publish-AzureRmVMDscConfiguration -ConfigurationPath D:\Documents\Scripts\PowerShell\DSC\iisInstall.ps1 -ResourceGroupName $myResourceGroup -StorageAccountName $myStorageAccountName -force
#Set the VM to run the DSC configuration
Set-AzureRmVmDscExtension -Version 2.21 -ResourceGroupName $myResourceGroup -VMName $server -ArchiveStorageAccountName $myStorageAccountName -ArchiveBlobName iisInstall.ps1.zip -AutoUpdate:$true -ConfigurationName "IISInstall"
#endregion

#region IIS install validation test
$fqdn = (Get-AzureRmPublicIpAddress -ResourceGroupName $myResourceGroup).DnsSettings.Fqdn | Select-String -SimpleMatch $server

 Invoke-Command -scriptblock {
    $ie = New-Object -ComObject InternetExplorer.Application
    $ie.Visible = $true
    $ie.Navigate("http://$fqdn")
}
#endregion