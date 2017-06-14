#Updated: 4-24-2017
########Start script
#region Login
$reiAzureLoginCreds = get-credential -Message 'Your.Name@reisystems.com and your reisystems password' -UserName robert.burke@reisystems.com
Login-AzureRmAccount -Credential $reiAzureLoginCreds -TenantId '31996441-7546-4120-826b-df0c3e239671'
$azureSubscription = Get-AzureRmSubscription -SubscriptionName "Microsoft Azure Enterprise" -TenantId '31996441-7546-4120-826b-df0c3e239671' | Select-AzureRmSubscription
#endregion
$server = Read-Host -Prompt 'Please enter the server name, ie.. REI-AZURE-SBX1'
#$storageInfo = Get-AzureStorageAccount -StorageAccountName 'reidevopsstorage'
$automationRG = 'rg-reiautomation'
$automationInfo = Get-AzureRmAutomationAccount -ResourceGroupName $automationRG -Name 'reiazureauto'
$automationAccountName = 'reiazureauto'
$automationLocation = $automationInfo.Location
#region Setup resource group
##########################New Resource Group##########################
#Create new resource group
$location = 'East US'
$myResourceGroup = "rg-devops"
$networkRG = 'rg-vnet'
#$testResourceGroup = Get-AzureRmResourceGroup -Name $myResourceGroup
#New-AzureRmResourceGroup -Name $myResourceGroup -Location $location -Force
#endregion
 
#region Setup storage
# Setup Storage
$myStorageAccountName = "reidevopsstorage"
$storagetype = 'Standard_LRS'
$storage = get-AzureRmStorageAccount -ResourceGroupName "$myResourceGroup" -StorageAccountName $myStorageAccountName -Verbose
#Create a v2 Storage Account on ARM
#New-AzureStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type $stotype$stoaccount = Get-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname;
#endregion
 
#region Create a virtual machine
#Create a VM
$AzureImage = Get-AzureRmVMImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Location $location
$vmsize = 'Standard_A2'
$vmname = $server
$vm = New-AzureRmVMConfig -VMName $vmname -VMSize $vmsize
# Add NIC to VM
$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id
$osDiskName = $vmname+'_osDisk'
$osDiskCaching = 'ReadWrite'
$osDiskVhdUri = "https://$myStorageAccountName.blob.core.windows.net/vhds/"+$vmname+"_os.vhd"
$appDiskVhdUri = "https://$myStorageAccountName.blob.core.windows.net/vhds/"+$vmname+"_app.vhd"
# Setup OS & Image
$user = "devopsadmin"
$password = 'Password123$'
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword)
$vm = Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName $vmname -Credential $cred
$vm = Set-AzureRmVMSourceImage -VM $vm -PublisherName $AzureImage.PublisherName -Offer $AzureImage.Offer -Skus $AzureImage.Skus -Version $AzureImage.Version
$vm = Set-AzureRmVMOSDisk -VM $vm -VhdUri $osDiskVhdUri -name $osDiskName -CreateOption fromImage -Caching $osDiskCaching
New-AzureRmVM  -ResourceGroupName $myResourceGroup -Location $location -VM $vm
 
#endregion
 
#region Setup networking
# Setup Networking
#$subnet = New-AzureRmVirtualNetworkSubnetConfig -Name ('subnet' + $myResourceGroup) -AddressPrefix "10.0.0.0/24"
$vnet = get-AzureRmVirtualNetwork -Name vnet -ResourceGroupName $networkRG
$subnetInfo = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet
#$vnet = Get-AzureRmVirtualNetwork -Name ('vnet' + $rgname) -ResourceGroupName $rgname
$subnetId = $subnetInfo.Id
$ipAddressRange = $subnetInfo.AddressPrefix
#$vnet.Subnets[0].Id
$pip = New-AzureRmPublicIpAddress -ResourceGroupName $myResourceGroup -Name "vip1" -Location $location -AllocationMethod Dynamic -DomainNameLabel $vmname.ToLower()
$frontendIP = New-AzureRmLoadBalancerFrontendIpConfig -Name LB-Frontend -PublicIpAddress $pip
$nic = New-AzureRmNetworkInterface -Force -Name ('nic-' + $vmname) -ResourceGroupName $myResourceGroup -Location $location -SubnetId $subnetId -PublicIpAddressId $pip.Id
$nic = Get-AzureRmNetworkInterface -Name ('nic-' + $vmname) -ResourceGroupName $myResourceGroup
#endregion
 
#region Firewall Rules
#Firewall
$inboundRDPNATRule1= New-AzureRmLoadBalancerInboundNatRuleConfig -Name RDP1 -FrontendIpConfiguration $frontendIP -Protocol TCP -FrontendPort 3441 -BackendPort 3389
$inboundRDPNATRule2= New-AzureRmLoadBalancerInboundNatRuleConfig -Name RDP2 -FrontendIpConfiguration $frontendIP -Protocol TCP -FrontendPort 3442 -BackendPort 3389
$inboundPSRemotingNatRule1 = New-AzureRmLoadBalancerInboundNatRuleConfig -Name PSRemotingHTTP -FrontendIpConfiguration $frontendIP -Protocol Tcp -FrontendPort 5985 -BackendPort 5985
$inboundPSRemotingNatRule2 = New-AzureRmLoadBalancerInboundNatRuleConfig -Name PSRemotingHTTPS -FrontendIpConfiguration $frontendIP -Protocol Tcp -FrontendPort 5986 -BackendPort 5986
#endregion