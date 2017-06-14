Configuration azuretestconfig2{

    <#
    Import-DscResource -ModuleName "cIISBaseConfig" 
    Import-DscResource -ModuleName "cWebAdministration" 
    Import-DscResource -ModuleName "xWebAdministration" 
    Import-DscResource -ModuleName "xSMBShare"
    Import-DscResource -ModuleName "xTimeZone"
    Import-DscResource -ModuleName "xRemoteDesktopAdmin"
    Import-DscResource -ModuleName "xSQLServer"
    Import-DscResource -ModuleName "cSQLServer"
    Import-DscResource -ModuleName "PSDesiredStateConfiguration"
    Import-DscResource -ModuleName "xPSDesiredStateConfiguration"
    #>
    
     Node "localhost" {

     file rburke
       {
            DestinationPath = 'c:\rburke'
            Ensure = 'Present'
            type = 'directory'
            
       }

      WindowsFeature telnetclient 
       {
            Name = 'Telnet-Client'
            Ensure = 'Present'
       }


       }
       }
 # azuredsctest.ps1\azuretestconfig2
