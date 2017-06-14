Get-AzurePublishSettingsFile
Import-AzurePublishSettingsFile
$reiAzureLoginCreds = get-credential -Message 'Your.Name@reisystems.com and your reisystems password' -UserName robert.burke@reisystems.com
Login-AzureRmAccount -Credential $reiAzureLoginCreds 
Publish-AzureServiceProject -StorageAccountName $reiEastUSStorageACCName -ServiceName reitest