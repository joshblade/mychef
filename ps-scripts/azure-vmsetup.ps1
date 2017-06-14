#Description: This script is for use on the new Azure Portal(Work login), not the classic portal.
#(1) Login to your Azure subscription
$reiAzureLoginCreds = get-credential -Message 'Your.Name@reisystems.com and your reisystems password'
Login-AzureRmAccount -Credential $reiAzureLoginCreds -TenantId '31996441-7546-4120-826b-df0c3e239671'
#Add-AzureAccount -Credential $reiAzureLoginCreds -Tenant '31996441-7546-4120-826b-df0c3e239671'

# You can also use a specific Tenant if you would like a faster log in experience
# Login-AzureRmAccount -TenantId xxxx

# To view all subscriptions for your account
#Get-AzureRmSubscription

# To select a default subscription for your current session.
# This is useful when you have multiple subscriptions.
#(2) Create or select a subscription
Get-AzureRmSubscription -SubscriptionName "Microsoft Azure Enterprise" -TenantId '31996441-7546-4120-826b-df0c3e239671' | Select-AzureRmSubscription

# View your current Azure PowerShell session context
# This session state is only applicable to the current session and will not affect other sessions
Get-AzureRmContext

##########################New Resource Group##########################
#Create new resource group
$location = 'East US'
$myResourceGroup = "reiRbResourceGroup"
New-AzureRmResourceGroup -Name $myResourceGroup -Location $location -Force



##########################New Storage Account##########################
#Test for unique name of storage account and NO uppercase letters
#All storage account names must use lower case lettersabd numbers
$myStorageAccountName = "reirbstorage"
Get-AzureRmStorageAccountNameAvailability $myStorageAccountName

# Set the default subscription
$defaultSubscription = 'Microsoft Azure Enterprise'
Select-AzureRmSubscription -TenantId '31996441-7546-4120-826b-df0c3e239671' 

New-AzureRmStorageAccount -ResourceGroupName "$myResourceGroup" -SkuName Standard_LRS -StorageAccountName $myStorageAccountName -Location $location -Tag RBStorageTest


# View your current Azure PowerShell session context
# Note: the CurrentStorageAccount is now set in your session context
Get-AzureRmContext
# To list all of the blobs in all of your containers in all of your accounts
Get-AzureRmStorageAccount | Get-AzureStorageContainer | Get-AzureStorageBlob

##########################New Virtual Network##########################
#(4)Virtual Network creation
$reiRbSubNet = New-AzureRmVirtualNetwork -Name 'reiRbSubnet' -ResourceGroupName "$myResourceGroup" -AddressPrefix 10.0.0.0/24 -Location $location 
Get-AzureRmVirtualNetwork -Name 'reiRbSubnet' -ResourceGroupName "$myResourceGroup"
##########################New Public IP##########################
$reiRbPublicIP1 = New-AzureRmPublicIpAddress -Name 'reiRbPublicIP1' -ResourceGroupName "$myResourceGroup" -Location $location
Get-AzureRmPublicIpAddress -Name reiRbPublicIP1 -ResourceGroupName "$myResourceGroup" 
$reiRbNIC1 = New-AzureRmNetworkInterface -Name 'reiRbNIC1' -ResourceGroupName "$myResourceGroup" -Location $location  -PublicIpAddressId (Get-AzureRmPublicIpAddress -Name reiRbPublicIP1 -ResourceGroupName "$myResourceGroup").Id -SubnetId (Get-AzureRmPublicIpAddress -Name reiRbPublicIP1 -ResourceGroupName "$myResourceGroup").Id

#-SubnetId (Get-AzureRmVirtualNetworkSubnetConfig -Name "$reiRbSubnet" -VirtualNetwork "$reiRbSubnet").Id