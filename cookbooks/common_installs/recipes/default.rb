#
# Cookbook:: common_installs
# Recipe:: default
# ?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-06-30T21:46:06Z&st=2017-06-09T13:46:06Z&spr=https,http&sig=QTfCssRRqTvjNNKchvZL4%2BqXlU7uqFZXQILmkQwL3A8%3D
# Copyright:: 2017, The Authors, All Rights Reserved.

remote_file 'D:\ehbs\7z920-x64.msi' do
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/7z920-x64.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-06-30T21:46:06Z&st=2017-06-09T13:46:06Z&spr=https,http&sig=QTfCssRRqTvjNNKchvZL4%2BqXlU7uqFZXQILmkQwL3A8%3D'
  action :create
  not_if {::File.exists?('D:\ehbs\7z920-x64.msi')}
end

windows_package '7zip' do
  action :install
  source '7z920-x64.msi'
  not_if {::File.exists?('C:\Program Files\7-Zip\7z.exe')}
end

##############################################################

remote_file 'D:\ehbs\SQLSysClrTypes.msi' do
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/ReportViewer2012-SQL-CLR/SQLSysClrTypes.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-06-30T21:46:06Z&st=2017-06-09T13:46:06Z&spr=https,http&sig=QTfCssRRqTvjNNKchvZL4%2BqXlU7uqFZXQILmkQwL3A8%3D'
  action :create
  not_if {::File.exists?('D:\ehbs\SQLSysClrTypes.msi')}
end

windows_package 'SQLSysClrTypes' do
  action :install
  source 'D:\ehbs\SQLSysClrTypes.msi'
  not_if {::File.exists?('C:\Program Files\Microsoft SQL Server\110\KeyFile\1033\sqlsysclrtypes_keyfile.dll')}
end

##############################################################

remote_file 'D:\ehbs\ReportViewer.msi' do
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/ReportViewer2012-SQL-CLR/ReportViewer.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-06-30T21:46:06Z&st=2017-06-09T13:46:06Z&spr=https,http&sig=QTfCssRRqTvjNNKchvZL4%2BqXlU7uqFZXQILmkQwL3A8%3D'
  action :create
  not_if {::File.exists?('D:\ehbs\ReportViewer.msi')}
end

windows_package 'ReportViewer2012' do
  action :install
  source 'D:\ehbs\ReportViewer.msi'
  not_if {::File.exists?('C:\Program Files (x86)\Microsoft SDKs\Windows\v8.0A\Bootstrapper\Packages\ReportViewer\product.xml')}
end

##############################################################

remote_file 'D:\ehbs\SQLServer2012_PerformanceDashboard.msi' do
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/SQLServer2012_PerformanceDashboard.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-06-30T21:46:06Z&st=2017-06-09T13:46:06Z&spr=https,http&sig=QTfCssRRqTvjNNKchvZL4%2BqXlU7uqFZXQILmkQwL3A8%3D'
  action :create
  not_if {::File.exists?('D:\ehbs\SQLServer2012_PerformanceDashboard.msi')}
end

windows_package 'SQL2012Dashboard' do
  action :install
  source 'D:\ehbs\SQLServer2012_PerformanceDashboard.msi'
  not_if {::File.exists?('C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Performance Dashboard\setup.sql')}
end

##############################################################

remote_file 'D:\ehbs\msxml6_x64.msi' do
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/msxml6_x64.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-06-30T21:46:06Z&st=2017-06-09T13:46:06Z&spr=https,http&sig=QTfCssRRqTvjNNKchvZL4%2BqXlU7uqFZXQILmkQwL3A8%3D'
  action :create
  not_if {::File.exists?('D:\ehbs\msxml6_x64.msi')}
end

windows_package 'MSXML6' do
  action :install
  source 'D:\ehbs\msxml6_x64.msi'
  #not_if {::File.exists?('C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Performance Dashboard\setup.sql')}
end

##############################################################

remote_file 'D:\ehbs\sqlxml_x64.msi' do
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/sqlxml_x64.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-06-30T21:46:06Z&st=2017-06-09T13:46:06Z&spr=https,http&sig=QTfCssRRqTvjNNKchvZL4%2BqXlU7uqFZXQILmkQwL3A8%3D'
  action :create
  not_if {::File.exists?('D:\ehbs\sqlxml_x64.msi')}
end

windows_package 'SQLXML64' do
  action :install
  source 'D:\ehbs\sqlxml_x64.msi'
  #not_if {::File.exists?('C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Performance Dashboard\setup.sql')}
end

##############################################################

remote_file 'D:\ehbs\SQLServer2005_ASOLEDB9_x64.msi' do
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/SQLServer2005_ASOLEDB9_x64.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-06-30T21:46:06Z&st=2017-06-09T13:46:06Z&spr=https,http&sig=QTfCssRRqTvjNNKchvZL4%2BqXlU7uqFZXQILmkQwL3A8%3D'
  action :create
  not_if {::File.exists?('D:\ehbs\SQLServer2005_ASOLEDB9_x64.msi')}
end

windows_package 'SQLServer2005_ASOLEDB9_x64' do
  action :install
  source 'D:\ehbs\SQLServer2005_ASOLEDB9_x64.msi'
  #not_if {::File.exists?('C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Performance Dashboard\setup.sql')}
end

##############################################################

remote_file 'D:\ehbs\SQL_AS_ADOMD.msi' do
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/SQL_AS_ADOMD.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-06-30T21:46:06Z&st=2017-06-09T13:46:06Z&spr=https,http&sig=QTfCssRRqTvjNNKchvZL4%2BqXlU7uqFZXQILmkQwL3A8%3D'
  action :create
  not_if {::File.exists?('D:\ehbs\SQL_AS_ADOMD.msi')}
end

windows_package 'SQL_AS_ADOMD' do
  action :install
  source 'D:\ehbs\SQL_AS_ADOMD.msi'
  #not_if {::File.exists?('C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Performance Dashboard\setup.sql')}
end

##############################################################

remote_file 'D:\ehbs\SQL_AS_OLEDB.msi' do
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/SQL_AS_OLEDB.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-06-30T21:46:06Z&st=2017-06-09T13:46:06Z&spr=https,http&sig=QTfCssRRqTvjNNKchvZL4%2BqXlU7uqFZXQILmkQwL3A8%3D'
  action :create
  not_if {::File.exists?('D:\ehbs\SQL_AS_OLEDB.msi')}
end

windows_package 'SQL_AS_OLEDB' do
  action :install
  source 'D:\ehbs\SQL_AS_OLEDB.msi'
  #not_if {::File.exists?('C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Performance Dashboard\setup.sql')}
end

##############################################################

remote_file 'D:\ehbs\ASPAJAXExtSetup.msi' do
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/ASPAJAXExtSetup.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-06-30T21:46:06Z&st=2017-06-09T13:46:06Z&spr=https,http&sig=QTfCssRRqTvjNNKchvZL4%2BqXlU7uqFZXQILmkQwL3A8%3D'
  action :create
  not_if {::File.exists?('D:\ehbs\ASPAJAXExtSetup.msi')}
end

windows_package 'ASPAJAXExt' do
  action :install
  source 'D:\ehbs\ASPAJAXExtSetup.msi'
  #not_if {::File.exists?('C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Performance Dashboard\setup.sql')}
end

##############################################################

remote_file 'D:\ehbs\AccessDatabaseEngine_x64.exe' do
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/AccessDatabaseEngine_x64.exe?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-06-30T21:46:06Z&st=2017-06-09T13:46:06Z&spr=https,http&sig=QTfCssRRqTvjNNKchvZL4%2BqXlU7uqFZXQILmkQwL3A8%3D'
  action :create
  not_if {::File.exists?('D:\ehbs\AccessDatabaseEngine_x64.exe')}
end


execute 'AccessDatabaseEngineInstall' do
  command 'D:\ehbs\AccessDatabaseEngine_x64.exe /quiet'
end
#windows_package 'AccessDatabaseEngine64' do
#  action :install
#  source 'D:\ehbs\AccessDatabaseEngine_x64.exe'
  #not_if {::File.exists?('C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Performance Dashboard\setup.sql')}
#  options '/verysilent'
#end

##############################################################

remote_file 'D:\ehbs\owc11.exe' do
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/owc11.exe?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-06-30T21:46:06Z&st=2017-06-09T13:46:06Z&spr=https,http&sig=QTfCssRRqTvjNNKchvZL4%2BqXlU7uqFZXQILmkQwL3A8%3D'
  action :create
  not_if {::File.exists?('D:\ehbs\owc11.exe')}
end


execute 'owc11Install' do
  command 'D:\ehbs\owc11.exe /quiet'
end
#windows_package 'owc11' do
#  action :install
#  source 'D:\ehbs\owc11.exe'
#  #not_if {::File.exists?('C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Performance Dashboard\setup.sql')}
#  installer_type :custom
#  options '/quiet'
#end

##############################################################

remote_file 'D:\ehbs\ReportViewer2008SP1.exe' do
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/ReportViewer2008SP1.exe?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-06-30T21:46:06Z&st=2017-06-09T13:46:06Z&spr=https,http&sig=QTfCssRRqTvjNNKchvZL4%2BqXlU7uqFZXQILmkQwL3A8%3D'
  action :create
  not_if {::File.exists?('D:\ehbs\ReportViewer2008SP1.exe')}
end


execute 'ReportViewer2008SP1Install' do
  command 'D:\ehbs\ReportViewer2008SP1.exe /q'
end

##############################################################

remote_file 'D:\ehbs\MicrosoftWSE20SP3Runtime.msi' do
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/MicrosoftWSE20SP3Runtime.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-06-30T21:46:06Z&st=2017-06-09T13:46:06Z&spr=https,http&sig=QTfCssRRqTvjNNKchvZL4%2BqXlU7uqFZXQILmkQwL3A8%3D'
  action :create
  not_if {::File.exists?('D:\ehbs\MicrosoftWSE20SP3Runtime.msi')}
end



execute 'WSE20SP3Install' do
  command 'D:\ehbs\MicrosoftWSE20SP3Runtime.msi /quiet'
end

#windows_package 'WSE20SP3' do
#  action :install
#  source 'D:\ehbs\MicrosoftWSE20SP3Runtime.msi'
#  #not_if {::File.exists?('C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Performance Dashboard\setup.sql')}
#end

##############################################################

remote_file 'D:\ehbs\WSE-30.msi' do
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/WSE-30.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-06-30T21:46:06Z&st=2017-06-09T13:46:06Z&spr=https,http&sig=QTfCssRRqTvjNNKchvZL4%2BqXlU7uqFZXQILmkQwL3A8%3D'
  action :create
  not_if {::File.exists?('D:\ehbs\WSE-30.msi')}
end

execute 'WSE30Install' do
  command 'D:\ehbs\WSE-30.msi /quiet'
end
#windows_package 'WSE30' do
#  action :install
#  source 'D:\ehbs\WSE-30.msi /quiet'
  #not_if {::File.exists?('C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Performance Dashboard\setup.sql')}
#end

##############################################################