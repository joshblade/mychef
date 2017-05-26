#
# Cookbook Name:: testehb
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

windows_zipfile 'ehbeps' do
    source 'https://reidevopsstorage.file.core.windows.net/ise/EHBEPS.zip?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-07-25T06:49:34Z&st=2017-05-24T22:49:34Z&spr=https&sig=8OBSnS7SmSZz2z4UlDXAoGrMqwVMQMN%2FjlwdHARz4BQ%3D'
    action :unzip
    destination 'D:'
end