#Title: SBX Azure system Deployment
#Description: Powershell script to deploy a new Azure based SBX server that will connect to Azure DB as a Service
#region Login
$reiAzureLoginCreds = get-credential -Message 'Your.Name@reisystems.com and your reisystems password' -UserName robert.burke@reisystems.com
Login-AzureRmAccount -Credential $reiAzureLoginCreds -TenantId '31996441-7546-4120-826b-df0c3e239671'
#endregion
#region ################Variable Declaration################
$server = 'rei-azure-sbx24'
#Storage in East US
$reiEastUSStorage = Get-AzureRmStorageAccount -ResourceGroupName rg-devops -Name reidevopsstorage
$reiEastUSStorageID = $reiEastUSStorage.Id
#Storage in East US 2
$reiEastUS2Storage = Get-AzureRmStorageAccount -ResourceGroupName rg-reieast2 -Name reieast2storage
$reiEastUS2StorageID = $reiEastUS2Storage.Id
$reiEastUS2StorageName = $reiEastUS2Storage.StorageAccountName

$location = 'EastUS2'
$myStorageAccountName = $reiEastUS2StorageName
$networkInfo = Get-AzureRmVirtualNetwork -Name east2vnet -ResourceGroupName rg-reieast2
$networkID = $networkInfo.Id
$networkRG = $networkInfo.ResourceGroupName
$east2vnetSubnetInfo = $networkInfo.Subnets
$east2vnetSubnet0ID = $east2vnetSubnetInfo[0].id
$myResourceGroup = 'rg-reieast2'
$user = "devopsadmin"
$password = 'Password123$'
#2016 requires 12 chars: ReiGem#GemsUser1
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword)

#$configurationName = "Configuration-1"
#$credName = "Name of credential asset in Azure Automation"
#$nodeName = "localhost"
#endregion 
#region Firewall definitions
$fwRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow RDP" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix 65.242.96.0/23 `
    -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389

$fwRuleHTTP = New-AzureRmNetworkSecurityRuleConfig -Name web-rule -Description "Allow HTTP" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 101 -SourceAddressPrefix 65.242.96.0/23 `
    -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80

$fwRulePowerShellHTTP = New-AzureRmNetworkSecurityRuleConfig -Name web-rule -Description "Allow Powershell HTTP" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 102 -SourceAddressPrefix 65.242.96.0/23 `
    -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 5985

$fwRulePowerShellHTTPS = New-AzureRmNetworkSecurityRuleConfig -Name web-rule -Description "Allow Powershell HTTPS" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 103 -SourceAddressPrefix 65.242.96.0/23 `
    -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 5986

$fwRuleSMB1 = New-AzureRmNetworkSecurityRuleConfig -Name web-rule -Description "Allow SMB" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 103 -SourceAddressPrefix 65.242.96.0/23 `
    -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 5986
#endregion

#region Security Group
$secGroup = New-AzureRmNetworkSecurityGroup -Name ('SecGroup-SBX-' + $server) -ResourceGroupName $myResourceGroup -Location $location -SecurityRules $fwRuleRDP, $fwRuleHTTP, $fwRulePowerShellHTTP, $fwRulePowerShellHTTPS, $fwRuleSMB1

#endregion

#region Automation information
$automationRG = 'rg-reiautomation'
$automationInfo = Get-AzureRmAutomationAccount -ResourceGroupName $automationRG
$automationAccountName = $automationInfo.AutomationAccountName
$automationLocation = $automationInfo.Location
#endregion



#region Define VM parameters
$AzureImage = Get-AzureRmVMImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Version '4.0.20170111'  -Location $location 
$vmsize = 'Standard_A2'
$osDiskVhdUri1 = "https://$reiEastUS2StorageName.blob.core.windows.net/vhds/"+$server+"_os.vhd"
$appDiskVhdUri1 = "https://$reiEastUS2StorageName.blob.core.windows.net/vhds/"+$server+"_app.vhd"
$osDiskName = $server+'_osDisk'
#$utlOSDisk = Add-AzureRmVMDataDisk -VM "$server" -Name "$server+'_osDisk'" -VhdUri "https://$myStorageAccountName.blob.core.windows.net/vhds/"+$server+"_os.vhd" -DiskSizeInGB '80'
#$utlAppDisk = Add-AzureRmVMDataDisk -VM "$server" -Name "$server+'_appDisk'" -VhdUri "https://$myStorageAccountName.blob.core.windows.net/vhds/"+$server+"_app.vhd" -DiskSizeInGB '100'
#endregion

#region Define network
#$nic = New-AzureRmNetworkInterface -Force -Name ('nic-' + $server) -ResourceGroupName $myResourceGroup -Location $location -SubnetId $subnetId
$pip = New-AzureRmPublicIpAddress -Name ('vip-' + $server) -ResourceGroupName $myResourceGroup -Location $location -AllocationMethod Dynamic -DomainNameLabel $server.ToLower()
$frontendIP = New-AzureRmLoadBalancerFrontendIpConfig -Name ($server + 'LB-Frontend') -PublicIpAddress $pip
$nic = New-AzureRmNetworkInterface -Force -Name ('nic-' + $server) -ResourceGroupName $myResourceGroup -Location $location -SubnetId $east2vnetSubnet0ID -PublicIpAddressId $pip.Id
#$nic = Get-AzureRmNetworkInterface -Name ('nic' + $vmname) -ResourceGroupName $myResourceGroup
#endregion


#region Load Balancer Rules

$inboundRDPNATRule1= New-AzureRmLoadBalancerInboundNatRuleConfig -Name RDP1 -FrontendIpConfiguration $frontendIP -Protocol TCP -FrontendPort 3389 -BackendPort 3389
$inboundPSRemotingNatRule1 = New-AzureRmLoadBalancerInboundNatRuleConfig -Name PSRemotingHTTP -FrontendIpConfiguration $frontendIP -Protocol Tcp -FrontendPort 5985 -BackendPort 5985
$inboundPSRemotingNatRule2 = New-AzureRmLoadBalancerInboundNatRuleConfig -Name PSRemotingHTTPS -FrontendIpConfiguration $frontendIP -Protocol Tcp -FrontendPort 5986 -BackendPort 5986
$inboundHTTPNatRule2 = New-AzureRmLoadBalancerInboundNatRuleConfig -Name HTTP -FrontendIpConfiguration $frontendIP -Protocol Tcp -FrontendPort 80 -BackendPort 80
$inboundHTTPSNatRule2 = New-AzureRmLoadBalancerInboundNatRuleConfig -Name HTTPS -FrontendIpConfiguration $frontendIP -Protocol Tcp -FrontendPort 443 -BackendPort 443
#endregion

#region Create configuration for VM
$vmconfig = New-AzureRmVMConfig -VMName $server -VMSize $vmsize | `
Set-AzureRmVMOperatingSystem -ComputerName $server  -Windows  -Credential $cred| `
Set-AzureRmVMSourceImage -PublisherName $AzureImage.PublisherName -Offer $AzureImage.Offer -Skus $AzureImage.Skus -Version latest | `
Set-AzureRmVMOSDisk -VhdUri $osDiskVhdUri1 -name ($server+'_osDisk') -CreateOption FromImage -Caching ReadWrite | `
Add-AzureRmVMNetworkInterface -Id $nic.Id
#$vmconfig = Add-AzureRmVMDataDisk -VM $vmconfig.Name -VhdUri $appDiskVhdUri -Name ("$server+'_appDisk'") -Caching ReadWrite -DiskSizeInGB '100'
#endregion

#region Create VM
New-AzureRmVM -ResourceGroupName $myResourceGroup -Location $location -VM $vmconfig -Verbose
#endregion
$fqdn = (Get-AzureRmPublicIpAddress -ResourceGroupName $myResourceGroup).DnsSettings.Fqdn | Select-String -SimpleMatch $server
# Import Configuration
$sourcePath = "D:\Documents\Scripts\PowerShell\DSC\IISInstall2.ps1"
Import-AzureRmAutomationDscConfiguration -SourcePath $sourcePath  `
   -ResourceGroupName $automationRG -AutomationAccountName $AutomationAccountName -Published -Force

$ConfigurationData = @{ 
    AllNodes = @(
        @{
            NodeName = 'localhost'
            PSDscAllowPlainTextPassword = $true
            RebootNodeIfNeeded = $true
            DebugMode = "All"
        }
    )
}

$Parameters = @{
    #"storageAccountName" = $reiEastUS2StorageName
    "nodeName" = 'localhost'
    "devops" = $cred
}
$reiEastUS2Storage = Get-AzureRmStorageAccount -ResourceGroupName rg-reieast2 -Name reieast2storage
$reiEastUS2StorageID = $reiEastUS2Storage.Id
$reiEastUS2StorageName = $reiEastUS2Storage.StorageAccountName
Start-AzureRmAutomationDscCompilationJob -ResourceGroupName $automationRG -AutomationAccountName $automationAccountName -ConfigurationName iisinstall2 -Parameters $Parameters -ConfigurationData $ConfigurationData 
Register-AzureRmAutomationDscNode -AutomationAccountName $AutomationAccountName -AzureVMName $server -ResourceGroupName $automationRG -NodeConfigurationName "iisinstall2.localhost"

#region Extension configuration
#Publish-AzureRmVMDscConfiguration -ConfigurationPath D:\Documents\Scripts\PowerShell\DSC\IISInstall2.ps1\iisinstall -ResourceGroupName $myResourceGroup -StorageAccountName $reiEastUS2StorageName -ContainerName dscconfigs -force -Verbose
#Set the VM to run the DSC configuration
#Set-AzureRmVmDscExtension -Version 2.21 -ResourceGroupName $myResourceGroup -VMName $server -ArchiveStorageAccountName $reiEastUS2StorageName -ArchiveBlobName iisInstall2.ps1.zip -AutoUpdate:$true -ConfigurationName "IISInstall" -Verbose
#restart-azurermvm -Name $server -ResourceGroupName $myResourceGroup 
#Set-AzureRmVmDscExtension -Version 2.21 -ResourceGroupName $myResourceGroup -VMName $server -ArchiveStorageAccountName $reiEastUS2StorageName -ArchiveBlobName iisInstall.ps1.zip -AutoUpdate:$true -ConfigurationName "IISInstall" -Verbose

#Get-AzureRmVMDscExtensionStatus -ResourceGroupName rg-devops -VMName rei-azure-sbx2 -Verbose
#Register-AzureRmAutomationDscNode -AzureVMName $server -AzureVMResourceGroup $myResourceGroup -AzureVMLocation $location `
#-NodeConfigurationName 'iisinstall.localhost' -ConfigurationMode 'ApplyOnly' -ConfigurationModeFrequencyMins 15 `
#-RefreshFrequencyMins 30 -RebootNodeIfNeeded $true -ActionAfterReboot 'ContinueConfiguration' `
#-AllowModuleOverwrite $false -ResourceGroupName $automationRG -AutomationAccountName $automationAccountName -Verbose
#endregion

#region Display IIS default webpage on new server
Invoke-Command -scriptblock {
    $ie = New-Object -ComObject InternetExplorer.Application
    $ie.Visible = $true
    $ie.Navigate("http://$fqdn")
}
#endregion