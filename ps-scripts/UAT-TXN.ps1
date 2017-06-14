###TXN Build
$test = @{ 
                 AllNodes = @(        
                              @{     
                                 NodeName = "localhost" 
                                 # Allows credential to be saved in plain-text in the the *.mof instance document.                             
                                 PSDscAllowPlainTextPassword = $true
                                
                              } 
                            )  
              } 

############# OS CONFIG #############

Configuration UTLTXNBUILD
{

param (
[pscredential]$credential,
[pscredential]$SSASCredential,
[pscredential]$verifyCredential

)                            

$EISCredentail = (Get-Credential -UserName 'eisuser' -Message 'eisuser')                           
$Gemsappcredential = (Get-Credential -UserName "gemsapp" -Message 'Enter gemsapp password')
$SetupCredential=(Get-Credential -UserName "reisys\robert.burke" -Message "SetupUser")
$credential = (Get-Credential -UserName "gemsapp" -Message 'Enter gemsapp password')
$SSASCredential = (Get-Credential -UserName "ehbssas" -Message 'Enter EHBSSAS password')
$verifyCredential = (Get-Credential -UserName "reisys\robert.burke" )
$SQLCredential = (Get-Credential -UserName "ehbsqlsa" -Message "Enter ehbsqlsa password")#SQLSVCACCOUNT="ehbsqlsa" SQLSVCPASSWORD="#Gems1User"
$SACredential = (Get-Credential -UserName "sa" -Message "sa") 
    Import-module -Name @{ModuleName="xWebAdministration";ModuleVersion="1.6.0.0"}
    #Import-module -Name @{ModuleName="PSDesiredStateConfiguration";ModuleVersion="1.1"}
    Import-DscResource -ModuleName "cIISBaseConfig" 
    Import-DscResource -ModuleName "cWebAdministration" 
    Import-DscResource -ModuleName "xWebAdministration" 
    Import-DscResource -ModuleName "xSMBShare"
    Import-DscResource -ModuleName "xTimeZone"
    Import-DscResource -ModuleName "xRemoteDesktopAdmin"
    Import-DscResource -ModuleName @{ModuleName="xPSDesiredStateConfiguration";ModuleVersion="3.0.3.4"}
    Import-DscResource -ModuleName @{ModuleName="xSQLServer";ModuleVersion="1.3.0.0"}
    Import-DscResource -ModuleName "cSQLServer"
    Import-DscResource -ModuleName @{ModuleName="PSDesiredStateConfiguration";ModuleVersion="1.1"}
      node Localhost
    {
    #################All Systems OS
        #OS
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
   #################User Setup
       
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
       MembersToInclude = 'ehbssas','ehbsqlsa','reisys\ehrsa-cm', 'reisys\hrsa-cm'
       DependsOn = '[User]ehbssas'
       Credential = $verifyCredential
       }

####################Windows Features
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
       WindowsFeature ASTCPPortSharing
       {
       Ensure = “Present” 
       Name = "AS-TCP-Port-Sharing"
       Source = "\\hrsafs\ise\2012r2_Source\sxs"
       IncludeAllSubFeature = $true
       }
       WindowsFeature ASWASSupport
       {
       Ensure = “Present” 
       Name = "AS-WAS-Support"
       Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature ASTCPActivation
       {
       Ensure = “Present” 
        Name = "AS-TCP-Activation"
        Source = "\\hrsafs\ise\2012r2_Source\sxs"
        }
        WindowsFeature ASNamedPipes
       {
       Ensure = “Present” 
       Name = "AS-Named-Pipes"
       Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature ASTCPPortSharing
       {
            Ensure = “Present” 
            Name = "AS-TCP-Port-Sharing"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
            IncludeAllSubFeature = $true
       }
       WindowsFeature FileAndStorageServices     
       {       
            Ensure = “Present” 
            Name = "FileAndStorage-Services"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature FileServices     
       {       
            Ensure = “Present” 
            Name = "File-Services"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
       }
       WindowsFeature FSFileServer
        {
            Ensure = “Present” 
            Name = "FS-FileServer"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
        }
        WindowsFeature StorageServices     
       {       
            Ensure = “Present” 
            Name = "Storage-Services"
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

       WindowsFeature NETNonHTTPActiv    
       {       
            Ensure = “Present” 
            Name = "NET-Non-HTTP-Activ"
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
        WindowsFeature NETWCFServices45    
        {       
            Ensure = “Present”       
            Name = “NET-WCF-Services45”
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
       WindowsFeature WoW64Support   
       {       
            Ensure = “Present” 
            Name = "WoW64-Support"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
            #IncludeAllSubFeature = $true
       }
       WindowsFeature WSFC
        {
            Ensure = "Present"
            Name = "Failover-Clustering"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
        }
        WindowsFeature RSATClustering
        {
            Ensure = "Present"
            Name = "RSAT-Clustering"
            Source = "\\hrsafs\ise\2012r2_Source\sxs"
        }
###########Files and Directories
        File Gems_Backup
        {
            Ensure = 'Present'
            DestinationPath = 'z:\Gems_Backup'
            Type = 'Directory'
        }
        NTFSPermission gemsappZGemsBackup
        {
            Account = "gemsapp"
            Path = "z:\Gems_Backup"
            Access = "Allow"
            Ensure = "Present"
            Rights = "FullControl"
       }
       xSmbShare GemsBackup{
            Ensure = "Present" #Or absent to remove
            Name = "GemsBackup" #Sharename
            Path = "z:\Gems_Backup" #Physical Path
            ChangeAccess = "Everyone"
            #ReadAccess = "User"
            #FullAccess = "User"
            Description = "File share located on file server normally"
       }
############ENV
       Environment REIConfigLocationHRSA
        {
         Ensure = "Present"
         Name = "REIConfigLocationHRSA"
         Value = "\\New-HRSABuild.reisys.com\ConfigurationData"
         #Prod Value = "\\GEMSFS1\ConfigurationData"
        }

#############################Package Installs
        Package 7zip
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs\ISE\Prerequisites\7z920-x64.msi"
            Name = "7-Zip 9.20 (x64 edition)"
            ProductId = "23170F69-40C1-2702-0920-000001000000"
        }
        Package SQL2012Dashboard
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs\ISE\Prerequisites\SQLServer2012_PerformanceDashboard.msi"
            Name = "Microsoft SQL Server 2012 Performance Dashboard Reports"
            ProductId = "99A0A13E-3B9E-45D0-B933-031ED7CE26DB"
        }
        Package MSXML4
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs\ISE\Prerequisites\msxml_SP3.msi"
            Name = "MSXML 4.0 SP3 Parser"
            ProductId = "196467F1-C11F-4F76-858B-5812ADC83B94"
        }
        script msxml6x64 
        {
         Setscript ={
         $msxml6x64 = "msiexec /i \\hrsafs\ise\Prerequisites\msxml6_x64.msi /quiet"
         Invoke-expression $msxml6x64
        }
         TestScript = "Test-Path -path 'C:\Windows\System32\msxml6.dll'"
         Getscript = {@(pathtest = (Test-Path -Path "C:\Windows\System32\msxml6.dll"))}
        }
        Package WSE2SP3
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs\ISE\Prerequisites\WSE 2.0 SP3 Runtime.msi"
            Name = "Microsoft WSE 2.0 SP3 Runtime"
            ProductId = "F3CA9611-CD42-4562-ADAB-A554CF8E17F1"
        }
        Package WSE3
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs\ISE\Prerequisites\WSE 3.0.msi"
            Name = "Microsoft WSE 3.0"
            ProductId = "EDEA8AB7-7683-4ED2-AA19-E6C078064C0D"
        }
        Package SQLXML
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs\ISE\Prerequisites\sqlxml_x64.msi"
            Name = "Microsoft SQLXML 4.0 SP1"
            ProductId = "9665B2D6-69B1-43A2-B7CB-E05CF7705860"
        }
        Package SQL05ASOLEDB9
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs\ISE\Prerequisites\SQLServer2005_ASOLEDB9_x64.msi"
            Name = "Microsoft SQL Server 2005 Analysis Services 9.0 OLEDB Provider"
            ProductId = "DD8856EB-3420-4EC6-988B-7541FA0A1789"
        }
        Package SQL12ASOLEDB
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs\ISE\Prerequisites\SQL_AS_OLEDB.msi"
            Name = "Microsoft AS OLE DB Provider for SQL Server 2012"
            ProductId = "ECEDFB1D-D815-4B9D-B5F4-B508C609F29B"
        }
        Package SQL12ASADOMD
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs\ISE\Prerequisites\SQL_AS_ADOMD.msi"
            Name = "Microsoft SQL Server 2012 ADOMD.NET "
            ProductId = "8FAD23AA-BD31-43DC-ADB7-D5EF35F4924D"
        }
                
        Package ASPAJAXExt1
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs\ISE\Prerequisites\ASPAJAXExtSetup.msi"
            Name = "Microsoft ASP.NET 2.0 AJAX Extensions 1.0"
            ProductId = "082BDF7B-4810-4599-BF0D-E3AC44EC8524"
        }
        Package AccessDatabaseEngine
        {
            #Installs Access database engine
            Ensure = "Present"
            Name = "AccessDatabaseEngine"
            Path = "\\hrsafs\ISE\Prerequisites\AccessDatabaseEngine_x64.exe"
            ProductId = '90140000-00D1-0409-1000-0000000FF1CE'          
        }
        Package OfficeWebComponents
        {
            #Installs Office 2003 Web Components
            Ensure = "Present"
            Name = "Microsoft Office 2003 Web Components"
            Path = "\\hrsafs\ise\Prerequisites\owc11.exe"
            ProductId = '90120000-00A4-0409-0000-0000000FF1CE'
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

            ##########SQL CONFIG
        cSQLServerSetup TXN
        {
            InstanceName = "TXN"
            InstanceID = "TXN"
            SourcePath = "\\hsa-txn-int\SQL"
            SourceFolder = "\"
            Features = "SQLENGINE,REPLICATION,FULLTEXT,DQ,DQC,BIDS,CONN,IS,SDK,BOL,SSMS,ADV_SSMS,DREPLAY_CTLR,DREPLAY_CLT,SNAC_SDK,MDS"
            FeaturesTest = "SQLENGINE,FULLTEXT,IS"
            SetupCredential = $SetupCredential
            UpdateEnabled = "True"
            UpdateSource = "MU"
            InstallSharedDir = "E:\Program Files\Microsoft SQL Server\TXN"
            InstallSharedWOWDir = "C:\Program Files (x86)\Microsoft SQL Server"
            SQLSvcAccount = $SQLCredential
            AgtSvcAccount = $SQLCredential
            ISSvcAccount = $SQLCredential
            SQLSysAdminAccounts = "REISYS\ehrsa-infrastructure","REISYS\HRSA-DBA","EHBSQLSA"
            SecurityMode = "SQL"
            SAPwd = $SACredential
            InstallSQLDataDir = "E:\Program Files\Microsoft SQL Server\TXN"
            InstanceDir = "E:\Program Files\Microsoft SQL Server\TXN"
            SQLUserDBDir = "E:\Program Files\Microsoft SQL Server\TXN\MSSQL11.TXN\MSSQL\DATA"
            SQLUserDBLogDir = "X:\Program Files\Microsoft SQL Server\TXN\MSSQL11.TXN\MSSQL\Data"
            SQLTempDBDir = "W:\Program Files\Microsoft SQL Server\TXN\MSSQL11.TXN\MSSQL\Data"
            SQLTempDBLogDir = "X:\Program Files\Microsoft SQL Server\TXN\MSSQL11.TXN\MSSQL\Data"
            SQLBackupDir = "Z:\Program Files\Microsoft SQL Server\TXN\MSSQL11.TXN\MSSQL\Data"
            SQLCollation = "SQL_Latin1_General_CP1_CI_AS"
            ASCollation = "Latin1_General_CI_AS"
            ErrorReporting = "False"
            SQMReporting = "False"
            #DependsOn = '[xGroup]Administrators','[WindowsFeature]NETNonHTTPActiv'
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

       }
       }
       UTLTXNBUILD -ConfigurationData $test -OutputPath 'Y:\rburke\txn'
#Start-DscConfiguration -Path Y:\rburke\SBX -Wait -Force -Verbose