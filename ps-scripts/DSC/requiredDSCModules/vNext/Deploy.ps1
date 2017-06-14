configuration DSCResource
{
    
  Node localhost
  {
	$applicationPath = Split-Path $PSScriptRoot -Parent
     File xReleaseManagement
    {  
        Ensure = "Present"
        Type = "Directory"
        Recurse = $true
        SourcePath = join-path $applicationPath "xReleaseManagement"
        DestinationPath = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\xReleaseManagement"
        MatchSource = $true
    }
     File xWebAdministration
    {  
        Ensure = "Present"
        Type = "Directory"
        Recurse = $true
        SourcePath = join-path $applicationPath "xWebAdministration"
        DestinationPath = "C:\Program Files\WindowsPowerShell\Modules\xWebAdministration"
        MatchSource = $true
    }
    File cAssemblyManagerRemove
    {  
        Ensure = "Absent"
        Type = "Directory"
        Recurse = $true
        SourcePath = join-path $applicationPath "cAssemblyManager"
        DestinationPath = "C:\Program Files\WindowsPowerShell\Modules\cAssemblyManager"
		Force = $true
        MatchSource = $true
    }
    File cAssemblyManager
    {  
        Ensure = "Present"
        Type = "Directory"
        Recurse = $true
        SourcePath = join-path $applicationPath "cAssemblyManager"
        DestinationPath = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\cAssemblyManager"
        MatchSource = $true
    }
  }
}



DSCResource -ConfigurationData $ConfigData -OutputPath Output -verbose 