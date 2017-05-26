#
# Cookbook Name:: sqlserver
# Recipe:: default
#
# Copyright (C) 2016 YadaYadaSoftware.com
#
# All rights reserved - Do Not Redistribute
#

if node[:sqlserver][:version] == "2014"
	include_recipe 'ms_dotnet35'
end

include_recipe 'ec2helper'
include_recipe 'mssqlserver::mount'

configurationFile = "#{Chef::Config[:cache_path]}/#{node[:sqlserver][:prepare_ini_file_template_source]}"

template "#{configurationFile}" do
  source "#{node[:sqlserver][:prepare_ini_file_template_source]}"
end

execute 'Install SQL' do
	timeout 7200
	command lazy {"#{node[:ec2helper][:iso][:mount][:drive_letter]}:/setup.exe /q /IAcceptSQLServerLicenseTerms=#{node[:sqlserver][:IAcceptSQLServerLicenseTerms]} /ConfigurationFile=#{configurationFile}"}
	not_if { File.exist?( "C:/Program Files/Microsoft SQL Server/#{node[:sqlserver][:short_version]}.#{node[:sqlserver][:INSTANCENAME]}/MSSQL/Binn/sqlservr.exe" ) }
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
