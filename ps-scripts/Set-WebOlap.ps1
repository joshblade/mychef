Import-Module WebAdministration
Set-Location iis:\

New-WebAppPool -Name OLAP
Set-ItemProperty -Path IIS:\AppPools\OLAP -Name managedRuntimeVersion -Value v2.0
Set-ItemProperty -Path IIS:\AppPools\OLAP -Name enable32BitAppOnWin64 -Value false
Set-ItemProperty -Path IIS:\AppPools\OLAP -Name managedPipelineMode -Value 1

New-WebApplication -Name WebOLAP -PhysicalPath 'Y:\WebOLAP' -ApplicationPool 'OLAP' -Site 'Default Web Site'


Set-WebConfigurationProperty -Filter system.WebServer/security/authentication/anonymousAuthentication -PSPath IIS:\ -name enabled -Location 'Default Web Site/WebOLAP' -value false

Get-WebConfigurationProperty -Filter system.WebServer/security/authentication/anonymousAuthentication -PSPath IIS:\ -name enabled -Location 'Default Web Site/WebOLAP'

Set-WebConfigurationProperty -Filter system.WebServer/security/authentication/basicAuthentication -PSPath IIS:\ -name enabled -Location 'Default Web Site/WebOLAP' -value true
Get-WebConfigurationProperty -Filter system.WebServer/security/authentication/basicAuthentication -PSPath IIS:\ -name enabled -Location 'Default Web Site/WebOLAP'

Set-WebConfigurationProperty -Filter system.WebServer/security/authentication/windowsAuthentication -PSPath IIS:\ -name enabled -Location 'Default Web Site/WebOLAP' -value false

Get-WebConfigurationProperty -Filter system.WebServer/security/authentication/windowsAuthentication -PSPath IIS:\ -name enabled -Location 'Default Web Site/WebOLAP'

Get-WebConfigurationProperty -Filter system.WebServer/security/isapiCgiRestriction -name collection 
Add-WebConfigurationProperty -Filter system.WebServer/security/isapiCgiRestriction -name collection -Value @{path="Y:\WebOLAP\msmdpump.dll";allowed="true"}
Get-WebConfigurationProperty -Filter system.WebServer/security/isapiCgiRestriction -name collection 