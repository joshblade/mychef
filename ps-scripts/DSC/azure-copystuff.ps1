$reiAzureLoginCreds = get-credential -Message 'Your.Name@reisystems.com and your reisystems password' -UserName robert.burke@reisystems.com
Login-AzureRmAccount -Credential $reiAzureLoginCreds -TenantId '31996441-7546-4120-826b-df0c3e239671'

$reiEastUSStorage = Get-AzureRmStorageAccount -ResourceGroupName rg-devops -Name reidevopsstorage
$reiEastUSStorageID = $reiEastUSStorage.Id
$reiEastUSStorageContext =  $reiEastUSStorage.Context
$reiEastUSStorage
function global:Copy-FromAzureStorage {


   $files = get-azurestorageblob -container ehbeps -Context $reiEastUSStorageContext
    foreach($file in $files){
    New-Item -ItemType directory -Force -Path \\rei-azure-sbx44.eastus2.cloudapp.azure.com\c$\eheps
        get-azurestorageblobcontent -Container ehbeps -Blob $file.name -Destination \\rei-azure-sbx44.eastus2.cloudapp.azure.com\c$\eheps -Context $reiEastUSStorageContext
    }
    }