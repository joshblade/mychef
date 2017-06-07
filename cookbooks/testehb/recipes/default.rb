#
# Cookbook Name:: testehb
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
directory 'd:\ehbs' do
    action :create
end

directory 'd:\ehbs\appzips' do
    action :create
end

remote_file 'd:\ehbs\appzips\EHBEPS.zip' do
  source 'https://reidevopsstorage.file.core.windows.net/ise/EHBEPS.zip?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-06-19T18:21:10Z&st=2017-06-05T10:21:10Z&spr=https,http&sig=tN1iT4E4yYDwGfXAuv4cykJ08hjR%2B0jU3FE4I5HlQAs%3D'
  action :create
  not_if {::File.exists?('d:\ehbs\appzips\EHBEPS.zip')}
end

windows_zipfile 'd:\ehbs' do
    source 'd:\ehbs\appzips\EHBEPS.zip'
    action :unzip
    not_if {::File.exists?('D:\ehbs\EHBEPS\Version.ini')}
end 