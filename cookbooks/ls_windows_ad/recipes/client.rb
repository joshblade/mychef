#
# Cookbook Name:: ls_windows_ad
# Recipe:: client
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Reboot resource
reboot 'Restart Computer' do
  action :nothing
end

# Join computer to Domain
powershell_script 'Add-Client_AD' do
  code <<-EOH
    $adminpswd = ConvertTo-SecureString '#{node['ls_windows_ad']['admin_pswd']}' -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential ("#{node['ls_windows_ad']['admin_username']}",$adminpswd)
    Add-Computer -DomainName #{node['ls_windows_ad']['domain_name']} -Credential $credential -Force
  EOH
  guard_interpreter :powershell_script
  not_if <<-EOH
    try{
        $domain = ([System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain()).Name
    }
    catch{}
    $domain -eq "#{node['ls_windows_ad']['domain_name']}"
  EOH
  notifies :reboot_now, 'reboot[Restart Computer]', :immediately
end
