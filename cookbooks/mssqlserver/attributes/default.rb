default['sqlserver']['version'] = "2016"

case node[:sqlserver][:version]
	when "2016"
		default['sqlserver']['iso_name'] = "en_sql_server_2016_standard_with_service_pack_1_x64_dvd_9540929.iso"
		default['sqlserver']['remote_file_source'] = "https://s3.amazonaws.com/d2d2d2d2d2d2/Software/#{default['sqlserver']['iso_name']}"
		default['sqlserver']['volume_name'] = "SQL2016_x64_ENU"
		default['sqlserver']['ini_file_template_source'] = "2016sp1-install.ini"
		default['sqlserver']['prepare_ini_file_template_source'] = "2016sp1-prepare.ini"
		default['sqlserver']['iso_checksum'] = "fc87acf3990a361873e2fb9746164d487b2ee187b41264c412318a99bbb1daba"
		default['sqlserver']['short_version'] = "13"
	else
		default['sqlserver']['iso_name'] = "SQLServer2014SP2-FullSlipstream-x64-ENU.iso"
		default['sqlserver']['remote_file_source'] = "http://care.dlservice.microsoft.com/dl/download/6/D/9/6D90C751-6FA3-4A78-A78E-D11E1C254700/SQLServer2014SP2-FullSlipstream-x64-ENU.iso"
		default['sqlserver']['volume_name'] = "SQL2014_x64_ENU"
		default['sqlserver']['ini_file_template_source'] = "installfromprepared.ini"
		default['sqlserver']['prepare_ini_file_template_source'] = "prepare.ini"
		default['sqlserver']['iso_checksum'] = "2223bd66ab4ec905960ce9ae7545c95d43ea9ec736da16be997676a93800df5e"
		default['sqlserver']['short_version'] = "12"
end

default['sqlserver']['remote_file_path'] = "#{Chef::Config[:cache_path]}"


default['sqlserver']['FEATURES'] = 'SQLEngine,SSMS,FullText'
default['sqlserver']['INSTANCENAME'] = 'MSSQLSERVER'
default['sqlserver']['IAcceptSQLServerLicenseTerms'] = 'true'
default['sqlserver']['SQLSVCACCOUNT'] = 'NT AUTHORITY\\NETWORK SERVICE'
default['sqlserver']['AGTSVCACCOUNT'] = 'NT Service\\SQLSERVERAGENT'
default['sqlserver']['SECURITYMODE'] = 'SQL'
default['sqlserver']['SAPWD'] = 'JUhsd82.!#'
default['sqlserver']['TCPENABLED'] = '1'
default['sqlserver']['ADDCURRENTUSERASSQLADMIN'] = 'false'
default['sqlserver']['SQLUSERDBLOGDIR'] = 'c:\\sqllog'
default['sqlserver']['INSTALLSQLDATADIR'] = 'c:\\sqldata'
default['sqlserver']['SQLBACKUPDIR'] = 'c:\\sqlbackup'
default['sqlserver']['SQLTEMPDBDIR'] = "#{node[:sqlserver][:INSTALLSQLDATADIR]}"
default['sqlserver']['SQLTEMPDBLOGDIR'] = "#{node[:sqlserver][:SQLUSERDBLOGDIR]}"



if "#{ENV['USERDOMAIN']}" == "#{ENV['COMPUTERNAME']}"
	default['sqlserver']['SQLSYSADMINACCOUNTS'] = "\"#{ENV['COMPUTERNAME']}\\Users\""
else
	default['sqlserver']['SQLSYSADMINACCOUNTS'] = "\"#{node[:domain]}\\Domain Users\" \"#{node[:domain]}\\Domain Computers\""
end



