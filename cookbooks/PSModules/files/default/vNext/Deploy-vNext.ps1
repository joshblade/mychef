configuration DSCResource
{
    
  Node localhost
  {

     File xReleaseManagement
    {  
        Ensure = "Present"
        Type = "Directory"
        Recurse = $true
        SourcePath = join-path $applicationPath "xReleaseManagement"
        DestinationPath = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\xReleaseManagement"
    }
     File xWebAdministration
    {  
        Ensure = "Present"
        Type = "Directory"
        Recurse = $true
        SourcePath = join-path $applicationPath "xWebAdministration"
        DestinationPath = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\xWebAdministration"
    }
    File cAssemblyManager
    {  
        Ensure = "Present"
        Type = "Directory"
        Recurse = $true
        SourcePath = join-path $applicationPath "cAssemblyManager"
        DestinationPath = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\cAssemblyManager"
    }
  }
}



DSCResource -ConfigurationData $ConfigData -verbose 