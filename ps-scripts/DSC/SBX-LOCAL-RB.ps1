<# Instructions for script use
Copy the required modules from: \\hrsafs.reisys.com\ise\_RB\requiredDSCModules to C:\Program Files\WindowsPowerShell\Modules on the system you are going to build
This is required because we have modified some of the modules

Please copy \\hrsafs.reisys.com\ise\Tools\Powershell-5-Prod-Release\Win8.1AndW2K12R2-KB3066437-x64.msu to local desktop and install

Prior to executing the script please change the domain user ID to YOUR ID, currently it is reisys\robert.burke, ensure it is changed to your id
When you execute the script you will be propted for a password several times, the password (except for your domain id) is #GemsUser1
Copy-Item -Path "\\hrsafs.reisys.com\ise\_RB\requiredDSCModules" -Recurse -Container "C:\Program Files\WindowsPowerShell\Modules"
Unblock-File -Path "C:\Program Files\WindowsPowerShell\Modules"

Description: This script will generate a MOF file for use on SBX servers


#>


$test = @{ 
                 AllNodes = @(        
                              @{     
                                 NodeName = "localhost" 
                                 # Allows credential to be saved in plain-text in the the *.mof instance document.                             
                                 PSDscAllowPlainTextPassword = $true
                                 PSDscAllowDomainUser = $true

                                 GemsAppPassword = "#GemsUser1"
                                 EHBSSASPassword = "#GemsUser1"
                                 EHBSQLSAPassword = "#GemsUser1"
                                 SQLSAPassword = "#GemsUser1"
                                 eisuserPassword = "#GemsUser1"
                                
                              } 
                            )  
              } 


############# OS CONFIG #############

Configuration SBXALL{

                           

#$EISCredentail = (Get-Credential -UserName 'eisuser' -Message 'eisuser')                           
#$Gemsappcredential = (Get-Credential -UserName "gemsapp" -Message 'Enter gemsapp password')
$credential = (Get-Credential -UserName "gemsapp" -Message 'Enter gemsapp password')
$SSASCredential = (Get-Credential -UserName "EHBSSAS" -Message 'Enter EHBSSAS password')
$SQLCredential = (Get-Credential -UserName "ehbsqlsa" -Message "Enter ehbsqlsa password")#SQLSVCACCOUNT="ehbsqlsa" SQLSVCPASSWORD="#Gems1User"
$SACredential = (Get-Credential -UserName "sa" -Message "sa")
$SetupCredential=(Get-Credential -UserName "amer\robert.burke" -Message "SetupUser")
$verifyCredential = (Get-Credential -UserName "amer\robert.burke" -Message "Enter your domain user ID" )
    #GemsUser1
    #JesusIsLord3
    #M0r3me@!rei
    Import-DscResource -ModuleName "xPSDesiredStateConfiguration"
    Import-DscResource -ModuleName "cSQLServer" 
    Import-DscResource -ModuleName "cIISBaseConfig" 
    Import-DscResource -ModuleName "cWebAdministration"   
    Import-DscResource -ModuleName "xWebAdministration" 
    Import-DscResource -ModuleName "xSMBShare"
    Import-DscResource -ModuleName "xsqlserver"
    Import-DscResource -ModuleName "xTimeZone"
    Import-DscResource -ModuleName "xRemoteDesktopAdmin"
    Import-DscResource –ModuleName "PSDesiredStateConfiguration"
    #Import-DscResource -ModuleName "NTFSSecurity"
    #Import-DscResource -ModuleName @{ModuleName="NTFSSecurity";requiredversion="4.2.3"}

    
    node "Localhost"{
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
        #OS
        User eisuser
       {
            Ensure = 'Present'
            UserName = 'eisuser'
            Password = (Get-Credential -UserName 'eisuser' -Message 'eisuser')
            FullName = 'eisuser'
            PasswordNeverExpires = $true
            }
        #OS
        User bsvaspnet
       {
            Ensure = 'Present'
            UserName = 'bsvaspnet'
            Password = $credential
            FullName = 'bsvaspnet'
            PasswordNeverExpires = $true
       }
        #OS
       User gemsapp 
       {
            Ensure = 'Present'
            UserName = 'gemsapp'
            Password = $credential
            FullName = 'GemsApp'
            PasswordNeverExpires = $true
       }
       #OS
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
       Group Administrators
       { 
       Ensure = 'Present'
       GroupName = 'Administrators'
       MembersToInclude = 'gemsapp','ehbssas','ehbsqlsa','reisys\tfs_user', 'amer\svc_tfsuser','amer\sg_devops'
       DependsOn = '[User]gemsapp','[User]ehbssas'
       Credential = $verifyCredential
       }
       #OS
       Group PerformanceLogUsers
       {
       Ensure = "Present"
       GroupName = "Performance Log Users"
       MembersToInclude = 'gemsapp','ehbsqlsa'
       DependsOn = '[User]gemsapp'
       }
        #OS
       Group PerformanceMonitorUsers
       {
       Ensure = "Present"
       GroupName = "Performance Monitor Users"
       MembersToInclude = 'gemsapp','ehbsqlsa'
       DependsOn = '[User]gemsapp'
       }
       Group PowerUserUsers
       {
       Ensure = "Present"
       GroupName = "Power Users"
       MembersToInclude = 'gemsapp', 'ehbsqlsa'
       DependsOn = '[User]gemsapp'
       }
       
       
       ###############Windows Features

       WindowsFeature NETFW35    
       {       
            Ensure = “Present” 
            Name = "NET-Framework-Features"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
            
       }
       WindowsFeature InkAndHandwritingServices
       {
            Ensure = “Present” 
            Name = "InkAndHandwritingServices"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature Server-Media-Foundation
       {
            Ensure = “Present” 
            Name = "Server-Media-Foundation"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature NETFW45     
       {       
            Ensure = “Present” 
            Name = "NET-Framework-45-Features"
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
       WindowsFeature ServerGuiMgmtInfra     
       {       
            Ensure = “Present” 
            Name = "Server-Gui-Mgmt-Infra"
       }
       WindowsFeature ServerGuiShell    
       {       
            Ensure = “Present” 
            Name = "Server-Gui-Shell"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
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
       WindowsFeature WinRMIISExt   
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
  ################WEB CONFIG#################
       WindowsFeature NETFW45HTTPActivation     
       {       
            Ensure = “Present” 
            Name = "NET-WCF-HTTP-Activation45"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature WebODBCLogging
       {
            Ensure = “Present” 
            Name = "Web-ODBC-Logging"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       } 
       WindowsFeature WebHTTPLogging
       {
            Ensure = “Present” 
            Name = "Web-HTTP-Logging"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       } 
       WindowsFeature WebLogLibraries
       {
            Ensure = “Present” 
            Name = "Web-Log-Libraries"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
        WindowsFeature NETFW35HTTPActivation    
       {       
            Ensure = “Present” 
            Name = "NET-HTTP-Activation"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature WebStaticContent    
       {       
            Ensure = “Present” 
            Name = "Web-Static-Content"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature WebHttpErrors    
       {       
            Ensure = “Present” 
            Name = "Web-Http-Errors"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       #######Install the IIS Role     
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
            #IncludeAllSubFeature = $true
                 
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
        WindowsFeature WebCommonHttp    
        {       
            Ensure = “Present”       
            Name = “Web-Common-Http”     
        }
        WindowsFeature IISMgmtService     
        {       
            Ensure = “Present”       
            Name = “Web-Mgmt-Service”
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
        WindowsFeature WDSAdminPack     
        {       
            Ensure = “Present”       
            Name = “WDS-AdminPack”
         
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
        WindowsFeature RSATSNMP     
        {       
            Ensure = “Present”       
            Name = “RSAT-SNMP”
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
        }
        WindowsFeature WebAppDev    
        {       
            Ensure = “Present”       
            Name = “Web-App-Dev”     
        }

        WindowsFeature WebNetExt    
        {       
            Ensure = “Present”       
            Name = “Web-Net-Ext”     
        }
        WindowsFeature WebNetExt45    
        {       
            Ensure = “Present”       
            Name = “Web-Net-Ext45”     
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
        WindowsFeature NETFrameworkCore    
        {       
            Ensure = “Present”       
            Name = “NET-Framework-Core”
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
        
        WindowsFeature WebWHC   
        {       
            Ensure = “Present”       
            Name = “Web-WHC”
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"     
        }
        WindowsFeature FSSMB1   
        {       
            Ensure = “Present”       
            Name = “FS-SMB1”
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"     
        }
        ##########Application Server
        WindowsFeature ApplicationServer
       {
            Ensure = “Present” 
            Name = "Application-Server"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature ASIncomingTrans
       {
            Ensure = “Present” 
            Name = "AS-Incoming-Trans"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
            IncludeAllSubFeature = $true
       }
       WindowsFeature ASOutgoingTrans
       {
            Ensure = “Present” 
            Name = "AS-Outgoing-Trans"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
            IncludeAllSubFeature = $true
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
       WindowsFeature ASTCPPortSharing
       {
            Ensure = “Present” 
            Name = "AS-TCP-Port-Sharing"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
            IncludeAllSubFeature = $true
       }
       WindowsFeature ASWASSupport
       {
            Ensure = “Present” 
            Name = "AS-WAS-Support"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature ASWebSupport
       {
            Ensure = “Present” 
            Name = "AS-Web-Support"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature ASNamedPipes
       {
            Ensure = “Present” 
            Name = "AS-Named-Pipes"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
       }
       WindowsFeature ASTCPActivation
       {
            Ensure = “Present” 
            Name = "AS-TCP-Activation"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
         WindowsFeature ASHTTPActivation
       {
            Ensure = “Present” 
            Name = "AS-HTTP-Activation"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
        WindowsFeature FSFileServer
        {
            Ensure = “Present” 
            Name = "FS-FileServer"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
        WindowsFeature NETNonHTTPActiv    
        {       
            Ensure = “Present” 
            Name = "NET-Non-HTTP-Activ"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
            
        }
        WindowsFeature NETWCFPipeActivation45     
        {       
            Ensure = “Present” 
            Name = "NET-WCF-Pipe-Activation45"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
        WindowsFeature NETWCFTCPActivation45     
        {       
            Ensure = “Present” 
            Name = "NET-WCF-TCP-Activation45"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
        WindowsFeature NETWCFTCPPortSharing45     
        {       
            Ensure = “Present” 
            Name = "NET-WCF-TCP-PortSharing45"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
        WindowsFeature SNMP     
        {       
            Ensure = “Present” 
            Name = "SNMP-Service"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
            IncludeAllSubFeature = $true
        }
        
        WindowsFeature TelnetClient     
        {       
            Ensure = “Present” 
            Name = "Telnet-Client"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
            IncludeAllSubFeature = $true

        }
        WindowsFeature WDS
        {
            Ensure = "Present"
            Name = "WDS"
        }
        WindowsFeature WSFC
        {
            Ensure = "Present"
            Name = "Failover-Clustering"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
        WindowsFeature RSATClustering
        {
            Ensure = "Present"
            Name = "RSAT-Clustering"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        } 
        
        WindowsFeature WebWMI
        {
            Ensure = "Present"
            Name = "Web-WMI"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
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
        WindowsFeature WebLgcyScripting
        {
            Ensure = "Present"
            Name = "Web-Lgcy-Scripting"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
        
        WindowsFeature WebDefaultDoc
        {
            Ensure = "Present"
            Name = "Web-Default-Doc"
            Source = "\\hrsafs.reisys.com\ise\2012r2_Source\sxs"
        }
        ##########Software Installs 
        script SBXremoteDebug 
        {
         Setscript ={
         $rdebug = "\\hrsafs.reisys.com\ISE\_BD\rtools_setup_x64.exe /quiet /norestart"
         Invoke-expression ("$rdebug")
        }
         TestScript = "Test-Path -path 'C:\Program Files\Microsoft Visual Studio 12.0\Remote Tools\DiagnosticsHub/VsStandardCollector.exe'"
         Getscript = {@(pathtest = (Test-Path -Path "C:\Program Files\Microsoft Visual Studio 12.0\Remote Tools\DiagnosticsHub\VsStandardCollector.exe"))}
         
        } 
        package SQLSysClrTypes 
         {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs.reisys.com\ise\Prerequisites\SQL2012-SysCLRTypes\SQLSysClrTypes.msi"
            Name = "Microsoft System CLR Types for SQL Server 2012 (x64)"
            ProductId = "F1949145-EB64-4DE7-9D81-E6D27937146C"
         }  

        package ReportViewer2012 
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs.reisys.com\ise\Prerequisites\ReportViewer2012\ReportViewer.msi"
            Name = "Microsoft Report Viewer 2012 Runtime"
            ProductId = "C58378BC-0B7B-474E-855C-9D02E5E75D71"
         }                 
        Package 7zip
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs.reisys.com\ISE\Prerequisites\7z920-x64.msi"
            Name = "7-Zip 9.20 (x64 edition)"
            ProductId = "23170F69-40C1-2702-0920-000001000000"
        }
        Package SQL2012Dashboard
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "\\hrsafs.reisys.com\ISE\Prerequisites\SQLServer2012_PerformanceDashboard.msi"
            Name = "Microsoft SQL Server 2012 Performance Dashboard Reports"
            ProductId = "99A0A13E-3B9E-45D0-B933-031ED7CE26DB"
        }
        
        Package o2010pia
        {
        Ensure = "Present"  # You can also set Ensure to "Absent"
        Path  = "\\hrsafs.reisys.com\ISE\Prerequisites\o2010pia.msi"
        Name = "Microsoft Office 2010 Primary Interop Assemblies"
        ProductId = "90140000-1146-0000-0000-0000000FF1CE"
        }
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
            Arguments = '/q"'
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
        File DownloadedFiles
        {
            Ensure = 'Present'
            DestinationPath = 'y:\DownloadedFiles'
            Type = 'Directory'
        }
        File GrantsGov
        {
            Ensure = 'Present'
            DestinationPath = 'y:\DownloadedFiles\Grants.gov'
            Type = 'Directory'
        }
        File GrantsGovZip
        {
            Ensure = 'Present'
            DestinationPath = 'Y:\DownloadedFiles\Grants.gov\Zip'
            Type = 'Directory'
        }
        File GrantsGovUnZip
        {
            Ensure = 'Present'
            DestinationPath = 'Y:\DownloadedFiles\Grants.gov\Unzipped'
            Type = 'Directory'
        }
        File PrivateRoot
        {
            Ensure = 'Present'
            DestinationPath = 'Y:\Privateroot'
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
        File PrivateRootconfigHistory
        {
            Ensure = 'Present'
            DestinationPath = 'Y:\Privateroot\configHistory'
            Type = 'Directory'
        }
        File LogFilesW3CSVC
        {
            Ensure = 'Present'
            DestinationPath = 'Y:\Privateroot\LogFiles\W3CSVC'
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

        File UploadedFiles
        {
            Ensure = 'Present'
            DestinationPath = 'Y:\UploadedFiles'
            Type = 'Directory'
        }
        File LogFiles
        {
            Ensure = 'Present'
            DestinationPath = 'Y:\Privateroot\Logfiles'
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
            Rights = "FullControl"
       }

        NTFSPermission everyoneprivateroot{
            Account = "everyone"
            Path = "y:\privateroot"
            Access = "Allow"
            Ensure = "Present"
            Rights = "FullControl"
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
        NTFSPermission usersUploadedFiles{
            Account = "users"
            Path = "Y:\UploadedFiles"
            Access = "Allow"
            Ensure = "Present"
            Rights = "Modify"
       }
        NTFSPermission UsersDownloadedFiles{
            Account = "users"
            Path = "Y:\DownloadedFiles"
            Access = "Allow"
            Ensure = "Present"
            Rights = "Modify"
       }

       ###############Permissions
        xSmbShare DownloadedFiles{
            Ensure = "Present" #Or absent to remove
            Name = "DownloadedFiles" #Sharename
            Path = "Y:\DownloadedFiles" #Physical Path
            ChangeAccess = "Everyone"
            #ReadAccess = "User"
            #FullAccess = "User"
            Description = "File share located on file server normally"
       }
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
        xSmbShare UploadedFiles{
            Ensure = "Present" #Or absent to remove
            Name = "UploadedFiles" #Sharename
            Path = "Y:\UploadedFiles" #Physical Path
            ChangeAccess = "Everyone"
            #ReadAccess = "Everyone"
            #FullAccess = "User"
            Description = "File share located on file server normally"
       }
        ##########SQL CONFIG
        cSQLServerSetup TXN
        {
            InstanceName = "TXN"
            InstanceID = "TXN"
            SourcePath = "\\hsa-ods-int.reisys.com\SQL"
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
            SQLSysAdminAccounts = "amer\sg_devops","EHBSQLSA","amer\ehrsa-cm","amer\ehrsa-infrastructure"
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
            SourcePath = "\\hsa-ods-int.reisys.com\SQL"
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
            ASSysAdminAccounts = "amer\sg_devops","EHBSQLSA","amer\ehrsa-cm","amer\ehrsa-infrastructure"
            SQLCollation = "SQL_Latin1_General_CP1_CI_AS"
            ASCollation = "Latin1_General_CI_AS"
            ErrorReporting = "False"
            SQMReporting = "False"
            #DependsOn = '[cSQLServerSetup]TXN'

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
#########IIS Default Settings   
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
        <#
        cAppHostKeyValue isapiCgiRestrictionnotListedIsapisAllowed
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/security/isapiCgiRestriction"
            Key = "notListedIsapisAllowed"
            Value = "false"
            IsAttribute = $true
        }
        #>

        cAppHostKeyValue allowUnlisted
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/security/ipSecurity"
            Key = "allowUnlisted"
            Value = "true"
            IsAttribute = $true
        }
        
        cAppHostKeyValue notListedIsapisAllowed
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "system.webserver/security/isapiCgiRestriction"
            Key = "notListedIsapisAllowed"
            Value = "false"
            IsAttribute = $true
        }

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
         TestScript = {return (Get-WebConfigurationproperty -filter system.applicationHost/sites/site/application/virtualDirectory -Name "physicalPath").value -contains "Y:\root"}
         Getscript = {return @(pathtest = (Get-WebConfigurationproperty -filter system.applicationHost/sites/site/application/virtualDirectory -Name "physicalPath").value -eq "Y:\root")}
         }
         Script F5XForwardedFor
        {
         Setscript = {Add-WebConfiguration -PSPath "MACHINE/WEBROOT/APPHOST" -Filter /system.webServer/isapiFilters -Value @{name = 'F5XForwardedFor';path = 'Y:\F5XForwardedFor\F5XForwardedFor.dll'}}
         TestScript = {return (Get-WebConfigurationproperty -PSPath "MACHINE/WEBROOT/APPHOST" -Filter /system.webServer/isapiFilters/filter -Name name).value -contains 'F5XForwardedFor' }
         Getscript = {return @(isapifiltertest = (Get-WebConfigurationproperty -PSPath "MACHINE/WEBROOT/APPHOST" -Filter /system.webServer/isapiFilters/filter -Name name).value -contains 'F5XForwardedFor')}
         DependsOn = '[File]F5XForwardedFor'
        }
        <#
        Script windowsAuthenticationoverrideMode
        {
         Setscript = {Set-WebConfigurationProperty -filter system.webserver/security/authentication/windowsAuthentication -metadata overrideMode -Value "Allow"}
         TestScript = {return (Get-WebConfiguration -filter system.webserver/security/authentication/windowsAuthentication) -ieq "Y:\root" }
         Getscript = {return @(pathtest = (Get-WebConfiguration -filter system.webserver/security/authentication/windowsAuthentication) -ieq "Y:\root")}
         
        }
        #>
        
         
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
                               CertificateThumbprint = "f18c2abce193e91abc4f5ac97cd85b9183a58ebf"
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
                                     
        
        
        
       ############ENV
       Environment REIConfigLocationHRSA
        {
         Ensure = "Present"
         Name = "REIConfigLocationHRSA"
         Value = "\\New-HRSABuild.reisys.com\ConfigurationData"
         #Prod Value = "\\GEMSFS1\ConfigurationData"
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
        
         xService WERDisabled
        {
        Name = "WerSvc"
        DisPlayName = "Windows Error Reporting Service"
        Startuptype = "DisAbled"
        State = "Stopped"

        } 
         
        xService remoteDebug
        {
        Name = "msvsmon120"
        DisPlayName = "Remote Debugger"
        Startuptype = "Automatic"
        State = "Running"

        } 

        xService SMTP 
        {
        Ensure = "Present"
        Name = "SMTPSVC"
        StartupType = "Automatic"
        State = "Running"
        }
                           
        }
    }
    


   
SBXALL -ConfigurationData $test -OutputPath 'D:\rburke\sbx'
#Start-DscConfiguration -Path D:\rburke\sbx -Wait -Force -Verbose