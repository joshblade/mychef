#
# Cookbook:: common_installs
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

windows_package '7zip' do
  action :install
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/7z920-x64.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-07-25T06:49:34Z&st=2017-05-24T22:49:34Z&spr=https&sig=8OBSnS7SmSZz2z4UlDXAoGrMqwVMQMN%2FjlwdHARz4BQ%3D'
end

windows_package 'SQLSysClrTypes' do
  action :install
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/ReportViewer2012-SQL-CLR/SQLSysClrTypes.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-07-25T06:49:34Z&st=2017-05-24T22:49:34Z&spr=https&sig=8OBSnS7SmSZz2z4UlDXAoGrMqwVMQMN%2FjlwdHARz4BQ%3D'
end

windows_package 'ReportViewer2012' do
  action :install
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/ReportViewer2012-SQL-CLR/ReportViewer.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-07-25T06:49:34Z&st=2017-05-24T22:49:34Z&spr=https&sig=8OBSnS7SmSZz2z4UlDXAoGrMqwVMQMN%2FjlwdHARz4BQ%3D'
end

windows_package 'SQL2012Dashboard' do
  action :install
  source 'https://reidevopsstorage.file.core.windows.net/ise/prerequisites/SQLServer2012_PerformanceDashboard.msi?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-07-25T06:49:34Z&st=2017-05-24T22:49:34Z&spr=https&sig=8OBSnS7SmSZz2z4UlDXAoGrMqwVMQMN%2FjlwdHARz4BQ%3D'
end



 
 