(get-wmiobject Win32_ComputerSystem).Name
Import-Module WebAdministration
#Set-Location iis:\
Push-Location iis:\


#######Log

##Get-WebConfiguration //log//. | foreach { $_.attributes | select name,value }


Set-WebConfigurationProperty -Filter /system.applicationHost/log/centralBinaryLogFile -Name directory -Value "Y:\Privateroot\LogFiles"
Get-WebConfigurationProperty -Filter /system.applicationHost/log/centralBinaryLogFile -Name directory #%SystemDrive%\inetpub\logs\LogFiles
"----------------------------------------------------"


Set-WebConfigurationProperty -Filter /system.applicationHost/log/centralW3CLogFile -Name directory -Value "Y:\Privateroot\LogFiles"
Get-WebConfigurationProperty -Filter /system.applicationHost/log/centralW3CLogFile -Name directory #%SystemDrive%\inetpub\logs\LogFiles
"----------------------------------------------------"



########siteDefaults
##Get-WebConfiguration //siteDefaults//. | foreach { $_.attributes | select name,value }
Set-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/logFile -Name logExtFileFlags -Value "Date,Time,ClientIP,UserName,SiteName,ComputerName,ServerIP,Method,UriStem,UriQuery,HttpStatus,Win32Status,BytesSent,BytesRecv,TimeTaken,ServerPort,UserAgent,Cookie,Referer,ProtocolVersion,Ho
st,HttpSubStatus"
"Get-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/logFile -Name logExtFileFlags"
Get-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/logFile -Name logExtFileFlags 
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/logFile -Name logFormat -Value W3C
"Get-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/logFile -Name logFormat"
Get-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/logFile -Name logFormat
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/logFile -Name directory -Value "Y:\PrivateRoot\LogFiles"
Get-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/logFile -Name directory
"----------------------------------------------------"


Set-ItemProperty -Path 'IIS:\Sites\Default Web Site' -Name PhysicalPath -Value 'y:\root'
Get-ItemProperty -Path 'IIS:\Sites\Default Web Site' -Name PhysicalPath
"----------------------------------------------------"


Import-Module WebAdministration
"Windows Authentication Before"
Get-WebConfiguration -filter /system.webServer/security/authentication/windowsAuthentication | Format-List *
Set-WebConfiguration -filter system.webserver/security/authentication/windowsAuthentication -metadata overrideMode -value Allow 
"Windows Authentication After"
Get-WebConfiguration -filter /system.webServer/security/authentication/windowsAuthentication | Format-List *

"anonymousAuthentication Before"
Get-WebConfiguration -filter /system.webServer/security/authentication/anonymousAuthentication | Format-List *
Set-WebConfiguration -filter system.webserver/security/authentication/anonymousAuthentication -metadata overrideMode -value Allow
"anonymousAuthentication After"
Get-WebConfiguration -filter /system.webServer/security/authentication/anonymousAuthentication | Format-List *




Pop-Location


