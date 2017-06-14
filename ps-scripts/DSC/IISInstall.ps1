<#
$domainUserName = "robert.burke@reisystems.com" 
$domainPassword = "" 
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $domainUserName , $domainPassword
$storageCredential = $Credential
$user = "devopsadmin"
$password = 'Password123$'
#>
#https://reidevopsstorage.file.core.windows.net/powershellmodules/cAssemblyManager
configuration IISInstall 
{ 
    
    Import-DscResource -ModuleName "cIISBaseConfig"
    Import-DscResource -ModuleName "cWebAdministration" 
    Import-DscResource -ModuleName "xWebAdministration" 
    Import-DscResource -ModuleName "xSMBShare"
    Import-DscResource -ModuleName "xSQLServer"
    Import-DscResource -ModuleName "cSQLServer"
    Import-DscResource -ModuleName "PSDesiredStateConfiguration"
    Import-DscResource -ModuleName "xPSDesiredStateConfiguration"
    Import-DscResource -ModuleName @{modulename="Azure.Storage";moduleversion="2.6.0"}
    Import-DscResource -ModuleName "xPendingReboot"
    Import-DscResource -ModuleName "cazurestorage"
    
##############Credentials
#$GemsCred = Get-AzureRmAutomationCredential -ResourceGroupName "rg-reiautomation" -AutomationAccountName "reiazureauto" -Name "gemsapp"

    node 'localhost'
    { 

        <#User gemsapp 
       {
            Ensure = 'Present'
            UserName = 'gemsapp'
            Password = $GemsCred
            FullName = 'GemsApp'
            PasswordNeverExpires = $true
       }#>
        #OS
        
        xService WERDisabled
        {
        Name = "WerSvc"
        DisPlayName = "Windows Error Reporting Service"
        Startuptype = "DisAbled"
        State = "Stopped"
        }
        WindowsFeature FileAndStorageServices     
       {       
            Ensure = “Present” 
            Name = "FileAndStorage-Services"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
       }
        WindowsFeature ServerGuiMgmtInfra    
       {       
            Ensure = “Present” 
            Name = "Server-Gui-Mgmt-Infra"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
       }
       WindowsFeature ServerGuiShell    
       {       
            Ensure = “Present” 
            Name = "Server-Gui-Shell"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
       } 
        WindowsFeature FileServices     
       {       
            Ensure = “Present” 
            Name = "File-Services"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
       }
       WindowsFeature TelnetClient     
        {       
            Ensure = “Present” 
            Name = "Telnet-Client"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
            IncludeAllSubFeature = $true

        }
        WindowsFeature PowerShellRoot    
       {       
            Ensure = “Present” 
            Name = "PowerShellRoot"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
       }
       WindowsFeature PowerShell    
       {       
            Ensure = “Present” 
            Name = "PowerShell"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
       }
       WindowsFeature PowerShellV2   
       {       
            Ensure = “Present” 
            Name = "PowerShell-V2"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
       }
       WindowsFeature PowerShellISE   
       {       
            Ensure = “Present” 
            Name = "PowerShell-ISE"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
       }
       WindowsFeature WAS   
       {       
            Ensure = “Present” 
            Name = "WAS"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
            IncludeAllSubFeature = $true
       }
      
       WindowsFeature WoW64Support   
       {       
            Ensure = “Present” 
            Name = "WoW64-Support"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
            #IncludeAllSubFeature = $true
       }
       WindowsFeature FS
        {
            Ensure = 'Present'
            Name = 'FS-FileServer'
        }
        WindowsFeature StorageServices     
       {       
            Ensure = “Present” 
            Name = "Storage-Services"
       }
       WindowsFeature Server-Media-Foundation
       {
            Ensure = “Present” 
            Name = "Server-Media-Foundation"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
       }
        
        WindowsFeature IIS 
        { 
            Ensure = "Present" 
            Name = "Web-Server"                       
        } 
        WindowsFeature WinRM-IIS-Ext   
       {       
            Ensure = “Present” 
            Name = "WinRM-IIS-Ext"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
            #IncludeAllSubFeature = $true
       }
       WindowsFeature RSAT     
        {       
            Ensure = “Present”       
            Name = “RSAT”
            #IncludeAllSubFeature = $true
                 
        }
        WindowsFeature RSATFeatureTools     
        {       
            Ensure = “Present”       
            Name = “RSAT-Feature-Tools”
            #IncludeAllSubFeature = $true
                 
        }
       WindowsFeature ApplicationServer
       {
            Ensure = “Present” 
            Name = "Application-Server"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
       }
       WindowsFeature NETFW35    
       {       
            Ensure = “Present” 
            Name = "NET-Framework-Features"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
            
       }
       WindowsFeature NETFW45     
       {       
            Ensure = “Present” 
            Name = "NET-Framework-45-Features"
       }
        WindowsFeature WebWebServer     
       {       
            Ensure = “Present”       
            Name = “Web-WebServer”
            #IncludeAllSubFeature = $true
                 
       }
        WindowsFeature IISManagement     
       {       
            Ensure = “Present”       
            Name = “Web-Mgmt-Tools”
            IncludeAllSubFeature = $true
                 
       }
        
        WindowsFeature IISScriptingTools     
        {       
            Ensure = “Present”       
            Name = “Web-Scripting-Tools”
            #IncludeAllSubFeature = $true
                 
        }
        WindowsFeature WebHealth  
        {  
            Ensure = "Present"  
            Name = "Web-Health"
            IncludeAllSubFeature = $true 
        }  
        WindowsFeature WebPerformance  
        {  
            Ensure = "Present"  
            Name = "Web-Performance"
            IncludeAllSubFeature = $true 
        } 
        WindowsFeature WebSecurity  
        {  
            Ensure = "Present"  
            Name = "Web-Security"
            IncludeAllSubFeature = $true 
        }
        WindowsFeature AspNet 
        {  
            Ensure = "Present"  
            Name = "Web-Asp-Net"  
        }            
        WindowsFeature AspNet45  
        {  
            Ensure = "Present"  
            Name = "Web-Asp-Net45"  
        }  
        WindowsFeature ASP      
        {       
            Ensure = “Present”       
            Name = “Web-Asp”     
        }       
        WindowsFeature HTTPRedirect    
        {       
            Ensure = “Present”       
            Name = “Web-Http-Redirect”     
        }
        WindowsFeature WebDirBrowsing    
        {       
            Ensure = “Present”       
            Name = “Web-Dir-Browsing”
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"     
        }
        WindowsFeature WebHttpErrors    
        {       
            Ensure = “Present”       
            Name = “Web-Http-Errors”
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"     
        }
         WindowsFeature WebStaticContent    
        {       
            Ensure = “Present”       
            Name = “Web-Static-Content”
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"     
        }
        WindowsFeature WebCommonHttp    
        {       
            Ensure = “Present”       
            Name = “Web-Common-Http”
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"     
        }
        WindowsFeature WebDefaultDoc    
        {       
            Ensure = “Present”       
            Name = “Web-Default-Doc”
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"     
        }
        WindowsFeature WebAppDev    
        {       
            Ensure = “Present”       
            Name = “Web-App-Dev”
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"     
        }
        WindowsFeature WebNetExt    
        {       
            Ensure = “Present”       
            Name = “Web-Net-Ext”
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"     
        }
        WindowsFeature WebNetExt45    
        {       
            Ensure = “Present”       
            Name = “Web-Net-Ext45”
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"     
        }
        
        WindowsFeature WebISAPIExt    
        {       
            Ensure = “Present”       
            Name = “Web-ISAPI-Ext” 
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"    
        }
        WindowsFeature WebISAPIFilter    
        {       
            Ensure = “Present”       
            Name = “Web-ISAPI-Filter” 
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"    
        }
        WindowsFeature NETFrameworkCore    
        {       
            Ensure = “Present”       
            Name = “NET-Framework-Core”
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"     
        }
        WindowsFeature NETFW35HTTPActivation    
       {       
            Ensure = “Present” 
            Name = "NET-HTTP-Activation"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
       }
        WindowsFeature NETFramework45Core    
        {       
            Ensure = “Present”       
            Name = “NET-Framework-45-Core”
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"     
        }
        
       WindowsFeature NETFramework45ASPNET    
        {       
            Ensure = “Present”       
            Name = “NET-Framework-45-ASPNET”
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"     
        }
        WindowsFeature NETWCFServices45    
        {       
            Ensure = “Present”       
            Name = “NET-WCF-Services45”
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"     
        }
         WindowsFeature NETWCFHTTPActivation45   
        {       
            Ensure = “Present”       
            Name = “NET-WCF-HTTP-Activation45”
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"     
        }
        
        WindowsFeature NETWCFTCPPortSharing45     
        {       
            Ensure = “Present” 
            Name = "NET-WCF-TCP-PortSharing45"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
        }
        
        WindowsFeature WDS
        {
            Ensure = "Present"
            Name = "WDS"
        }
        ##########Application Server
        
        WindowsFeature ASNetFramework
       {
            Ensure = “Present” 
            Name = "AS-Net-Framework"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
       }
       WindowsFeature ASEntServices
       {
            Ensure = “Present” 
            Name = "AS-Ent-Services"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
       }
       WindowsFeature ASDistTransaction
       {
            Ensure = “Present” 
            Name = "AS-Dist-Transaction"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
            IncludeAllSubFeature = $true
       }
       
       WindowsFeature ASWebSupport
       {
            Ensure = “Present” 
            Name = "AS-Web-Support"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
       }
       
       WindowsFeature ASWASSupport
       {
            Ensure = “Present” 
            Name = "AS-WAS-Support"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
       }
       
       WindowsFeature ASHTTPActivation
       {
            Ensure = “Present” 
            Name = "AS-HTTP-Activation"
            #Source = "https://reidevopsstorage.blob.core.windows.net/prereqs/2012r2_Source/sxs"
        }
#########################Package copy and installation#########################                
        script DashboardCopy
        {
            setScript ={wget -UseBasicParsing -Method Get 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/SQLServer2012_PerformanceDashboard.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-04-25T01:04:51Z&st=2017-04-24T17:04:51Z&spr=https&sig=zaWEP20n6izmD5kK6diPBZ532tryoAOnwy5SdxAr7r8%3D' -OutFile 'c:\rburke\SQLServer2012_PerformanceDashboard.msi'}
            TestScript = "Test-Path -path 'c:\rburke\SQLServer2012_PerformanceDashboard.msi'"
            Getscript = {@(pathtest = (Test-Path -Path "c:\rburke\SQLServer2012_PerformanceDashboard.msi"))}
        }
        Package SQL2012Dashboard
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = 'c:\rburke\SQLServer2012_PerformanceDashboard.msi'
            Name = "Microsoft SQL Server 2012 Performance Dashboard Reports"
            ProductId = "99A0A13E-3B9E-45D0-B933-031ED7CE26DB"
        }
        script msxml6x64Copy
        {
            setScript ={wget -UseBasicParsing -Method Get 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/7z920-x64.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-04-25T01:04:51Z&st=2017-04-24T17:04:51Z&spr=https&sig=zaWEP20n6izmD5kK6diPBZ532tryoAOnwy5SdxAr7r8%3D' -OutFile 'c:\rburke\7z920-x64.msi'}
            TestScript = "Test-Path -path 'c:\rburke\7z920-x64.msi'"
            Getscript = {@(pathtest = (Test-Path -Path "c:\rburke\7z920-x64.msi"))}
        }
        script msxml6x64 
        {
            Setscript ={
            $msxml6x64 = "msiexec /i c:\rburke\7z920-x64.msi /quiet"
            Invoke-expression $msxml6x64
        }
            TestScript = "Test-Path -path 'C:\Windows\System32\msxml6.dll'"
            Getscript = {@(pathtest = (Test-Path -Path "C:\Windows\System32\msxml6.dll"))}
        }
        script WSE2SP3Copy
        {
            setScript ={wget -UseBasicParsing -Method Get 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/WSE 2.0 SP3 Runtime.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-04-25T01:04:51Z&st=2017-04-24T17:04:51Z&spr=https&sig=zaWEP20n6izmD5kK6diPBZ532tryoAOnwy5SdxAr7r8%3D' -OutFile 'c:\rburke\WSE 2.0 SP3 Runtime.msi'}
            TestScript = "Test-Path -path 'c:\rburke\WSE 2.0 SP3 Runtime.msi'"
            Getscript = {@(pathtest = (Test-Path -Path "c:\rburke\WSE 2.0 SP3 Runtime.msi"))}
        }
        Package WSE2SP3
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = 'c:\rburke\WSE 2.0 SP3 Runtime.msi'
            Name = "Microsoft WSE 2.0 SP3 Runtime"
            ProductId = "F3CA9611-CD42-4562-ADAB-A554CF8E17F1"
        }
        File ehbepsCopy
        {
            Ensure = 'Present'
            Type = 'Directory'
            Recurse = $true
            SourcePath = '\\rei-azure-sbx44.eastus2.cloudapp.azure.com\c$\eheps'
            DestinationPath = 'c:\ehbeps'
        }
        
        }
    } 

<#
IISInstall -ConfigurationData $test -OutputPath 'd:\rburke\is'
#Start-DscConfiguration -Path d:\rburke\is -Wait -Force -Verbose
#>