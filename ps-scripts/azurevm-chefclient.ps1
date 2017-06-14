$VMName = "demochefsbx01"
$CSName = "demochefsbx01"
$StorageName = "reidevopsstorage"
$Username = "administrator"
$Password = "#GemsUser1"
$location = 'East US'
$myResourceGroup = "reiRbResourceGroup"
$AzureImage = Get-AzureRmVMImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Version '4.0.20170111'  -Location $location

$Key = "C:\chef-repo\.chef\demoorg01-validator.pem"
$Server = "https://manage.chef.io/organizations/demoorg01"
$ClientName = "demoorg01-validator"

$reiAzureLoginCreds = get-credential -Message 'Your.Name@reisystems.com and your reisystems password'
Login-AzureRmAccount -Credential $reiAzureLoginCreds -TenantId '31996441-7546-4120-826b-df0c3e239671'

$VM  =  New-AzureVMConfig -Name $VMName `
            -InstanceSize ExtraSmall `
            -ImageName $azureImage | `
        Add-AzureProvisioningConfig -Windows `
            -AdminUsername $Username `
            -Password $Password | `
        Add-AzureDataDisk -CreateNew `
            -DiskSizeInGB 200 `
            -DiskLabel "datadisk1" `
            -LUN 0 | `
        Add-AzureEndpoint -Name "HTTP" `
            -Protocol TCP `
            -LocalPort 80 `
            -PublicPort 80 | `
        Add-AzureEndpoint -Name "PowerShell" `
            -Protocol TCP `
            -LocalPort 5985 `
            -PublicPort 5985
New-AzureVM -ServiceName $CSName -VMs $VM

Get-AzureVM -ServiceName $CSName `
            -Name $VMName | `
        Set-AzureVMChefExtension `
            -Windows `
            -AutoUpdateChefClient `
            -ValidationPem $Key `
            -ChefServerUrl $Server `
            -ValidationClientName $ClientName | `
        Update-AzureVM