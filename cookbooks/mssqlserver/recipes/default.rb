#
# Cookbook Name:: sqlserver
# Recipe:: default
#
# Copyright (C) 2016 YadaYadaSoftware.com
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'mssqlserver::install'
include_recipe 'mssqlserver::ssms'