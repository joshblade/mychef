$test = @{ 
                 AllNodes = @(        
                              @{     
                                 NodeName = "localhost" 
                                 # Allows credential to be saved in plain-text in the the *.mof instance document.                             
                                    PSDscAllowPlainTextPassword = $true
                                    PSDscAllowDomainUser = $true
                                    <#GemsAppPassword = "#GemsUser1"
                                    EHBSSASPassword = "#GemsUser1"
                                    EHBSQLSAPassword = "#GemsUser1"
                                    SQLSAPassword = "#GemsUser1"
                                    eisuserPassword = "#GemsUser1"#>
                                
                              } 
                            )  
              } 

   Configuration UatDBConfig{
   
  <# param (
[pscredential]$credential,
[pscredential]$SSASCredential,
[pscredential]$verifyCredential

)                            

$EISCredential = (Get-Credential -UserName 'eisuser' -Message 'eisuser')                           
$Gemsappcredential = (Get-Credential -UserName "gemsapp" -Message 'Enter gemsapp password')
$SetupCredential=(Get-Credential -UserName "reisys\robert.burke" -Message "SetupUser")
$credential = (Get-Credential -UserName "gemsapp" -Message 'Enter gemsapp password')
$SSASCredential = (Get-Credential -UserName "ehbssas" -Message 'Enter EHBSSAS password')
$verifyCredential = (Get-Credential -UserName "reisys\robert.burke" )
$SQLCredential = (Get-Credential -UserName "ehbsqlsa" -Message "Enter ehbsqlsa password")#SQLSVCACCOUNT="ehbsqlsa" SQLSVCPASSWORD="#Gems1User"
$SACredential = (Get-Credential -UserName "sa" -Message "sa")#>
#GemsUser1
$verifyCredential = (Get-Credential -UserName "" -message "Enter your domain account reisys\yourID" )
$SetupCredential=(Get-Credential -UserName "reisys\robert.burke" -Message "SetupUser")
$SQLCredential = (Get-Credential -UserName "ehbsqlsa" -Message "Enter ehbsqlsa password")#SQLSVCACCOUNT="ehbsqlsa" SQLSVCPASSWORD="#Gems1User"
$SACredential = (Get-Credential -UserName "sa" -Message "sa")
    import-DscResource -ModuleName "cIISBaseConfig" 
    Import-DscResource -ModuleName "cWebAdministration" 
    Import-DscResource -ModuleName "xWebAdministration" 
    Import-DscResource -ModuleName "xSMBShare"
    Import-DscResource -ModuleName "xTimeZone"
    Import-DscResource -ModuleName "xRemoteDesktopAdmin"
    Import-DscResource -ModuleName "xSQLServer"
    Import-DscResource -ModuleName "cSQLServer"
    Import-DscResource -ModuleName "PSDesiredStateConfiguration"
    Import-DscResource -ModuleName "xPSDesiredStateConfiguration"

     Node "localhost"
     #$AllNodes.Where{$_.Config -eq "DB"}.NodeName
    {
    #################All Systems OS
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
       User ehbsqlsa 
       {
            Ensure = 'Present'
            UserName = 'ehbsqlsa'
            Password = (Get-Credential -UserName 'ehbsqlsa' -Message 'ehbsqlsa')
            FullName = 'ehbsqlsa'
            PasswordNeverExpires = $true
       }
       #OS
####################Group Setup
       xGroup Administrators
       { 
       Ensure = 'Present'
       GroupName = 'Administrators'
       MembersToInclude = 'ehbsqlsa','gemsapp','ehbssas','reisys\ehrsa-cm', 'reisys\hrsa-dba'
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
            xService WERDisabled
            {
            Name = "WerSvc"
            DisPlayName = "Windows Error Reporting Service"
            Startuptype = "Disabled"
            State = "Stopped"
            }
#############################Package Installs
        Package o2010pia
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs\ISE\Prerequisites\o2010pia.msi"
            Name = "Microsoft Office 2010 Primary Interop Assemblies"
            ProductId = "90140000-1146-0000-0000-0000000FF1CE"
        }
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
        <#
        Package MSXML4
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs\ISE\Prerequisites\msxml_SP3.msi"
            Name = "MSXML 4.0 SP3 Parser"
            ProductId = "196467F1-C11F-4F76-858B-5812ADC83B94"
        }
        #>
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
            InstallSharedDir = "C:\Program Files\Microsoft SQL Server"
            InstallSharedWOWDir = "C:\Program Files (x86)\Microsoft SQL Server"
            SQLSvcAccount = $SQLCredential
            AgtSvcAccount = $SQLCredential
            ISSvcAccount = $SQLCredential
            SQLSysAdminAccounts = "REISYS\ehrsa-infrastructure","REISYS\HRSA-DBA","EHBSQLSA"
            SecurityMode = "SQL"
            SAPwd = $SACredential
            InstallSQLDataDir = "E:\Program Files\Microsoft SQL Server\TXN"
            InstanceDir = "E:\Program Files\Microsoft SQL Server\TXN"
            SQLCollation = "SQL_Latin1_General_CP1_CI_AS"
            ASCollation = "Latin1_General_CI_AS"
            ErrorReporting = "False"
            SQMReporting = "False"
            #DependsOn = '[xGroup]Administrators','[WindowsFeature]NETNonHTTPActiv'
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
            ASSysAdminAccounts = "REISYS\ehrsa-infrastructure","REISYS\HRSA-DBA","EHBSQLSA"
            SQLCollation = "SQL_Latin1_General_CP1_CI_AS"
            ASCollation = "Latin1_General_CI_AS"
            ErrorReporting = "False"
            SQMReporting = "False"
            #DependsOn = '[cSQLServerSetup]TXN'

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

       }
       }
       UatDBConfig -ConfigurationData $test -OutputPath 'Y:\rburke\DB'
#Start-DscConfiguration -Path Y:\rburke\DB -Wait -Force -Verbose