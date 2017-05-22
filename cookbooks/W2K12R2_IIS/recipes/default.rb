#
# Cookbook Name:: IIS8
# Recipe:: default
#
# Copyright (c) 2014 SCC, All Rights Reserved.
powershell_script 'Install IIS' do
  code 'Add-WindowsFeature Web-Server'
  guard_interpreter :powershell_script
  not_if "(Get-WindowsFeature -Name Web-Server).Installed"
end
 
powershell_script 'Install IIS Management Console' do
  code 'Add-WindowsFeature Web-Mgmt-Console'
  guard_interpreter :powershell_script
  not_if "$MgmtConsoleState = (Get-WindowsFeature Web-Mgmt-Console).InstallState 
		 If ($MgmtConsoleState -eq 'Available')
		 {
		  	 echo $false
		 }
		 Elseif ($MgmtConsoleState -eq 'Installed')
		 {
			 echo $true
		 }"
end
 
service 'w3svc' do
  action [:start, :enable]
end
 
template 'c:\inetpub\wwwroot\Default.htm' do
  source 'index.html.erb'
end