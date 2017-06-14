$reiAzureLoginCreds = get-credential -Message 'Your.Name@reisystems.com and your reisystems password' -UserName robert.burke@reisystems.com
Login-AzureRmAccount -Credential $reiAzureLoginCreds -TenantId '31996441-7546-4120-826b-df0c3e239671'
$storageAccountName = 'reieast2storage'
$reiEastUSStorage = Get-AzureRmStorageAccount -ResourceGroupName rg-reieast2 -Name $storageAccountName
$StorageAccountKey = '45hXlxP2FcEK1HCTz9Pjx4RlU7VTVUH4AZ8mCNb8nxaZ13sSORG4qN9uODKzCRV4vCeVO7XEshr6Bv5eii2Ncw=='
$reiEastUSStorageID = $reiEastUSStorage.Id
$reiEastUSStorageContext =  $reiEastUSStorage.Context
Invoke-Command -ScriptBlock {net use u: \\reieast2storage.file.core.windows.net\hrsa /u:AZURE\reieast2storage 45hXlxP2FcEK1HCTz9Pjx4RlU7VTVUH4AZ8mCNb8nxaZ13sSORG4qN9uODKzCRV4vCeVO7XEshr6Bv5eii2Ncw==}
