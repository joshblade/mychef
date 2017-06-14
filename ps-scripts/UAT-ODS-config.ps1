###ODS Build
$test = @{ 
                 AllNodes = @(        
                              @{     
                                 NodeName = "localhost" 
                                 # Allows credential to be saved in plain-text in the the *.mof instance document.                             
                                 PSDscAllowPlainTextPassword = $true
                                
                              } 
                            )  
              } 

Configuration ODSConfig{

    #Import-DscResource -ModuleName @{ModuleName="xPSDesiredStateConfiguration";ModuleVersion="3.4.0.0"}
    Import-module -Name @{ModuleName="xWebAdministration";ModuleVersion="1.6.0.0"}
    Import-DscResource -ModuleName "xPSDesiredStateConfiguration"
    Import-DscResource -ModuleName @{ModuleName="PSDesiredStateConfiguration";ModuleVersion="1.1"}
    #Import-DscResource -ModuleName "PSDesiredStateConfiguration" 
    Import-DscResource -ModuleName "cIISBaseConfig" 
    Import-DscResource -ModuleName "cWebAdministration" 
    Import-DscResource -ModuleName "xWebAdministration" 
    #Import-DscResource -ModuleName "xSMTP"
    Import-DscResource -ModuleName "xSMBShare"
    Import-module -name "webadministration"
    Import-DscResource -ModuleName "xTimeZone"
    Import-DscResource -ModuleName "xRemoteDesktopAdmin"
    Import-DscResource -ModuleName "cSQLServer"

         Node localhost
         #$AllNodes.Where{$_.OS -eq $true}.NodeName 
    {
##########USER CONFIG        
        
       User ehbssas 
       {
            Ensure = 'Present'
            UserName = 'ehbssas'
            Password = $SSASCredential
            FullName = 'EHBSSAS'
            PasswordNeverExpires = $true
       }  
       #OS  
        User ehbsqlsa 
       {
       Ensure = 'Present'
       UserName = 'ehbsqlsa'
       Password = $SQLCredential
       FullName = 'EHBSQLSA'
       PasswordNeverExpires = $true
       }
       #OS
       xGroup Administrators
       { 
       Ensure = 'Present'
       GroupName = 'Administrators'
       MembersToInclude = 'ehbsqlsa','reisys\ehrsa-cm', 'reisys\hrsa-cm'
       Credential = $verifyCredential
       }

##########FILE CONFIG
        
        File ntrightscheck 
        {
            Type = "File"
            DestinationPath = "\\hrsafs\ise\Tools\ntrights.exe"
            Ensure = "Present"
        }
        File SAFileUpcheck 
        {
            Ensure = 'Present'
            Type = "Directory"
            Recurse = $true
            SourcePath = "\\hrsafs\ise\Prerequisites\SAFileUp_5.3.2.68"
            DestinationPath = "Y:\SAFileUp_5.3.2.68"
         }
         File Gems_Backup
        {
            Ensure = 'Present'
            DestinationPath = 'z:\Gems_Backup'
            Type = 'Directory'
        }

         
##########FILE PERMISSIONS
        NTFSPermission gemsappZGemsBackup
        {
            Account = "gemsapp"
            Path = "z:\Gems_Backup"
            Access = "Allow"
            Ensure = "Present"
            Rights = "FullControl"
       }

        
        
#################SHARE
       xSmbShare Privateroot
       {
            Ensure = "Present" #Or absent to remove
            Name = "Privateroot" #Sharename
            Path = "Y:\Privateroot" #Physical Path
            ChangeAccess = "Everyone"
            #ReadAccess = "Everyone"
            #FullAccess = "User"
            Description = "File share located on web server normally"
       }
       xSmbShare Logs
       {
            Ensure = "Present" #Or absent to remove
            Name = "Logs" #Sharename
            Path = "Y:\Logs" #Physical Path
            #ChangeAccess = "Everyone"
            ReadAccess = "Everyone"
            #FullAccess = "User"
            Description = "File share located on web server normally"
       }
#################FEATURES AND ROLES
       WindowsFeature ApplicationServer
       {
            Ensure = “Present” 
            Name = "Application-Server"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature ASNetFramework
       {
            Ensure = “Present” 
            Name = "AS-Net-Framework"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature ASEntServices
       {
            Ensure = “Present” 
            Name = "AS-Ent-Services"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature ASDistTransaction
       {
            Ensure = “Present” 
            Name = "AS-Dist-Transaction"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
            IncludeAllSubFeature = $true
       }
       WindowsFeature ASWebSupport
       {
            Ensure = “Present” 
            Name = "AS-Web-Support"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature ASWASSupport
       {
            Ensure = “Present” 
            Name = "AS-WAS-Support"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature ASHTTPActivation
       {
            Ensure = “Present” 
            Name = "AS-HTTP-Activation"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature WebODBCLogging
       {
            Ensure = “Present” 
            Name = "Web-ODBC-Logging"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature ASNamedPipes
       {
            Ensure = “Present” 
            Name = "AS-Named-Pipes"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature ASTCPActivation
       {
            Ensure = “Present” 
            Name = "AS-TCP-Activation"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
        }
        WindowsFeature ASTCPPortSharing
       {
            Ensure = “Present” 
            Name = "AS-TCP-Port-Sharing"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
            IncludeAllSubFeature = $true
       }
       WindowsFeature IISManagementConsole     
       {       
            Ensure = “Present”       
            Name = “Web-Mgmt-Console”
            #IncludeAllSubFeature = $true
                 
       }

       WindowsFeature IISCompat     
       {       
            Ensure = “Present”       
            Name = “Web-Mgmt-Compat”
            #IncludeAllSubFeature = $true
                 
       }
       WindowsFeature IISMetabase     
       {       
            Ensure = “Present”       
            Name = “Web-Metabase”
            #IncludeAllSubFeature = $true
                 
       }
       WindowsFeature NETWCFServices45    
        {       
            Ensure = “Present”       
            Name = “NET-WCF-Services45”
            Source = "\\hrsafs\ise\2012r2_Source\sxs"     
        }
        WindowsFeature NETFW45HTTPActivation     
       {       
            Ensure = “Present” 
            Name = "NET-WCF-HTTP-Activation45"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature NETWCFPipeActivation45     
        {       
            Ensure = “Present” 
            Name = "NET-WCF-Pipe-Activation45"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
        }
        WindowsFeature NETWCFTCPActivation45     
        {       
            Ensure = “Present” 
            Name = "NET-WCF-TCP-Activation45"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
        }
       WindowsFeature FileAndStorageServices     
       {       
            Ensure = “Present” 
            Name = "FileAndStorage-Services"
       }
       WindowsFeature FileServices     
       {       
            Ensure = “Present” 
            Name = "File-Services"
       }
       WindowsFeature StorageServices     
       {       
            Ensure = “Present” 
            Name = "Storage-Services"
       }
       WindowsFeature FSFileServer
       {
            Ensure = “Present” 
            Name = "FS-FileServer"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature RSATSMTP     
        {       
            Ensure = “Present”       
            Name = “RSAT-SMTP”
            #IncludeAllSubFeature = $true
                 
        }

         WindowsFeature SMTPServer     
        {       
            Ensure = “Present”       
            Name = “SMTP-Server”
            #IncludeAllSubFeature = $true
                 
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
       WindowsFeature WebCommonHttp    
       {       
            Ensure = “Present”       
            Name = “Web-Common-Http”     
       }
       WindowsFeature WebDefaultDoc
       {
            Ensure = "Present"
            Name = "Web-Default-Doc"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature WebDirBrowsing    
       {       
            Ensure = “Present”       
            Name = “Web-Dir-Browsing”     
       }
        WindowsFeature WebHttpErrors    
       {       
            Ensure = “Present” 
            Name = "Web-Http-Errors"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature WebStaticContent    
       {       
            Ensure = “Present” 
            Name = "Web-Static-Content"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature HTTPRedirect    
       {       
            Ensure = “Present”       
            Name = “Web-Http-Redirect”     
       }
       WindowsFeature WebHttpLogging  
       {  
            Ensure = "Present"  
            Name = "Web-Http-Logging"
            #IncludeAllSubFeature = $true 
       }
       WindowsFeature WebLogLibraries  
       {  
            Ensure = "Present"  
            Name = "Web-Log-Libraries"
            #IncludeAllSubFeature = $true 
       }
       WindowsFeature WebRequestmonitor  
       {  
            Ensure = "Present"  
            Name = "Web-Request-monitor"
            #IncludeAllSubFeature = $true 
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
        WindowsFeature WebFiltering  
        {  
            Ensure = "Present"  
            Name = "Web-Filtering" 
        }
        WindowsFeature WebBasicAuth  
        {  
            Ensure = "Present"  
            Name = "Web-Basic-Auth" 
        }
        WindowsFeature WebClientAuth  
        {  
            Ensure = "Present"  
            Name = "Web-Client-Auth" 
        }
        WindowsFeature WebDigestAuth  
        {  
            Ensure = "Present"  
            Name = "Web-Digest-Auth" 
        }
        WindowsFeature WebIPSecurity  
        {  
            Ensure = "Present"  
            Name = "Web-IP-Security" 
        }
        WindowsFeature WebCertAuth  
        {  
            Ensure = "Present"  
            Name = "Web-Cert-Auth" 
        }
        WindowsFeature WebUrlAuth  
        {  
            Ensure = "Present"  
            Name = "Web-Url-Auth" 
        }
        WindowsFeature WebWindowsAuth  
        {  
            Ensure = "Present"  
            Name = "Web-Windows-Auth" 
        }
        WindowsFeature WebAppDev    
        {       
            Ensure = “Present”       
            Name = “Web-App-Dev”     
        }
        WindowsFeature WebNetExt45    
        {       
            Ensure = “Present”       
            Name = “Web-Net-Ext45”     
        }
        WindowsFeature WebAspNet45    
        {       
            Ensure = “Present”       
            Name = “Web-Asp-Net45”     
        }
        WindowsFeature WebISAPIExt    
        {       
            Ensure = “Present”       
            Name = “Web-ISAPI-Ext”     
        }
        WindowsFeature WebISAPIFilter    
        {       
            Ensure = “Present”       
            Name = “Web-ISAPI-Filter”     
        }
        WindowsFeature IISLegacyConsole     
        {       
            Ensure = “Present”       
            Name = “Web-Lgcy-Mgmt-Console”
            #IncludeAllSubFeature = $true
                 
        }
       WindowsFeature IISScriptingTools     
        {       
            Ensure = “Present”       
            Name = “Web-Scripting-Tools”
            #IncludeAllSubFeature = $true
                 
        }
        WindowsFeature WDS
        {
            Ensure = "Present"
            Name = "WDS"
            IncludeAllSubFeature = $true
        }
        WindowsFeature NETFW35    
       {       
            Ensure = “Present” 
            Name = "NET-Framework-Features"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature NETFrameworkCore    
        {       
            Ensure = “Present”       
            Name = “NET-Framework-Core”
            Source = "\\hrsafs\ise\2012r2_Source\sxs"    
        }
        WindowsFeature NETFW45     
       {       
            Ensure = “Present” 
            Name = "NET-Framework-45-Features"
       }
       WindowsFeature NETFramework45Core    
       {       
            Ensure = “Present”       
            Name = “NET-Framework-45-Core”
            Source = "\\hrsafs\ise\2012r2_Source\sxs"     
       }
       WindowsFeature NETFramework45ASPNET    
       {       
            Ensure = “Present”       
            Name = “NET-Framework-45-ASPNET”
            Source = "\\hrsafs\ise\2012r2_Source\sxs"     
       }
       WindowsFeature NETWCFTCPPortSharing45     
       {       
            Ensure = “Present” 
            Name = "NET-WCF-TCP-PortSharing45"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
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
        WindowsFeature RSATSNMP     
        {       
            Ensure = “Present”       
            Name = “RSAT-SNMP”
            #IncludeAllSubFeature = $true
                 
        }
        WindowsFeature WDSAdminPack     
        {       
            Ensure = “Present”       
            Name = “WDS-AdminPack”
         
        }
        WindowsFeature SNMP     
        {       
            Ensure = “Present” 
            Name = "SNMP-Service"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
            IncludeAllSubFeature = $true
        }
        
        WindowsFeature TelnetClient     
        {       
            Ensure = “Present” 
            Name = "Telnet-Client"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
            IncludeAllSubFeature = $true
        }
        WindowsFeature ServerGuiMgmtInfra     
       {       
            Ensure = “Present” 
            Name = "Server-Gui-Mgmt-Infra"
       }
       WindowsFeature ServerGuiShell    
       {       
            Ensure = “Present” 
            Name = "Server-Gui-Shell"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
        WindowsFeature PowerShellRoot    
       {       
            Ensure = “Present” 
            Name = "PowerShellRoot"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature PowerShell    
       {       
            Ensure = “Present” 
            Name = "PowerShell"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature PowerShellV2   
       {       
            Ensure = “Present” 
            Name = "PowerShell-V2"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature PowerShellISE   
       {       
            Ensure = “Present” 
            Name = "PowerShell-ISE"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature WAS   
       {       
            Ensure = “Present” 
            Name = "WAS"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
            IncludeAllSubFeature = $true
       }
       
       WindowsFeature WoW64Support   
       {       
            Ensure = “Present” 
            Name = "WoW64-Support"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
            #IncludeAllSubFeature = $true
       }
       Environment REIConfigLocationHRSA
        {
         Ensure = "Present"
         Name = "REIConfigLocationHRSA"
         Value = "\\New-HRSABuild.reisys.com\ConfigurationData"
         #Prod Value = "\\GEMSFS1\ConfigurationData"
        }


#######Registry Edits        
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
##############Package Installs
        Package 7zip
        {
        Ensure = "Present"  # You can also set Ensure to "Absent"
        Path  = "\\hrsafs\ISE\Prerequisites\7z920-x64.msi"
        Name = "7-Zip 9.20 (x64 edition)"
        ProductId = "23170F69-40C1-2702-0920-000001000000"
        }
        
        Package o2010pia
        {
        Ensure = "Present"  # You can also set Ensure to "Absent"
        Path  = "\\hrsafs\ISE\Prerequisites\o2010pia.msi"
        Name = "Microsoft Office 2010 Primary Interop Assemblies"
        ProductId = "90140000-1146-0000-0000-0000000FF1CE"
        }
        Package MSXML4
        {
        Ensure = "Present"  # You can also set Ensure to "Absent"
        Path  = "\\hrsafs\ISE\Prerequisites\msxml_SP3.msi"
        Name = "MSXML 4.0 SP3 Parser"
        ProductId = "196467F1-C11F-4F76-858B-5812ADC83B94"
        }
        Package OfficeWebComponents
        {
        #Installs Office 2003 Web Components
        Ensure = "Present"
        Name = "Microsoft Office 2003 Web Components"
        Path = "\\hrsafs\ise\Prerequisites\owc11.exe"
        ProductId = '90120000-00A4-0409-0000-0000000FF1CE'
        }
         script WINSCP 
        {
         Setscript ={
         $WINSCP = "\\hrsafs\ise\Prerequisites\winscp575setup.exe /veryquiet"
         Invoke-expression $WINSCP
        }
         TestScript = "Test-Path -path 'C:\Program Files (x86)\WinSCP\WinSCP.exe'"
         Getscript = {@(pathtest = (Test-Path -Path "C:\Program Files (x86)\WinSCP\WinSCP.exe"))}
        }
          
        
        Package ReportViewer2005
        {
            #ReportViewer
            Ensure = "Present"
            Name = "Microsoft Report Viewer Redistributable 2005"
            Path = '\\hrsafs\ISE\Prerequisites\reportviewer2005\install.exe'
            ProductId = '7635D07D-B727-496F-94CA-8AC60E0C40CE'
            Arguments = '/q"'
        }
        cSQLServerSetup ODS
        {
            InstanceName = "ODS"
            InstanceID = "ODS"
            SourcePath = "\\hsa-txn-int\SQL"
            SourceFolder = "\"
            Features = "SQLENGINE,REPLICATION,FULLTEXT,DQ,AS,DQC,BIDS,CONN,IS,SDK,BOL,SSMS,ADV_SSMS,DREPLAY_CTLR,DREPLAY_CLT,SNAC_SDK,MDS"
            FeaturesTest = "SQLENGINE,FULLTEXT,AS,IS"
            SetupCredential = $SetupCredential 
            UpdateEnabled = "True"
            UpdateSource = "MU"
            InstallSharedDir = "C:\Program Files\Microsoft SQL Server"
            InstallSharedWOWDir = "C:\Program Files (x86)\Microsoft SQL Server"
            SQLSvcAccount = $SQLCredential #SQLSVCACCOUNT="ehbsqlsa" SQLSVCPASSWORD="#GemsUser1"
            AgtSvcAccount = $SQLCredential #AGTSVCACCOUNT="ehbsqlsa" AGTSVCPASSWORD="#GemsUser1"
            ISSvcAccount = $SQLCredential #ISSVCACCOUNT="ehbsqlsa" AGTSVCPASSWORD="#GemsUser1"
            ASSvcAccount = $SQLCredential #ASSVCACCOUNT="ehbsqlsa" ASSVCPASSWORD="#GemsUser1"
            SQLSysAdminAccounts = "REISYS\ehrsa-infrastructure","REISYS\HRSA-DBA","EHBSQLSA"
            SecurityMode = "SQL"
            SAPwd = $SACredential #SAPWD="#GemsUser1"
            InstallSQLDataDir = "E:\Program Files\Microsoft SQL Server\ODS"
            InstanceDir = "E:\Program Files\Microsoft SQL Server\ODS"
            SQLUserDBDir = "E:\Program Files\Microsoft SQL Server\ODS\MSSQL11.ODS\MSSQL\DATA"
            SQLUserDBLogDir = "X:\Program Files\Microsoft SQL Server\ODS\MSSQL11.ODS\MSSQL\Data"
            SQLTempDBDir = "W:\Program Files\Microsoft SQL Server\ODS\MSSQL11.ODS\MSSQL\Data"
            SQLTempDBLogDir = "X:\Program Files\Microsoft SQL Server\ODS\MSSQL11.ODS\MSSQL\Data"
            SQLBackupDir = "Z:\Program Files\Microsoft SQL Server\ODS\MSSQL11.ODS\MSSQL\Data"
            ASDATADIR="E:\Program Files\Microsoft SQL Server\ODS\MSAS11.ODS\OLAP\Data"
            ASLOGDIR="X:\Program Files\Microsoft SQL Server\ODS\MSAS11.ODS\OLAP\Log"
            ASBACKUPDIR="Z:\Program Files\Microsoft SQL Server\ODS\MSAS11.ODS\OLAP\Backup"
            ASTEMPDIR="W:\Program Files\Microsoft SQL Server\ODS\MSAS11.ODS\OLAP\Temp"
            ASCONFIGDIR="E:\Program Files\Microsoft SQL Server\ODS\MSAS11.ODS\OLAP\Config"
            ASSysAdminAccounts = "REISYS\ehrsa-infrastructure","REISYS\HRSA-DBA","EHBSQLSA"
            SQLCollation = "SQL_Latin1_General_CP1_CI_AS"
            ASCollation = "Latin1_General_CI_AS"
            ErrorReporting = "False"
            SQMReporting = "False"
            #DependsOn = '[cSQLServerSetup]TXN'

        }

        
    }
    }
    ODSConfig -ConfigurationData $test -OutputPath 'Y:\rburke\ODS'
#Start-DscConfiguration -Path Y:\rburke\ods -Wait -Force -Verbose