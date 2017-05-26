#
# Cookbook Name:: sqlserver
# Recipe:: default
#
# Copyright (C) 2016 YadaYadaSoftware.com
#
# All rights reserved - Do Not Redistribute
#

if "#{node[:sqlserver][:version]}" == "2016"
	include_recipe 'ms_dotnet35'
end

include_recipe 'ec2helper'
include_recipe 'mssqlserver::mount'

ini_file = "#{Chef::Config[:cache_path]}/#{node[:sqlserver][:ini_file_template_source]}"

template "#{ini_file}" do
  source "#{node[:sqlserver][:ini_file_template_source]}"
end

#2016 checksum
#fc87acf3990a361873e2fb9746164d487b2ee187b41264c412318a99bbb1daba
execute 'Install SQL' do
	timeout 7200
	command lazy {"#{node[:ec2helper][:iso][:mount][:drive_letter]}:/setup.exe /IAcceptSQLServerLicenseTerms=true /ConfigurationFile=#{ini_file} /SAPWD=#{node[:sqlserver][:SAPWD]}"}
	not_if { File.exist?( "#{node[:sqlserver][:SQLTEMPDBDIR]}/tempdb.mdf" ) }
end

ssms_file = "#{Chef::Config[:cache_path]}/SSMS-Setup-ENU.exe"

remote_file "#{ssms_file}" do
	source "https://download.microsoft.com/download/9/3/3/933EA6DD-58C5-4B78-8BEC-2DF389C72BE0/SSMS-Setup-ENU.exe"
	not_if { File.exist?("#{ssms_file}") }
end

execute 'Install Management Studio' do
	timeout 7200
	command "#{ssms_file} /install /quiet"
	not_if { File.exist?("C:/Program Files (x86)/Microsoft SQL Server/130/Tools/Binn/ManagementStudio/Ssms.exe") }
end
