#
# Cookbook Name:: PSModules
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


remote_directory 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\cAssemblyManager' do
    source 'cAssemblyManager'
    action :create
end
remote_directory 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\xReleaseManagement' do
    source 'xReleaseManagement'
    action :create
end
remote_directory 'C:\Program Files\WindowsPowerShell\Modules\xWebAdministration' do
    source 'xWebAdministration'
    action :create
end
remote_directory 'C:\Program Files\WindowsPowerShell\Modules\cSQLServer' do
    source 'cSQLServer'
    action :create
end
remote_directory 'C:\Program Files\WindowsPowerShell\Modules\cWebAdministration' do
    source 'cWebAdministration'
    action :create
end
remote_directory 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSDesiredStateConfiguration\DSCResources\NTFSPermission' do
    source 'NTFSPermission'
    action :create
end
remote_directory 'C:\Program Files\WindowsPowerShell\Modules\PackageManagement' do
    source 'PackageManagement'
    action :create
end
remote_directory 'C:\Program Files\WindowsPowerShell\Modules\PowerShellGet' do
    source 'PowerShellGet'
    action :create
end
remote_directory 'C:\Program Files\WindowsPowerShell\Modules\vNext' do
    source 'vNext'
    action :create
end
remote_directory 'C:\Program Files\WindowsPowerShell\Modules\xPSDesiredStateConfiguration' do
    source 'xPSDesiredStateConfiguration'
    action :create
end
remote_directory 'C:\Program Files\WindowsPowerShell\Modules\xRemoteDesktopAdmin' do
    source 'xRemoteDesktopAdmin'
    action :create
end
remote_directory 'C:\Program Files\WindowsPowerShell\Modules\xSmbShare' do
    source 'xSmbShare'
    action :create
end
remote_directory 'C:\Program Files\WindowsPowerShell\Modules\xSQLServer' do
    source 'xSQLServer'
    action :create
end
remote_directory 'C:\Program Files\WindowsPowerShell\Modules\xTimeZone' do
    source 'xTimeZone'
    action :create
end
remote_directory 'C:\Program Files\WindowsPowerShell\Modules\cIISBaseConfig' do
    source 'cIISBaseConfig'
    action :create
end