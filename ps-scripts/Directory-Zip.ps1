#Filename: Directory-Zip.ps1
#Description: This script takes the source directory and zips each folder in that directory and outputs with the foldername plus the zip
$sourcedir = 'Y:\vsts-tasks-master\'
$destinationDir = 'Y:\tasks\'
$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
 
Add-Type -Assembly "System.IO.Compression.FileSystem"
Add-Type -AssemblyName "System.IO.Compression"
 
$a = ls -Directory $sourcedir
 
foreach($b in $a){
[System.IO.Compression.ZipFile]::CreateFromDirectory($b.FullName, $destinationdir+"\\"+$b.Name+'.zip')
}
#+"\\"+$zipfilename, $compressionLevel, $false