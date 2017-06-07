#
# Cookbook:: ehb-is
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#Depends on common_installs
#Add users and assign to required groups
user "gemsapp" do
  password "#GemsUser1"
end

user "ehbssas" do
  password "#GemsUser1"
end

group "Administrators" do
  action :modify
  members "gemsapp"
  append true
end

group "Administrators" do
  action :modify
  members "ehbssas"
  append true
end

group "Performance Log Users" do
  action :modify
  members "gemsapp"
  append true
end

group "Performance Monitor Users" do
  action :modify
  members "gemsapp"
  append true
end

group "Performance Monitor Users" do
  action :modify
  members "ehbssas"
  append true
end

group "Power Users" do
  action :modify
  members "gemsapp"
  append true
end

group "Power Users" do
  action :modify
  members "ehbssas"
  append true
end

windows_service 'WerSvc' do
  action :stop
  action :configure_startup
  startup_type :disabled
end

#Features

windows_feature 'IIS-WebServerRole' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'FileAndStorage-Services' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Server-Gui-Mgmt-Infra' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Server-Gui-Shell' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'File-Services' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Telnet-Client' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'PowerShellRoot' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'PowerShell' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'PowerShell-V2' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'PowerShell-ISE' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'WAS' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'WinRM-IIS-Ext' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'WoW64-Support' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'FS-FileServer' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Storage-Services' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Server-Media-Foundation' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'RSAT' do
   action :install
   all true
   install_method :windows_feature_powershell
end

windows_feature 'RSAT-Feature-Tools' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Application-Server' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'InkAndHandwritingServices' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'NET-Framework-Features' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'NET-Framework-45-Features' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-Server' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-WebServer' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-Mgmt-Tools' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-Scripting-Tools' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-Health' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'RSAT-SNMP' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'SNMP-Service' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'SMTP-Server' do
   action :install
   all true
   install_method :windows_feature_powershell
end

windows_feature 'Web-Performance' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-Security' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-Asp-Net' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-Asp-Net45' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-Asp' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-Http-Redirect' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-Dir-Browsing' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-Http-Errors' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'DSC-Service' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-Static-Content' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-Common-Http' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-Default-Doc' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-App-Dev' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-Net-Ext' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-Net-Ext45' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-ISAPI-Ext' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-ISAPI-Filter' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'NET-Framework-Core' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'NET-HTTP-Activation' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'NET-Framework-45-Core' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'NET-Framework-45-ASPNET' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'NET-WCF-Services45' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'NET-WCF-HTTP-Activation45' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'NET-WCF-TCP-PortSharing45' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'Web-WHC' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'WDS' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'MSMQ' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'MSMQ-Services' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'MSMQ-Server' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'MSMQ-HTTP-Support' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'MSMQ-Triggers' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'MSMQ-Multicasting' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'MSMQ-Routing' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'MSMQ-DCOM' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'AS-Net-Framework' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'AS-Ent-Services' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'AS-Dist-Transaction' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'AS-Web-Support' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'AS-WAS-Support' do
   action :install
   install_method :windows_feature_powershell
end

windows_feature 'AS-HTTP-Activation' do
   action :install
   install_method :windows_feature_powershell
end
