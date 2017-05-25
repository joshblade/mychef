#
# Cookbook Name:: testehb
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
remote_directory 'd:\ehbeps' do
    source 'https://reidevopsstorage.file.core.windows.net/hrsa/ehbeps'
    action :create
end