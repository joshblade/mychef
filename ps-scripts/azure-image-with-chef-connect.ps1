#Title: SBX Azure system Deployment
#Description: Powershell script to deploy a new Azure based SBX server that will connect to Azure DB as a Service
#Date: Monday, May 29, 2017 10:48:43 PM
#region Login
$reiAzureLoginCreds = get-credential -Message 'Your.Name@reisystems.com and your reisystems password' -UserName robert.burke@reisystems.com
Login-AzureRmAccount -Credential $reiAzureLoginCreds 
#endregion
#region ################Variable Declaration################
$server = 'rei-azure-ehb30'
$devOpsResourceGroup = 'rg-devops'
$devopsEastStorage = 'reidevopsstorage'
$location = 'EastUS'
$user = "devopsadmin"
$password = 'Password123$'
#2016 requires 12 chars: ReiGem#GemsUser1
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword)
$EastUSVnetName = 'vnet'
$EastUSVnetRGName = 'rg-vnet'
#####Storage
$reiEastUSStorage = Get-AzureRmStorageAccount -ResourceGroupName $devOpsResourceGroup -Name $devopsEastStorage 
$reiEastUSStorageID = $reiEastUSStorage.Id
$reiEastUSStorageACCName = $reiEastUSStorage.StorageAccountName
#####Network
$networkInfo = Get-AzureRmVirtualNetwork -Name $EastUSVnetName -ResourceGroupName $EastUSVnetRGName
$networkName = $networkInfo.Name
$networkNameSubnetID = $networkInfo.Subnets[0].Id
#endregion


<#
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
#>
#region Security Group
#$secGroup = New-AzureRmNetworkSecurityGroup -Name ('SecGroup-' + $server) -ResourceGroupName $EastUSVnetRGName -Location $location -SecurityRules $fwRuleRDP, $fwRuleHTTP, $fwRulePowerShellHTTP, $fwRulePowerShellHTTPS, $fwRuleSMB1

#endregion

#region Define VM parameters
$AzureImage = Get-AzureRmVMImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2012-R2-Datacenter"  -Location $location 
$vmsize = 'Standard_A2'
$osDiskVhdUri1 = "https://$reiEastUSStorageACCName.blob.core.windows.net/vhds/"+$server+"_os.vhd"
$appDiskVhdUri1 = "https://$reiEastUSStorageACCName.blob.core.windows.net/vhds/"+$server+"_app.vhd"
$osDiskName = $server+'_osDisk'
#$utlOSDisk = Add-AzureRmVMDataDisk -VM "$server" -Name "$server+'_osDisk'" -VhdUri "https://$myStorageAccountName.blob.core.windows.net/vhds/"+$server+"_os.vhd" -DiskSizeInGB '80'
#$utlAppDisk = Add-AzureRmVMDataDisk -VM "$server" -Name "$server+'_appDisk'" -VhdUri "https://$myStorageAccountName.blob.core.windows.net/vhds/"+$server+"_app.vhd" -DiskSizeInGB '100'
#endregion

#region Define network
#$nic = New-AzureRmNetworkInterface -Force -Name ('nic-' + $server) -ResourceGroupName $myResourceGroup -Location $location -SubnetId $subnetId
$pip = New-AzureRmPublicIpAddress -Name ('vip-' + $server) -ResourceGroupName $devOpsResourceGroup -Location $location -AllocationMethod Dynamic -DomainNameLabel $server.ToLower()
$frontendIP = New-AzureRmLoadBalancerFrontendIpConfig -Name ($server + 'LB-Frontend') -PublicIpAddress $pip
$nic = New-AzureRmNetworkInterface -Force -Name ('nic-' + $server) -ResourceGroupName $devOpsResourceGroup -Location $location -SubnetId $networkNameSubnetID -PublicIpAddressId $pip.Id
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
Set-AzureRmVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Version latest | `
Set-AzureRmVMOSDisk -VhdUri $osDiskVhdUri1 -name ($server+'_osDisk') -CreateOption FromImage -Caching ReadWrite | `
Add-AzureRmVMNetworkInterface -Id $nic.Id
#$vmconfig = Add-AzureRmVMDataDisk -VM $vmconfig.Name -VhdUri $appDiskVhdUri -Name ("$server+'_appDisk'") -Caching ReadWrite -DiskSizeInGB '100'
#endregion

#region Create VM

New-AzureRmVM -ResourceGroupName $devOpsResourceGroup -Location $location -VM $vmconfig -Verbose
#endregion


#region Logs into the unbuntu server via ssh and executes a bootstrap against the newly defined machine
#########Works
#Start-Sleep -Seconds 60
#Chef server IP address 13.82.187.74
$chefSession = New-SSHSession -ComputerName 13.82.187.74 -Credential $cred -Force
$cmds = 'cd /home/devopsadmin/chef-starter/.chef', "knife bootstrap windows winrm $server -x \devopsadmin -P Password123$ --node-name $server --run-list ''recipe[windows]','recipe[PSModules]','recipe[W2K12R2_IIS]','recipe[testehb]','recipe[common_installs]''"
$chefSetup = Invoke-SSHCommand -SSHSession $chefSession -Command ($cmds -join ';') -Verbose
$chefSetup.ExitStatus
#endregion
#########

#region Display IIS default webpage on new server
$fqdn = (Get-AzureRmPublicIpAddress -ResourceGroupName $devOpsResourceGroup).DnsSettings.Fqdn | Select-String -SimpleMatch $server
Invoke-Command -scriptblock {
    $ie = New-Object -ComObject InternetExplorer.Application
    $ie.Visible = $true
    $ie.Navigate("http://$fqdn")
}
#endregion

