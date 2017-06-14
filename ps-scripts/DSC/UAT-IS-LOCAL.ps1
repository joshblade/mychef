
$test = @{ 
                 AllNodes = @(        
                              @{     
                                 NodeName = "localhost" 
                                 # Allows credential to be saved in plain-text in the the *.mof instance document.                             
                                    PSDscAllowPlainTextPassword = $true
                                    PSDscAllowDomainUser = $true
                              <#      GemsAppPassword = "#GemsUser1"
                                    EHBSSASPassword = "#GemsUser1"
                                    EHBSQLSAPassword = "#GemsUser1"
                                    SQLSAPassword = "#GemsUser1"
                                    eisuserPassword = "#GemsUser1"
                                #>
                              } 
                            )  
              } 
Configuration UatISConfig{

    
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
    #GemsUser1
    $verifyCredential = (Get-Credential -UserName "" -message "Enter your domain account reisys\yourID" )
     Node "localhost"
     #$AllNodes.Where{$_.Config -eq "IS"}.NodeName 
    {
        Script LeaveTimestamp
        {
        SetScript = {
        $currentTime = Get-Date
        $currentTimeString = $currentTime.ToUniversalTime().ToString()
        [Environment]::SetEnvironmentVariable("DSCClientRun","Last DSC-Client run (UTC): $currentTimeString","Machine")
        eventcreate /t INFORMATION /ID 1 /L APPLICATION /SO "DSC-Client" /D "Last DSC-Client run (UTC): $currentTimeString"
        }
        TestScript = {
        $false
        }
        GetScript = {
        # Do Nothing
        }
        }
    
       
       User gemsapp 
       {
            Ensure = 'Present'
            UserName = 'gemsapp'
            Password = (Get-Credential -UserName 'gemsapp' -Message 'gemsapp')
            FullName = 'GemsApp'
            PasswordNeverExpires = $true
       }
       User ehbssas 
       {
            Ensure = 'Present'
            UserName = 'ehbssas'
            Password = (Get-Credential -UserName 'ehbssas' -Message 'ehbssas')
            FullName = 'EHBSSAS'
            PasswordNeverExpires = $true
       }
    
       xGroup Administrators
       { 
       Ensure = 'Present'
       GroupName = 'Administrators'
        MembersToInclude = 'reisys\hrsa-cm','reisys\HRSA-DBA''gemsapp','ehbssas','ehbsqlsa','reisys\tfs_user', 'amer\svc_tfsuser','amer\sg_devops'
       DependsOn = '[User]gemsapp'
       Credential = $verifyCredential
       }
       #OS
       xGroup PerformanceLogUsers
       {
       Ensure = "Present"
       GroupName = "Performance Log Users"
       MembersToInclude = 'gemsapp'
       DependsOn = '[User]gemsapp'
       }
        #OS
       xGroup PerformanceMonitorUsers
       {
       Ensure = "Present"
       GroupName = "Performance Monitor Users"
       MembersToInclude = 'gemsapp','ehbssas'
       DependsOn = '[User]gemsapp'
       }
       xGroup PowerUserUsers
       {
       Ensure = "Present"
       GroupName = "Power Users"
       MembersToInclude = 'gemsapp','ehbssas'
       DependsOn = '[User]gemsapp'
       }
       ########
       xTimeZone REI-EST
        {
            TimeZone = "Eastern Standard Time"
        }
        #OS
        xRemoteDesktopAdmin RemoteDesktopSettings
        {
           Ensure = 'Present'
           UserAuthentication = 'Secure'
           
        }
        xService WERDisabled
        {
        Name = "WerSvc"
        DisPlayName = "Windows Error Reporting Service"
        Startuptype = "DisAbled"
        State = "Stopped"
        }
        Environment REIConfigLocationHRSA
        {
            Ensure = "Present"
            Name = "REIConfigLocationHRSA"
            Value = "\\New-HRSABuild.reisys.com\ConfigurationData"
        }
       #######Features
       WindowsFeature FileAndStorageServices     
       {       
            Ensure = “Present” 
            Name = "FileAndStorage-Services"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
        WindowsFeature ServerGuiMgmtInfra    
       {       
            Ensure = “Present” 
            Name = "Server-Gui-Mgmt-Infra"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature ServerGuiShell    
       {       
            Ensure = “Present” 
            Name = "Server-Gui-Shell"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       } 
        WindowsFeature FileServices     
       {       
            Ensure = “Present” 
            Name = "File-Services"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature TelnetClient     
        {       
            Ensure = “Present” 
            Name = "Telnet-Client"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
            IncludeAllSubFeature = $true

        }
        WindowsFeature PowerShellRoot    
       {       
            Ensure = “Present” 
            Name = "PowerShellRoot"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature PowerShell    
       {       
            Ensure = “Present” 
            Name = "PowerShell"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature PowerShellV2   
       {       
            Ensure = “Present” 
            Name = "PowerShell-V2"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature PowerShellISE   
       {       
            Ensure = “Present” 
            Name = "PowerShell-ISE"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature WAS   
       {       
            Ensure = “Present” 
            Name = "WAS"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
            IncludeAllSubFeature = $true
       }
       WindowsFeature WinRM-IIS-Ext   
       {       
            Ensure = “Present” 
            Name = "WinRM-IIS-Ext"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
            #IncludeAllSubFeature = $true
       }
       WindowsFeature WoW64Support   
       {       
            Ensure = “Present” 
            Name = "WoW64-Support"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
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
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
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
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature InkAndHandwritingServices
       {
            Ensure = “Present” 
            Name = "InkAndHandwritingServices"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature NETFW35    
       {       
            Ensure = “Present” 
            Name = "NET-Framework-Features"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
            
       }
       WindowsFeature NETFW45     
       {       
            Ensure = “Present” 
            Name = "NET-Framework-45-Features"
       }
        
       WindowsFeature IIS     
       {       
            Ensure = “Present”       
            Name = “Web-Server”
            #IncludeAllSubFeature = $true
                 
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
        WindowsFeature RSATSMTP     
        {       
            Ensure = “Present”       
            Name = “RSAT-SMTP”
            #IncludeAllSubFeature = $true
                 
        }
        WindowsFeature RSATSNMP     
        {       
            Ensure = “Present”       
            Name = “RSAT-SNMP”
            #IncludeAllSubFeature = $true
                 
        }
        WindowsFeature SNMP     
        {       
            Ensure = “Present” 
            Name = "SNMP-Service"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
            IncludeAllSubFeature = $true

        }
        WindowsFeature SMTPServer     
        {       
            Ensure = “Present”       
            Name = “SMTP-Server”
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
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"     
        }
        WindowsFeature WebHttpErrors    
        {       
            Ensure = “Present”       
            Name = “Web-Http-Errors”
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"     
        }
         WindowsFeature WebStaticContent    
        {       
            Ensure = “Present”       
            Name = “Web-Static-Content”
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"     
        }
        WindowsFeature WebCommonHttp    
        {       
            Ensure = “Present”       
            Name = “Web-Common-Http”
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"     
        }
        WindowsFeature WebDefaultDoc    
        {       
            Ensure = “Present”       
            Name = “Web-Default-Doc”
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"     
        }
        WindowsFeature WebAppDev    
        {       
            Ensure = “Present”       
            Name = “Web-App-Dev”
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"     
        }
        WindowsFeature WebNetExt    
        {       
            Ensure = “Present”       
            Name = “Web-Net-Ext”
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"     
        }
        WindowsFeature WebNetExt45    
        {       
            Ensure = “Present”       
            Name = “Web-Net-Ext45”
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"     
        }
        
        WindowsFeature WebISAPIExt    
        {       
            Ensure = “Present”       
            Name = “Web-ISAPI-Ext” 
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"    
        }
        WindowsFeature WebISAPIFilter    
        {       
            Ensure = “Present”       
            Name = “Web-ISAPI-Filter” 
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"    
        }
        WindowsFeature NETFrameworkCore    
        {       
            Ensure = “Present”       
            Name = “NET-Framework-Core”
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"     
        }
        WindowsFeature NETFW35HTTPActivation    
       {       
            Ensure = “Present” 
            Name = "NET-HTTP-Activation"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
        WindowsFeature NETFramework45Core    
        {       
            Ensure = “Present”       
            Name = “NET-Framework-45-Core”
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"     
        }
        
       WindowsFeature NETFramework45ASPNET    
        {       
            Ensure = “Present”       
            Name = “NET-Framework-45-ASPNET”
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"     
        }
        WindowsFeature NETWCFServices45    
        {       
            Ensure = “Present”       
            Name = “NET-WCF-Services45”
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"     
        }
         WindowsFeature NETWCFHTTPActivation45   
        {       
            Ensure = “Present”       
            Name = “NET-WCF-HTTP-Activation45”
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"     
        }
        
        WindowsFeature NETWCFTCPPortSharing45     
        {       
            Ensure = “Present” 
            Name = "NET-WCF-TCP-PortSharing45"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
        WindowsFeature WebWHC   
        {       
            Ensure = “Present”       
            Name = “Web-WHC”
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"     
        }
        WindowsFeature WDS
        {
            Ensure = "Present"
            Name = "WDS"
        }
        ##########Application Server
        WindowsFeature MSMQ
        {
            Ensure = "Present"
            Name = "MSMQ"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
        WindowsFeature MSMQServices
        {
            Ensure = "Present"
            Name = "MSMQ-Services"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
        WindowsFeature MSMQServer
        {
            Ensure = "Present"
            Name = "MSMQ-Server"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
        WindowsFeature MSMQHTTPSupport
        {
            Ensure = "Present"
            Name = "MSMQ-HTTP-Support"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
        WindowsFeature MSMQTriggers
        {
            Ensure = "Present"
            Name = "MSMQ-Triggers"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
        WindowsFeature MSMQMulticasting
        {
            Ensure = "Present"
            Name = "MSMQ-Multicasting"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
        WindowsFeature MSMQRouting
        {
            Ensure = "Present"
            Name = "MSMQ-Routing"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
        WindowsFeature MSMQDCOM
        {
            Ensure = "Present"
            Name = "MSMQ-DCOM"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
        WindowsFeature ASNetFramework
       {
            Ensure = “Present” 
            Name = "AS-Net-Framework"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature ASEntServices
       {
            Ensure = “Present” 
            Name = "AS-Ent-Services"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature ASDistTransaction
       {
            Ensure = “Present” 
            Name = "AS-Dist-Transaction"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
            IncludeAllSubFeature = $true
       }
       
       WindowsFeature ASWebSupport
       {
            Ensure = “Present” 
            Name = "AS-Web-Support"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       
       WindowsFeature ASWASSupport
       {
            Ensure = “Present” 
            Name = "AS-WAS-Support"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       
       WindowsFeature ASHTTPActivation
       {
            Ensure = “Present” 
            Name = "AS-HTTP-Activation"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
        ###############Packages
        
        Package SQL2012Dashboard
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs.reisys.com\ISE\Prerequisites\SQLServer2012_PerformanceDashboard.msi"
            Name = "Microsoft SQL Server 2012 Performance Dashboard Reports"
            ProductId = "99A0A13E-3B9E-45D0-B933-031ED7CE26DB"
        }
        <#
        Package MSXML4
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs.reisys.com\ISE\Prerequisites\msxml_SP3.msi"
            Name = "MSXML 4.0 SP3 Parser"
            ProductId = "196467F1-C11F-4F76-858B-5812ADC83B94"
        }
        #>
        script msxml6x64 
        {
         Setscript ={
         $msxml6x64 = "msiexec /i \\hrsafs.reisys.com\ise\Prerequisites\msxml6_x64.msi /quiet"
         Invoke-expression $msxml6x64
        }
         TestScript = "Test-Path -path 'C:\Windows\System32\msxml6.dll'"
         Getscript = {@(pathtest = (Test-Path -Path "C:\Windows\System32\msxml6.dll"))}
        }
        Package WSE2SP3
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs.reisys.com\ISE\Prerequisites\WSE 2.0 SP3 Runtime.msi"
            Name = "Microsoft WSE 2.0 SP3 Runtime"
            ProductId = "F3CA9611-CD42-4562-ADAB-A554CF8E17F1"
        }
        Package WSE3
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs.reisys.com\ISE\Prerequisites\WSE 3.0.msi"
            Name = "Microsoft WSE 3.0"
            ProductId = "EDEA8AB7-7683-4ED2-AA19-E6C078064C0D"
        }
        Package SQLXML
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs.reisys.com\ISE\Prerequisites\sqlxml_x64.msi"
            Name = "Microsoft SQLXML 4.0 SP1"
            ProductId = "9665B2D6-69B1-43A2-B7CB-E05CF7705860"
        }
        Package SQL05ASOLEDB9
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs.reisys.com\ISE\Prerequisites\SQLServer2005_ASOLEDB9_x64.msi"
            Name = "Microsoft SQL Server 2005 Analysis Services 9.0 OLEDB Provider"
            ProductId = "DD8856EB-3420-4EC6-988B-7541FA0A1789"
        }
        Package SQL12ASOLEDB
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs.reisys.com\ISE\Prerequisites\SQL_AS_OLEDB.msi"
            Name = "Microsoft AS OLE DB Provider for SQL Server 2012"
            ProductId = "ECEDFB1D-D815-4B9D-B5F4-B508C609F29B"
        }
        Package SQL12ASADOMD
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs.reisys.com\ISE\Prerequisites\SQL_AS_ADOMD.msi"
            Name = "Microsoft SQL Server 2012 ADOMD.NET "
            ProductId = "8FAD23AA-BD31-43DC-ADB7-D5EF35F4924D"
        }        
        
        Package ASPAJAXExt1
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs.reisys.com\ISE\Prerequisites\ASPAJAXExtSetup.msi"
            Name = "Microsoft ASP.NET 2.0 AJAX Extensions 1.0"
            ProductId = "082BDF7B-4810-4599-BF0D-E3AC44EC8524"

        }
        Package AccessDatabaseEngine
        {
            #Installs Access database engine
            Ensure = "Present"
            Name = "AccessDatabaseEngine"
            Path = "\\hrsafs.reisys.com\ISE\Prerequisites\AccessDatabaseEngine_x64.exe"
            ProductId = '90140000-00D1-0409-1000-0000000FF1CE'          
        }
        Package OfficeWebComponents
        {
            #Installs Office 2003 Web Components
            Ensure = "Present"
            Name = "Microsoft Office 2003 Web Components"
            Path = "\\hrsafs.reisys.com\ise\Prerequisites\owc11.exe"
            ProductId = '90120000-00A4-0409-0000-0000000FF1CE'
            }

            Package ReportViewer2005
         {
            #ReportViewer
            Ensure = "Present"
            Name = "Microsoft Report Viewer Redistributable 2005"
            Path = '\\hrsafs.reisys.com\ISE\Prerequisites\reportviewer2005\install.exe'
            ProductId = '7635D07D-B727-496F-94CA-8AC60E0C40CE'
            Arguments = '/q'
            }
            script reportviewer_2008 
        {
         Setscript ={
         $reportviewer2008 = "\\hrsafs.reisys.com\ise\Prerequisites\ReportViewer2008SP1.exe /Q"
         Invoke-expression $reportviewer2008
        }
         TestScript = "Test-Path -path 'C:\Windows\System32\msxml6.dll'"
         Getscript = {@(pathtest = (Test-Path -Path "C:\Windows\System32\msxml6.dll"))}
        }
        ##########FILE CONFIG
        File Temp
        {
            Ensure = 'Present'
            DestinationPath = 'y:\Temp'
            Type = 'Directory'
        }        
        File Gems_Backup
        {
            Ensure = 'Present'
            DestinationPath = 'y:\Gems_Backup'
            Type = 'Directory'
        }
        File Logs 
        {
            Ensure = "Present"
            Type = "Directory"
            DestinationPath = "Y:\Logs"
        }       
        
        File PrivateRoot
        {
            Ensure = 'Present'
            DestinationPath = 'Y:\Privateroot'
            Type = 'Directory'
        }
        File PrivateRootConfigHistory
        {
            Ensure = 'Present'
            DestinationPath = 'Y:\Privateroot\configHistory'
            Type = 'Directory'
        }
        File PrivateRoot2010
        {
            Ensure = 'Present'
            DestinationPath = 'Y:\Privateroot\2010'
            Type = 'Directory'
        }
        File PrivateRootEisV2
        {
            Ensure = 'Present'
            DestinationPath = 'Y:\Privateroot\EIS_v2'
            Type = 'Directory'
        }
        File PrivateRootTestEisV2
        {
            Ensure = 'Present'
            DestinationPath = 'Y:\Privateroot\TestEIS_v2'
            Type = 'Directory'
        }
        
        File RootCopy
        {
            Ensure = 'Present'
            Type = 'Directory'
            Recurse = $true
            SourcePath = '\\hrsafs.reisys.com\ISE\Prerequisites\Root'
            DestinationPath = 'Y:\Root'
        }
        File SystemInterfaces
        {
            Ensure = 'Present'
            DestinationPath = 'Y:\SystemInterfaces'
            Type = 'Directory'
        }
       
        File ntrightscheck 
        {
            Type = "File"
            DestinationPath = "\\hrsafs.reisys.com\ise\Tools\ntrights.exe"
            Ensure = "Present"
        }
        File SAFileUpcheck 
        {
            Ensure = 'Present'
            Type = "Directory"
            Recurse = $true
            SourcePath = "\\hrsafs.reisys.com\ise\Prerequisites\SAFileUp_5.3.2.68"
            DestinationPath = "Y:\SAFileUp_5.3.2.68"
         }
         File F5XForwardedFor 
        {
            Ensure = 'Present'
            Type = "Directory"
            Recurse = $true
            SourcePath = '\\hrsafs.reisys.com\ise\Prerequisites\IIS_Rewrite_64\IIS_Rewrite'
            DestinationPath = "Y:\F5XForwardedFor"
         }
        ###############Permissions
        NTFSPermission gemsappYTemp{
            Account = "gemsapp"
            Path = "y:\temp"
            Access = "Allow"
            Ensure = "Present"
            Rights = "FullControl"
       }

        NTFSPermission usersYlogs{
            Account = "users"
            Path = "y:\logs"
            Access = "Allow"
            Ensure = "Present"
            Rights = "readandexecute"
       }

        NTFSPermission everyoneprivateroot{
            Account = "everyone"
            Path = "y:\privateroot"
            Access = "Allow"
            Ensure = "Present"
            Rights = "readandexecute"
       }
        NTFSPermission users2010{
            Account = "users"
            Path = "Y:\Privateroot\2010"
            Access = "Allow"
            Ensure = "Present"
            Rights = "readandexecute"
       }
        NTFSPermission usersEIS_v2{
            Account = "users"
            Path = "Y:\Privateroot\EIS_v2"
            Access = "Allow"
            Ensure = "Present"
            Rights = "readandexecute"
       }
        NTFSPermission usersTestEIS_v2{
            Account = "users"
            Path = "Y:\Privateroot\TestEIS_v2"
            Access = "Allow"
            Ensure = "Present"
            Rights = "readandexecute"
       }
        NTFSPermission usersTemp{
            Account = "users"
            Path = "Y:\temp"
            Access = "Allow"
            Ensure = "Present"
            Rights = "FullControl"
       }
        NTFSPermission usersCTemp{
            Account = "users"
            Path = "C:\Windows\Temp"
            Access = "Allow"
            Ensure = "Present"
            Rights = "FullControl"
       }
        
       ###############Share Permissions
        
        xSmbShare Logs{
            Ensure = "Present" #Or absent to remove
            Name = "Logs" #Sharename
            Path = "Y:\Logs" #Physical Path
            #ChangeAccess = "Everyone"
            ReadAccess = "Everyone"
            #FullAccess = "User"
            Description = "File share located on web server normally"
       }
        xSmbShare Privateroot{
            Ensure = "Present" #Or absent to remove
            Name = "Privateroot" #Sharename
            Path = "Y:\Privateroot" #Physical Path
            ChangeAccess = "Everyone"
            #ReadAccess = "Everyone"
            #FullAccess = "User"
            Description = "File share located on web server normally"
       }
        
       #######Registry Edits      
        registry VisualFX {
        Ensure = "Present"
        Force = $true
        Key = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
        ValueName = “VisualFXSetting”
        ValueType = “DWord”
        ValueData = “00000002”
        }
    
        registry ProcessorScheduling {
        Ensure = "Present"
        Force = $true
        Key = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl"
        ValueName = “Win32PrioritySeparation”
        ValueType = “DWord”
        ValueData = “26”
        }  
        #Disables Domain profile firewall by setting registry value to 0, to enable change valuedata to "1"
        Registry DomainFirewallDisabled {
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile”
            ValueName = “EnableFirewall”
            ValueType = “DWord”
            ValueData = “0”
            }        
        #Disables Public profile firewall by setting registry value to 0, to enable change valuedata to "1"
        Registry PublicFirewallDisabled{
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile”
            ValueName = “EnableFirewall”
            ValueType = “DWord”
            ValueData = “0”
        }
        #Disables Standard profile firewall by setting registry value to 0, to enable change valuedata to "1"
        Registry StandardFirewallDisabled{
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile”
            ValueName = “EnableFirewall”
            ValueType = “DWord”
            ValueData = “0”
        }
         Registry DisableautostartservermanagerDomainProfile {
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager”
            ValueName = “DoNotOpenServerManagerAtLogon”
            ValueType = “DWord”
            ValueData = “1”
        }
         Registry DisableautostartservermanagerAllUsers {
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Oobe”
            ValueName = “DoNotOpenInitialConfigurationTasksAtLogon”
            ValueType = “DWord”
            ValueData = “1”
        }
        ################Disable JIT Debug
        Registry 32Debugger {
            Ensure = “Absent”
            Key = “HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AeDebug”
            ValueName = "Debugger"
        }
        Registry 32DbgManagedDebugger {
            Ensure = “Absent”
            Key = “HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\”
            ValueName = "DbgManagedDebugger"
        }
        Registry 64Debugger {
            Ensure = “Absent”
            Key = “HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\AeDebug”
            ValueName = "Debugger"
        }
        Registry 64DbgManagedDebugger {
            Ensure = “Absent”
            Key = “HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\.NETFramework”
            ValueName = "DbgManagedDebugger"
        }
        #######MSDTC
        Registry NetworkDtcAccess {
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\Software\Microsoft\MSDTC\Security”
            ValueName = “NetworkDtcAccess”
            ValueType = “DWord”
            ValueData = “1”
        }

        Registry NetworkDtcAccessAdmin {
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\Software\Microsoft\MSDTC\Security”
            ValueName = “NetworkDtcAccessAdmin”
            ValueType = “DWord”
            ValueData = “1”
        }

        Registry XaTransactions {
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\Software\Microsoft\MSDTC\Security”
            ValueName = “XaTransactions”
            ValueType = “DWord”
            ValueData = “1”
        }
        Registry NetworkDtcAccessTransactions {
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\Software\Microsoft\MSDTC\Security”
            ValueName = “NetworkDtcAccessTransactions”
            ValueType = “DWord”
            ValueData = “1”
        }
        Registry NetworkDtcAccessOutbound {
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\Software\Microsoft\MSDTC\Security”
            ValueName = “NetworkDtcAccessOutbound”
            ValueType = “DWord”
            ValueData = “1”
        }
        Registry NetworkDtcAccessClients {
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\Software\Microsoft\MSDTC\Security”
            ValueName = “NetworkDtcAccessClients”
            ValueType = “DWord”
            ValueData = “1”
        }
        Registry NetworkDtcAccessInbound {
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\Software\Microsoft\MSDTC\Security”
            ValueName = “NetworkDtcAccessInbound”
            ValueType = “DWord”
            ValueData = “1”
        }
        Registry LuTransactions {
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\Software\Microsoft\MSDTC\Security”
            ValueName = “LuTransactions”
            ValueType = “DWord”
            ValueData = “1”
        }
        Registry AllowOnlySecureRpcCalls {
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\Software\Microsoft\MSDTC”
            ValueName = “AllowOnlySecureRpcCalls”
            ValueType = “DWord”
            ValueData = “0”
        }
        Registry FallbackToUnsecureRPCIfNecessary {
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\Software\Microsoft\MSDTC”
            ValueName = “FallbackToUnsecureRPCIfNecessary”
            ValueType = “DWord”
            ValueData = “0”
        }
        Registry TurnOffRpcSecurity {
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\Software\Microsoft\MSDTC”
            ValueName = “TurnOffRpcSecurity”
            ValueType = “DWord”
            ValueData = “1”
        }
        Registry Ports {
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\Software\Microsoft\Rpc\Internet”
            ValueName = “Ports”
            ValueType = “MultiString”
            ValueData = “5000-5200”
        }
        Registry PortsInternetAvailable {
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\Software\Microsoft\Rpc\Internet”
            ValueName = “PortsInternetAvailable”
            ValueType = “String”
            ValueData = “Y”
        }
        Registry UseInternetPorts {
            Ensure = “Present”
            Key = “HKEY_LOCAL_MACHINE\Software\Microsoft\Rpc\Internet”
            ValueName = “UseInternetPorts”
            ValueType = “String”
            ValueData = “Y”
        }
        #########IIS Default Settings
        cAppHostKeyValue isapiCgiRestrictionnotListedIsapisAllowed
        {
        Ensure = "Present"
        WebsitePath = "MACHINE/WEBROOT/APPHOST"
        ConfigSection =  "system.webserver/security/isapiCgiRestriction"
        Key = "notListedIsapisAllowed"
        Value = "false"
        IsAttribute = $true
        } 

        Script anonymousAuthenticationoverrideMode
        {
         Setscript = {Set-WebConfiguration -filter system.webserver/security/authentication/anonymousAuthentication -metadata overrideMode -value "Allow"}
         TestScript = {return (Get-WebConfiguration -filter /system.webServer/security/authentication/anonymousAuthentication).overridemode -ieq "Allow" }
         Getscript = {return @(pathtest = (Get-WebConfiguration -filter /system.webServer/security/authentication/anonymousAuthentication).overridemode -ieq "Allow")}
         }
        
        Script windowsAuthenticationoverrideMode
        {
         Setscript = {Set-WebConfiguration -filter system.webserver/security/authentication/windowsAuthentication -metadata overrideMode -value "Allow"}
         TestScript = {return (Get-WebConfiguration -filter /system.webServer/security/authentication/windowsAuthentication).overridemode -ieq "Allow" }
         Getscript = {return @(pathtest = (Get-WebConfiguration -filter /system.webServer/security/authentication/windowsAuthentication).overridemode -ieq "Allow")}
         } 
        cAppHostKeyValue vDirDefaultPath
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.applicationHost/sites/site/application/virtualDirectory"
            Key = "PhysicalPath"
            Value = "y:\root"
            IsAttribute = $true
        }  
        cAppHostKeyValue  queueLength
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            #ConfigSection = "appsettings"
            ConfigSection = "/system.applicationHost/applicationPools/applicationPoolDefaults"
            Key = "queueLength"
            Value = "10000"
            IsAttribute = $true
        }        
        cAppHostKeyValue managedRuntimeVersion
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"            
            ConfigSection =  "/system.applicationHost/applicationPools/applicationPoolDefaults"
            Key = "managedRuntimeVersion"
            Value = "v4.0"
            IsAttribute = $true
        }
        cAppHostKeyValue startMode
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"            
            ConfigSection =  "/system.applicationHost/applicationPools/applicationPoolDefaults"
            Key = "startMode"
            Value = "AlwaysRunning"
            IsAttribute = $true
        }
        cAppHostKeyValue logontype
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/applicationPools/applicationPoolDefaults/processModel"
            Key = "logontype"
            Value = "logonbatch"
            IsAttribute = $true
        }
        cAppHostKeyValue processModelIdleTimeout
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/applicationPools/applicationPoolDefaults/processModel"
            Key = "idleTimeout"
            Value = "01:00:00"
            IsAttribute = $true
        }    
        cAppHostKeyValue processModelidleTimeoutAction
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/applicationPools/applicationPoolDefaults/processModel"
            Key = "idleTimeoutAction"
            Value = "Suspend"
            IsAttribute = $true
        }
        cAppHostKeyValue processModelshutdownTimeLimit
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/applicationPools/applicationPoolDefaults/processModel"
            Key = "shutdownTimeLimit"
            Value = "00:02:30"
            IsAttribute = $true
        }
        cAppHostKeyValue processModelstartupTimeLimit
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/applicationPools/applicationPoolDefaults/processModel"
            Key = "startupTimeLimit"
            Value = "00:02:30"
            IsAttribute = $true
        }
        cAppHostKeyValue logEventOnRecycle
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/applicationPools/applicationPoolDefaults/recycling"
            Key = "logEventOnRecycle"
            Value = "Time,Requests,Schedule,Memory,IsapiUnhealthy,OnDemand,ConfigChange,PrivateMemory"
            IsAttribute = $true
        }

        
        cAppHostKeyValue privateMemory
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/applicationPools/applicationPoolDefaults/recycling/periodicRestart"
            Key = "privateMemory"
            Value = "1048576"
            IsAttribute = $true
        }
        
        cAppHostKeyValue periodicRestartTime
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/applicationPools/applicationPoolDefaults/recycling/periodicRestart"
            Key = "time"
            Value = "00:00:00"
            IsAttribute = $true
        }
        
        cAppHostKeyValue rapidFailProtection
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/applicationPools/applicationPoolDefaults/failure"
            Key = "rapidFailProtection"
            Value = "false"
            IsAttribute = $true
        }
        
        cAppHostKeyValue resetInterval
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/applicationPools/applicationPoolDefaults/cpu"
            Key = "resetInterval"
            Value = "00:15:00"
            IsAttribute = $true
        }
                       
        cAppHostKeyValue centralLogFileMode
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/log"
            Key = "centralLogFileMode"
            Value = "CentralW3C"
            IsAttribute = $true
        }

        Script centralBinaryLogFileEnabled
        {
         Setscript ={Set-WebConfigurationProperty -filter /system.applicationHost/log/centralBinaryLogFile -Name "enabled" -Value "False"}
         TestScript = {(Get-WebConfigurationproperty -filter /system.applicationHost/log/centralBinaryLogFile -Name enabled) -ieq "False"}
         Getscript = {return @(pathtest =(Get-WebConfigurationproperty -filter /system.applicationHost/log/centralBinaryLogFile -Name enabled) -ieq "False")}
         }
        
        Script centralBinaryLogFiledirectory
        {
         Setscript ={Set-WebConfigurationProperty -filter /system.applicationHost/log/centralBinaryLogFile -Name "directory" -Value "Y:\Privateroot\LogFiles"}
         TestScript = {(Get-WebConfigurationproperty -filter /system.applicationHost/log/centralBinaryLogFile -Name directory) -ieq "Y:\Privateroot\LogFiles"}
         Getscript = {return @(pathtest =(Get-WebConfigurationproperty -filter /system.applicationHost/log/centralBinaryLogFile -Name directory) -ieq "Y:\Privateroot\LogFiles")}
         }
         <#             
        cAppHostKeyValue centralBinaryLogFiledirectory
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/log/centralBinaryLogFile"
            Key = "directory"
            Value = "Y:\Privateroot\LogFiles"
            IsAttribute = $true
        }
         #>
        Script centralBinaryLogFiletruncateSize
        {
         Setscript ={Set-WebConfigurationProperty -filter /system.applicationHost/log/centralBinaryLogFile -Name "truncateSize" -Value "1073741824"}
         TestScript = {(Get-WebConfigurationproperty -filter /system.applicationHost/log/centralBinaryLogFile -Name truncateSize) -ieq "1073741824"}
         Getscript = {return @(pathtest =(Get-WebConfigurationproperty -filter /system.applicationHost/log/centralBinaryLogFile -Name truncateSize) -ieq "1073741824")}
         }

        Script centralBinaryLogFilelocalTimeRollover
        {
         Setscript ={Set-WebConfigurationProperty -filter /system.applicationHost/log/centralBinaryLogFile -Name "localTimeRollover" -Value "True"}
         TestScript = {(Get-WebConfigurationproperty -filter /system.applicationHost/log/centralBinaryLogFile -Name localTimeRollover) -ieq "True"}
         Getscript = {return @(pathtest =(Get-WebConfigurationproperty -filter /system.applicationHost/log/centralBinaryLogFile -Name localTimeRollover) -ieq "True")}
         }       
               
        cAppHostKeyValue centralW3CLogFilelocalTimeRollover
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/log/centralW3CLogFile"
            Key = "localTimeRollover"
            Value = "True"
            IsAttribute = $true
        }         
        cAppHostKeyValue centralW3CLogFileEnabled
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/log/centralW3CLogFile"
            Key = "Enabled"
            Value = "True"
            IsAttribute = $true
        }
        Script centralW3CLogFileDir
        {
         Setscript ={Set-WebConfigurationProperty -filter /system.applicationHost/log/centralW3CLogFile -Name "directory" -Value "Y:\Privateroot\LogFiles"}
         TestScript = {(Get-WebConfigurationproperty -filter /system.applicationHost/log/centralW3CLogFile -Name directory) -ieq "Y:\Privateroot\LogFiles"}
         Getscript = {return @(pathtest =(Get-WebConfigurationproperty -filter /system.applicationHost/log/centralW3CLogFile -Name directory) -ieq "Y:\Privateroot\LogFiles")}
         }  
        cAppHostKeyValue centralW3CLogFiletruncateSize
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/log/centralW3CLogFile"
            Key = "truncateSize"
            Value = "1073741824"
            IsAttribute = $true
        }       
         cAppHostKeyValue centralW3CLogFilelogExtFileFlags
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/log/centralW3CLogFile"
            Key = "logExtFileFlags"
            Value = "Date, Time, ClientIP, UserName, SiteName, ComputerName, ServerIP, Method, UriStem, UriQuery, HttpStatus, Win32Status, BytesSent, BytesRecv, TimeTaken, ServerPort, UserAgent, Cookie, Referer, ProtocolVersion, Host, HttpSubStatus"
            IsAttribute = $true
        }
        
        Script centralLogFilelogExtFileFlags
        {
         Setscript ={Set-WebConfigurationProperty -filter /system.applicationHost/sites/siteDefaults/logFile -Name "logExtFileFlags" -Value "Date, Time, ClientIP, UserName, SiteName, ComputerName, ServerIP, Method, UriStem, UriQuery, HttpStatus, Win32Status, BytesSent, BytesRecv, TimeTaken, ServerPort, UserAgent, Cookie, Referer, ProtocolVersion, Host, HttpSubStatus"}
         TestScript = {(Get-WebConfigurationproperty -filter /system.applicationHost/sites/siteDefaults/logFile -Name logExtFileFlags) -ieq "Date, Time, ClientIP, UserName, SiteName, ComputerName, ServerIP, Method, UriStem, UriQuery, HttpStatus, Win32Status, BytesSent, BytesRecv, TimeTaken, ServerPort, UserAgent, Cookie, Referer, ProtocolVersion, Host, HttpSubStatus"}
         Getscript = {return @(pathtest =(Get-WebConfigurationproperty -filter /system.applicationHost/sites/siteDefaults/logFile -Name logExtFileFlags) -ieq "Date, Time, ClientIP, UserName, SiteName, ComputerName, ServerIP, Method, UriStem, UriQuery, HttpStatus, Win32Status, BytesSent, BytesRecv, TimeTaken, ServerPort, UserAgent, Cookie, Referer, ProtocolVersion, Host, HttpSubStatus")}
         }

         Script LogFileDirectory
        {
         Setscript ={Set-WebConfigurationProperty -filter /system.applicationHost/sites/siteDefaults/logFile -Name "directory" -Value "Y:\Privateroot\LogFiles"}
         TestScript = {(Get-WebConfigurationproperty -filter /system.applicationHost/sites/siteDefaults/logFile -Name directory) -ieq "Y:\Privateroot\LogFiles"}
         Getscript = {return @(pathtest =(Get-WebConfigurationproperty -filter /system.applicationHost/sites/siteDefaults/logFile -Name directory) -ieq "Y:\Privateroot\LogFiles")}
         }
         
         Script LogFiletruncateSize
        {
         Setscript ={Set-WebConfigurationProperty -filter /system.applicationHost/sites/siteDefaults/logFile -Name "truncateSize" -Value "1073741824"}
         TestScript = {(Get-WebConfigurationproperty -filter /system.applicationHost/sites/siteDefaults/logFile -Name truncateSize) -ieq "1073741824"}
         Getscript = {return @(pathtest =(Get-WebConfigurationproperty -filter /system.applicationHost/sites/siteDefaults/logFile -Name truncateSize) -ieq "1073741824")}
         }
         
         Script LogFilelocalTimeRollover
        {
         Setscript ={Set-WebConfigurationProperty -filter /system.applicationHost/sites/siteDefaults/logFile -Name "localTimeRollover" -Value "True"}
         TestScript = {(Get-WebConfigurationproperty -filter /system.applicationHost/sites/siteDefaults/logFile -Name localTimeRollover) -ieq "True"}
         Getscript = {return @(pathtest =(Get-WebConfigurationproperty -filter /system.applicationHost/sites/siteDefaults/logFile -Name localTimeRollover) -ieq "True")}
         }
                
         cAppHostKeyValue logFileFormat
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/sites/siteDefaults/logFile"
            Key = "logFormat"
            Value = "W3C"
            IsAttribute = $true
        }

        Script traceFailedRequestsLoggingDir
        {
         Setscript ={Set-WebConfigurationProperty -filter /system.applicationHost/sites/siteDefaults/traceFailedRequestsLogging -Name "directory" -Value "Y:\Privateroot\FailedReqLogFiles"}
         TestScript = {(Get-WebConfigurationproperty -filter /system.applicationHost/sites/siteDefaults/traceFailedRequestsLogging -Name directory) -ieq "Y:\Privateroot\FailedReqLogFiles"}
         Getscript = {return @(pathtest =(Get-WebConfigurationproperty -filter /system.applicationHost/sites/siteDefaults/traceFailedRequestsLogging -Name directory) -ieq "Y:\Privateroot\FailedReqLogFiles")}
         }
        cAppHostKeyValue traceFailedRequestsLoggingmaxLogFileSizeKB
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/sites/siteDefaults/traceFailedRequestsLogging"
            Key = "maxLogFileSizeKB"
            Value = "1048576"
            IsAttribute = $true
        }
        cAppHostKeyValue traceFailedRequestsLoggingMaxLogFiles
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/sites/siteDefaults/traceFailedRequestsLogging"
            Key = "maxLogFiles"
            Value = "10000"
            IsAttribute = $true
        }        

        cAppHostKeyValue connectionTimeout
        {
            #Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/sites/siteDefaults/limits"
            Key = "connectionTimeout"
            Value = "00:30:00"
            IsAttribute = $true
        }
        cAppHostKeyValue maxUrlSegments
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/sites/siteDefaults/limits"
            Key = "maxUrlSegments"
            Value = "64"
            IsAttribute = $true
        }
        cAppHostKeyValue applicationPool
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/sites/applicationDefaults"
            Key = "applicationPool"
            Value = "DefaultAppPool"
            IsAttribute = $true
        }
        Script enabledProtocols
        {
         Setscript = {Set-WebConfigurationproperty -filter /system.applicationHost/sites/applicationDefaults -Name enabledProtocols -Value "https, http"}
         TestScript = {return ((Get-WebConfigurationproperty -filter /system.applicationHost/sites/applicationDefaults -Name enabledProtocols) -ieq "https, http")}
         Getscript = {return @(pathtest = (Get-WebConfigurationproperty -filter /system.applicationHost/sites/applicationDefaults -Name enabledProtocols) -ieq "https, http")}
         
        }
        cAppHostKeyValue allowSubDirConfig
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/sites/virtualDirectoryDefaults"
            Key = "allowSubDirConfig"
            Value = "true"
            IsAttribute = $true
        }                      
        
        Script configHistoryPhysicalPath
        {
         Setscript = {Set-WebConfigurationproperty -filter /system.applicationHost/configHistory -Name path -Value "Y:\Privateroot\configHistory"}
         TestScript = {return ((Get-WebConfigurationproperty -filter /system.applicationHost/configHistory -Name path) -ieq "Y:\Privateroot\configHistory")}
         Getscript = {return @(pathtest = (Get-WebConfigurationproperty -filter /system.applicationHost/configHistory -Name path) -ieq "Y:\Privateroot\configHistory")}
         
        }
        cAppHostKeyValue configHistorymaxHistories
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/configHistory"
            Key = "maxHistories"
            Value = "1000"
            IsAttribute = $true
        }
        ######Config History

         cAppHostKeyValue configHistoryDir
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/configHistory"
            Key = "path"
            Value = "Y:\Privateroot\configHistory"
            IsAttribute = $true
        }
        cAppHostKeyValue weblimitconnectionTimeout
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/webLimits"
            Key = "connectionTimeout"
            Value = "00:30:00"
            IsAttribute = $true
        }          


        #########ASP
         cAppHostKeyValue errorsToNTLog
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/asp"
            Key = "errorsToNTLog"
            Value = "true"
            IsAttribute = $true
        }

        cAppHostKeyValue enableAspHtmlFallback
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/asp"
            Key = "enableAspHtmlFallback"
            Value = "false"
            IsAttribute = $true
        }

        cAppHostKeyValue diskTemplateCacheDirectory
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/asp/cache"
            Key = "diskTemplateCacheDirectory"
            Value = "%SystemDrive%\inetpub\temp\ASP Compiled Templates"
            IsAttribute = $true
        }

        cAppHostKeyValue maxDiskTemplateCacheFiles
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/asp/cache"
            Key = "maxDiskTemplateCacheFiles"
            Value = "2147483647"
            IsAttribute = $true
        }

        cAppHostKeyValue scriptFileCacheSize
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/asp/cache"
            Key = "scriptFileCacheSize"
            Value = "2147483647"
            IsAttribute = $true
        }

        cAppHostKeyValue scriptFilescriptEngineCacheMax
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/asp/cache"
            Key = "scriptEngineCacheMax"
            Value = "2147483647"
            IsAttribute = $true
        }

         cAppHostKeyValue sessionTimeout
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/asp/session"
            Key = "timeout"
            Value = "00:30:00"
            IsAttribute = $true
        }
              
        cAppHostKeyValue bufferingLimit
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/asp/limits"
            Key = "bufferingLimit"
            Value = "12288000"
            IsAttribute = $true
        }

        cAppHostKeyValue maxRequestEntityAllowed
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/asp/limits"
            Key = "maxRequestEntityAllowed"
            Value = "204800"
            IsAttribute = $true
        }

        cAppHostKeyValue processorThreadMax
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/asp/limits"
            Key = "processorThreadMax"
            Value = "100"
            IsAttribute = $true
        }

        cAppHostKeyValue requestQueueMax
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/asp/limits"
            Key = "requestQueueMax"
            Value = "10000"
            IsAttribute = $true
        }

        cAppHostKeyValue defaultDocumentEnabled
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/defaultDocument"
            Key = "enabled"
            Value = "true"
            IsAttribute = $true
        } 
        
        cAppHostKeyValue allowUnlisted
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/security/ipSecurity"
            Key = "allowUnlisted"
            Value = "true"
            IsAttribute = $true
        }
        <#
        cAppHostKeyValue notListedIsapisAllowed
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/security/isapiCgiRestriction"
            Key = "notListedIsapisAllowed"
            Value = "false"
            IsAttribute = $true
        }
        #>
        cAppHostKeyValue notListedCgisAllowed
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/security/isapiCgiRestriction"
            Key = "notListedCgisAllowed"
            Value = "false"
            IsAttribute = $true
        }

        cAppHostKeyValue appConcurrentRequestLimit
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/serverRuntime"
            Key = "appConcurrentRequestLimit"
            Value = "10000"
            IsAttribute = $true
        }
        
        Script DefaultPhysicalPath
        {
         Setscript = {Set-WebConfigurationProperty -filter system.applicationHost/sites/site/application/virtualDirectory -Name "physicalPath" -Value "Y:\root"}
         TestScript = {return (Get-WebConfiguration -filter system.applicationHost/sites/site/application/virtualDirectory) -ieq "Y:\root" }
         Getscript = {return @(pathtest = (Get-WebConfiguration -filter system.applicationHost/sites/site/application/virtualDirectory) -ieq "Y:\root")}
         
        }
        Script F5XForwardedFor
        {
         Setscript = {Add-WebConfiguration -PSPath "MACHINE/WEBROOT/APPHOST" -Filter /system.webServer/isapiFilters -Value @{name = 'F5XForwardedFor';path = 'Y:\F5XForwardedFor\F5XForwardedFor.dll'}}
         TestScript = {return (Get-WebConfigurationproperty -PSPath "MACHINE/WEBROOT/APPHOST" -Filter /system.webServer/isapiFilters/filter -Name name).value -contains 'F5XForwardedFor' }
         Getscript = {return @(isapifiltertest = (Get-WebConfigurationproperty -PSPath "MACHINE/WEBROOT/APPHOST" -Filter /system.webServer/isapiFilters/filter -Name name).value -contains 'F5XForwardedFor')}
         DependsOn = '[File]F5XForwardedFor'
        }
        
        
        ############Script 
        script LogonAsAServiceGems 
        {
         Setscript ={
         $ntrights = "\\hrsafs.reisys.com\ise\Tools\ntrights.exe"
         $machine = $Env:computerName
         Invoke-expression ("$ntrights -u gemsapp +r SeServiceLogonRight -m \\$machine")
        }
         TestScript = "Test-Path -path '\\hrsafs.reisys.com\ise\Tools\mytest.exe'"
         Getscript = {@(pathtest = (Test-Path -Path $ntrights))}
         DependsOn = '[File]ntrightscheck'
        }

        script LogonAsAServiceEHB 
        {
         Setscript ={
         $ntrights = "\\hrsafs.reisys.com\ise\Tools\ntrights.exe"
         $machine = $Env:computerName
         Invoke-expression ("$ntrights -u EHBSSAS +r SeServiceLogonRight -m \\$machine")
        }
         TestScript = "Test-Path -path '\\hrsafs.reisys.com\ise\Tools\mytest.exe'"
         Getscript = {@(pathtest = (Test-Path -Path $ntrights))}
         DependsOn = '[File]ntrightscheck'
        } 
        script SAFileUp 
        {
         Setscript ={
         $SAFileUp = "Y:\SAFileUp_5.3.2.68\SAFileUp_5.3.2.68.bat"
         Invoke-expression ("$safileup")
        }
         TestScript = "Test-Path -path '\\hrsafs.reisys.com\ise\Tools\mytest.exe'"
         Getscript = {@(pathtest = (Test-Path -Path $ntrights))}
         DependsOn = '[File]ntrightscheck'
        } 
        cWebsite NewWebsite 
        { 
            Ensure          = "Present" 
            Name            = "Default Web Site" 
            State           = "Started" 
            PhysicalPath    = "y:\root"
            DependsOn       = "[WindowsFeature]IISManagement"
            BindingInfo     = @( 
                             @(REI_cWebBindingInformation 
                             {                            
                               Protocol              = "HTTPS" 
                               Port                  = "443"
                               CertificateThumbprint = "BC32FD5D1210095263B2682408E2B663FA8ECA2D"
                               CertificateStoreName  = "My" 
                               }
                                );
                               @(REI_cWebBindingInformation 
                             {
                               Protocol              = "HTTP" 
                               Port                  = "80"
                              } 
                              )
                              )
                             
                             } 
        }
        }
      UatISConfig -ConfigurationData $test -OutputPath 'Y:\rburke\is'
#Start-DscConfiguration -Path Y:\rburke\is -Wait -Force -Verbose