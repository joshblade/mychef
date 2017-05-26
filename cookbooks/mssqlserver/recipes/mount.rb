#
# Cookbook Name:: sqlserver
# Recipe:: default
#
# Copyright (C) 2016 YadaYadaSoftware.com
#
# All rights reserved - Do Not Redistribute
#
#include_recipe 'ms_dotnet35'
include_recipe 'ec2helper'

remote_file "#{node[:sqlserver][:remote_file_path]}/#{node[:sqlserver][:iso_name]}" do
	source "#{node[:sqlserver][:remote_file_source]}"
	checksum "#{node[:sqlserver][:iso_checksum]}"
	not_if { File.exist?("#{node[:sqlserver][:remote_file_path]}/#{node[:sqlserver][:iso_name]}") }
end

ec2helper_iso 'MountsqlserverIso' do
	volume_name "#{node[:sqlserver][:volume_name]}"
	iso_filename "#{node[:sqlserver][:iso_name]}"
	iso_path "#{node[:sqlserver][:remote_file_path]}"
end
