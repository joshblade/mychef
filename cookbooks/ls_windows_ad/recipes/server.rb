#
# Cookbook Name:: ls_windows_ad
# Recipe:: create_domain
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


if node['ls_windows_ad']['role'] == 'primary'
  ls_windows_ad_server "#{node['ls_windows_ad']['domain_name']}" do
    domain_name node['ls_windows_ad']['domain_name']
    safe_mode_pass node['ls_windows_ad']['safe_mode_admin_pswd']
    type 'forest'
  end
end

if node['ls_windows_ad']['role'] == 'replica'
  ls_windows_ad_server "#{node['ls_windows_ad']['domain_name']}" do
    domain_name node['ls_windows_ad']['domain_name']
    safe_mode_pass node['ls_windows_ad']['safe_mode_admin_pswd']
    domain_user node['ls_windows_ad']['admin_username']
    domain_pass node['ls_windows_ad']['admin_pswd']
    type 'replica'
  end
end
