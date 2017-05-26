#
# Cookbook Name:: sqlserver
# Recipe:: default
#
# Copyright (C) 2016 YadaYadaSoftware.com
#
# All rights reserved - Do Not Redistribute
#

ssms_file = "#{Chef::Config[:cache_path]}/SSMS-Setup-ENU.exe"

remote_file "#{ssms_file}" do
	source "https://download.microsoft.com/download/9/3/3/933EA6DD-58C5-4B78-8BEC-2DF389C72BE0/SSMS-Setup-ENU.exe"
end

execute 'Install Management Studio' do
	timeout 7200
	command "#{ssms_file} /install /quiet /norestart"
end
