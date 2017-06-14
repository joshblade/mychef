#Automate Package Deployment
[Reflection.Assembly]::LoadWithPartialName("Microsoft.SQLServer.ManagedDTS") | out-null
#add-type -Path "C:\Program Files (x86)\Microsoft SQL Server\110\SDK\Assemblies\Microsoft.SQLServer.ManagedDTS.dll"

# This method will create a folder on SQL Server for SSIS package deployment
Function Create-FolderOnSqlServer
{
    param
    (
        [string]$Server,
        [string]$Folder
    )
    
    $folderDelimter = "\"
    
    try
    {
        # if they supply multiple-level of folders, might need to create whole structure
        # while recursion would be a more elegant solution, my mind is not there
        if ($Folder -ne $folderDelimter)
        {
            $folderList = $Folder.Split($folderDelimter)
        }
        else
        {
            $folderList = [array]$Folder
        }
        
        $app = New-Object Microsoft.SqlServer.Dts.Runtime.Application
        $parentFolder = "\"
        $serverUserName = "sa"
        $serverPassword = "#GemsUser1"
#ehbsqlsa
#"M0r3me@!rei"
        foreach($subFolder in $folderList)
        {
            # test for existing folders
            Write-Debug ([System.string]::Format("parentFolder:{0} folderDelimter:{1} subFolder:{2}", $parentFolder, $folderDelimter, $subFolder))
            $testFolder = $parentFolder + $folderDelimter + $subFolder
            if (!$app.FolderExistsOnSqlServer($testFolder, $Server, $serverUserName, $serverPassword))
            {
                Write-Debug ([System.string]::Format("Folder {0} does not exist on server, creating", $testFolder))
                $app.CreateFolderOnSqlServer($parentFolder, $subFolder, $Server, $null, $null);
                Write-Host ([System.string]::Format("Created folder {0} on server {1}", $testFolder, $Server))
            }
            else
            {
                Write-Debug "Folder exists on server, doing nothing"
            }
            
            $parentFolder += $folderDelimter + $subFolder
        }
    }
    catch 
    {
        Write-Error ([string]::Format("Failed to create folder {0} on server {1}", $folder, $server))
        Write-Error $_ | fl * -Force
    }
}

# Deploy a package to a folder
Function Copy-Package
{
    param
    (
        [string]$Server,
        [string]$PathToDtsx,
        [string]$ProjectFolder = "\\"
    )
    
    $events = $null
    $serverUserName = "sa"
    $serverPassword = "#GemsUser1"
#ehbsqlsa
#"M0r3me@!rei"
    
    Write-Debug "--------------------------Copy-Package----------------------"
    Write-Debug ([string]::Format("File: {0}", $PathToDtsx))
    Write-Debug ([string]::Format("Server: {0}", $Server))
    Write-Debug ([string]::Format("Folder: {0}", $ProjectFolder))

    if ($ProjectFolder -ne "\\")
    {
        Create-FolderOnSqlServer $Server $ProjectFolder
    }

    Write-Debug ([string]::Format("Attempting to deploy {0} to server {1}", $PathToDtsx, $Server))
    
    try
    {
        $app = New-Object Microsoft.SqlServer.Dts.Runtime.Application
        $package = $app.LoadPackage($PathToDtsx, $null)
        
        $destinationName = "\\"
        if ($ProjectFolder -ne "\\")
        {
            $destinationName = $destinationName + $ProjectFolder + "__"
        }

        # \\folder\\packageName
        $destinationName = $destinationName + $package.Name
        Write-Debug ([string]::Format("Saving as {0}", $destinationName))
        $app.SaveToSqlServerAs($package, $events, $destinationName, $Server, $serverUserName, $serverPassword);
        Write-Host ([string]::Format("Deployed {0}", $destinationName))
    }
    catch 
    {
        Write-Error ([string]::Format("Failed to deploy {0} to server {1}", $PathToDtsx, $Server))
        Write-Error $_ | fl * -Force
    }
}

# This method cracks open an SSIS manifest file and deploys all packages to
# the indicated server
Function Deploy-Manifest
{
    param
    (
        [string]$Server,
        [string]$Instance,
        [string]$ManifestFile,
        [string]$ProjectFolder = "\\"
    )
    # This deploy script assumes all packages are in the same folder as the 
    # manifest

    $baseFolder = [System.IO.Path]::GetDirectoryName($ManifestFile)

    $DeployDestination=$Server
    if ($Instance -ne "")
        {
            $DeployDestination=$DeployDestination+"\"+$Instance
        }

    [xml] $list = Get-Content $ManifestFile

    Write-Debug "--------------------------Deploy-Manifest----------------------"
    Write-Debug ([string]::Format("    Server {0}", $DeployDestination))
    Write-Debug ([string]::Format("    ProjectFolder {0}", $ProjectFolder))
    foreach($package in $list.DTSDeploymentManifest.Package)
    {
        #$basePackage = [System.IO.Path]::GetFileNameWithoutExtension($package)
        
        # This might need to be a relative path
        $fullyQualifiedPackage = [System.IO.Path]::Combine($baseFolder, $package)
        Write-Debug ([string]::Format("    Package {0}", $fullyQualifiedPackage))
    
        Copy-Package $DeployDestination $fullyQualifiedPackage $ProjectFolder
    }

    foreach($Config in $list.DTSDeploymentManifest.ConfigurationFile)
    {
        #$baseConfig = [System.IO.Path]::GetFileNameWithoutExtension($Config)
        
        # This might need to be a relative path
        $fullyQualifiedConfig = [System.IO.Path]::Combine($baseFolder, $Config)
        Write-Debug ([string]::Format("    Package {0}", $fullyQualifiedConfig))
    
        Copy-Configuration $Server $fullyQualifiedConfig
    }
    
}

# this script is reponsible for enumerating subfolder
# for each manifest it finds, it will invoke the deploy method on it
Function Walk-SubFolder
{
    param
    (
        [string]$RootFolder,
        [string]$DeployServer,
        [string]$ServerInstance=""
    )
    
    $searchPattern = "*.ssisdeploymentmanifest"    
    
    foreach($manifestFile in [System.IO.Directory]::GetFiles($RootFolder, $searchPattern, [System.IO.SearchOption]::AllDirectories))
    {
        [xml] $list = Get-Content $manifestFile
        # hard coding the root folder DBServer
        #$deployFolder = ([string]::Format("Default\{0}", $list.DTSDeploymentManifest.GeneratedFromProjectName))
        #Write-Host ([string]::Format("Deploy Folder {0}", $deployFolder))
        Write-Host ([string]::Format("Deploying manifest file {0}", $manifestFile))
        Deploy-Manifest $DeployServer $ServerInstance $manifestFile #$deployFolder
    }
}

Function Copy-Configuration
{
    param
    (
        [string]$DeployServer,
        [string]$SourceConfigFile
    )

    $SourceConfigFolder=[System.IO.Path]::GetDirectoryName($SourceConfigFile)
    $ConfigFile=[System.IO.Path]::GetFileName($SourceConfigFile)
    $TargetBasePath = "\\"+$DeployServer+"\y$\"
    $TargetRelPath=$SourceConfigFolder.Substring($SourceConfigFolder.IndexOf("SSIS Packages"))
    $TargetConfigFolder =$TargetBasePath+$TargetRelPath
    $TargetConfigFolder =$TargetConfigFolder.Replace("bin\Deployment","Config\") 

    Write-Host ([string]::Format("Deployed Config {0}", $TargetConfigFolder+$ConfigFile))
    #Write-Host ([string]::Format("Deployed Config {0}", $tempFolder))

    if (!(Test-Path -path $TargetConfigFolder)) {New-Item $TargetConfigFolder -Type Directory}
    Copy-Item $SourceConfigFile $TargetConfigFolder
}
<#
        [string]$RootFolder,
        [string]$DeployServer,
        [string]$ServerInstance=""
        #>
        #Pass root folder and Deployserver into walk-folder
        #Instance is required if there are multiple instances
#Walk-SubFolder -RootFolder "y:\SSIS Packages" -DeployServer "hsa-sbx-dev" -ServerInstance "ods"
