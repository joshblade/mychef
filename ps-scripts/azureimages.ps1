$reiAzureLoginCreds = get-credential -Message 'Your.Name@reisystems.com and your reisystems password' -UserName robert.burke@reisystems.com
$azurecreds = Login-AzureRmAccount -Credential $reiAzureLoginCreds 
Switch-AzureMode AzureResourceManager
$location = 'eastus'
$publisher = 'microsoftwindowsserver'
$offerName = 'WindowsServer'
$sku = '2016-Datacenter'
Get-AzureRMVMImagePublisher -Location $location | Select PublisherName
Get-AzureRMVMImageOffer -Location $location -Publisher $publisher | Select Offer
Get-AzureRMVMImageSku -Location $location -Publisher $publisher -Offer $offerName | Select Skus