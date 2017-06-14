#Description: This script is used to upload tasks to the TFS build process
#Execute this as a function and it will make it easier to pass the parms in
Function TFS-TaskInstall {
param(
   [Parameter(Mandatory=$true)][string]$TaskPath,
   [Parameter(Mandatory=$true)][string]$TfsUrl,
   [PSCredential]$Credential = (Get-Credential -username 'amer\robert.burke' -message 'Enter domain user id'),
   [switch]$Overwrite = $false
)
 
# Load task definition from the JSON file
$taskDefinition = (Get-Content $taskPath\task.json) -join "`n" | ConvertFrom-Json
$taskFolder = Get-Item $TaskPath
 
# Zip the task content
Write-Output "Zipping task content"
$taskZip = ("{0}\..\{1}.zip" -f $taskFolder, $taskDefinition.id)
if (Test-Path $taskZip) { Remove-Item $taskZip }
 
Add-Type -AssemblyName "System.IO.Compression.FileSystem"
[IO.Compression.ZipFile]::CreateFromDirectory($taskFolder, $taskZip)
 
# Prepare to upload the task
Write-Output "Uploading task content"
$headers = @{ "Accept" = "application/json; api-version=2.0-preview"; "X-TFS-FedAuthRedirect" = "Suppress" }
$taskZipItem = Get-Item $taskZip
$headers.Add("Content-Range", "bytes 0-$($taskZipItem.Length - 1)/$($taskZipItem.Length)")
$url = ("{0}/_apis/distributedtask/tasks/{1}" -f $TfsUrl, $taskDefinition.id)
if ($Overwrite) {
   $url += "?overwrite=true"
}
 
# Actually upload it
Invoke-RestMethod -Uri $url -Credential $Credential -Headers $headers -ContentType application/octet-stream -Method Put -InFile $taskZipItem
}
 
#TFS-TaskInstall -TaskPath '\\hrsafs.reisys.com\ISE\vsts-tasks\Tasks\chef' -TfsUrl http://tfs-app-01.reisys.com:8080/tfs/
 
 
TFS-TaskInstall -TaskPath 'Y:\TFS_Tasks\vNextRMTokenConfiguration\0.1.3' -TfsUrl 'http://reitfs.amer.reisystems.com:8080/tfs/'