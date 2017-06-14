(get-wmiobject Win32_ComputerSystem).Name
Import-Module WebAdministration
#Set-Location iis:\
Push-Location iis:\

#$subsections = Get-webconfiguration //applicationPoolDefaults//. -PSPATH iis:\$subsections | foreach { $_.attributes | select name,value }

######AppPool
##//Get-webconfiguration //applicationPoolDefaults//. | foreach { $_.attributes | select name,value}
#####################

Set-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults -Name queueLength -Value 10000
Get-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults -Name queueLength #1000
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults -Name managedRuntimeVersion -Value v4.0
Get-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults -Name managedRuntimeVersion #v4.0
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults -Name startMode -Value AlwaysRunning
"Set-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults -Name startMode -Value AlwaysRunning"
Get-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults -Name startMode  #OnDemand
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/processModel -Name idleTimeout -Value 01:00:00
Get-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/processModel -Name idleTimeout #00:20:00
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/processModel -Name idleTimeoutAction -Value Suspend
"Set-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/processModel -Name idleTimeoutAction -Value Suspend"
Get-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/processModel -Name idleTimeoutAction #Terminate
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/processModel -Name shutdownTimeLimit -Value 00:02:30
Get-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/processModel -Name shutdownTimeLimit #00:01:30
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/processModel -Name startupTimeLimit -Value 00:02:30
Get-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/processModel -Name startupTimeLimit #00:01:30
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/recycling -Name logEventOnRecycle -Value  "Time,Requests,Schedule,Memory,IsapiUnhealthy,OnDemand,ConfigChange,PrivateMemory"
"Get-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/recycling -Name logEventOnRecycle"
Get-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/recycling -Name logEventOnRecycle
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/recycling/periodicRestart -Name privateMemory -Value 1048576
Get-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/recycling/periodicRestart -Name privateMemory #0
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/recycling/periodicRestart -Name time -Value 00:00:00
Get-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/recycling/periodicRestart -Name time #1.05:00:00
"----------------------------------------------------"

Clear-WebConfiguration -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/recycling/periodicRestart/schedule
#Add-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/recycling/periodicRestart/schedule -Name collection -Value 04:0:00
#Set-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/recycling/periodicRestart/schedule -Name collection[0] -Value 04:00:00
#Remove-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/recycling/periodicRestart/schedule -Name collection[0]
Get-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/recycling/periodicRestart/schedule -Name collection
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/failure -Name rapidFailProtection -Value False
Get-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/failure -Name rapidFailProtection #True
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/cpu -Name resetInterval -Value 00:15:00
Get-WebConfigurationProperty -Filter /system.applicationHost/applicationPools/applicationPoolDefaults/cpu -Name resetInterval #00:05:00
"----------------------------------------------------"

#######Log

##Get-WebConfiguration //log//. | foreach { $_.attributes | select name,value }

Set-WebConfigurationProperty -Filter /system.applicationHost/log -Name centralLogFileMode -Value CentralW3C
"Get-WebConfigurationProperty -Filter /system.applicationHost/log -Name centralLogFileMode"
Get-WebConfigurationProperty -Filter /system.applicationHost/log -Name centralLogFileMode
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/log/centralBinaryLogFile -Name enabled -Value False
Get-WebConfigurationProperty -Filter /system.applicationHost/log/centralBinaryLogFile -Name enabled #True
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/log/centralBinaryLogFile -Name directory -Value "Y:\Privateroot\LogFiles"
Get-WebConfigurationProperty -Filter /system.applicationHost/log/centralBinaryLogFile -Name directory #%SystemDrive%\inetpub\logs\LogFiles
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/log/centralBinaryLogFile -Name truncateSize -Value 1073741824
Get-WebConfigurationProperty -Filter /system.applicationHost/log/centralBinaryLogFile -Name truncateSize #20971520
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/log/centralBinaryLogFile -Name localTimeRollover -Value True
Get-WebConfigurationProperty -Filter /system.applicationHost/log/centralBinaryLogFile -Name localTimeRollover #False
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/log/centralW3CLogFile -Name enabled -Value True
Get-WebConfigurationProperty -Filter /system.applicationHost/log/centralW3CLogFile -Name enabled #True
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/log/centralW3CLogFile -Name directory -Value "Y:\Privateroot\LogFiles"
Get-WebConfigurationProperty -Filter /system.applicationHost/log/centralW3CLogFile -Name directory #%SystemDrive%\inetpub\logs\LogFiles
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/log/centralW3CLogFile -Name truncateSize -Value 1073741824
Get-WebConfigurationProperty -Filter /system.applicationHost/log/centralW3CLogFile -Name truncateSize #20971520
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/log/centralW3CLogFile -Name localTimeRollover -Value True
Get-WebConfigurationProperty -Filter /system.applicationHost/log/centralW3CLogFile -Name localTimeRollover #False
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/log/centralW3CLogFile -Name logExtFileFlags -Value "Date, Time, ClientIP, UserName, SiteName, ComputerName, ServerIP, Method, UriStem, UriQuery, HttpStatus, Win32Status, BytesSent, BytesRecv, TimeTaken, ServerPort, UserAgent, Cookie, Referer, ProtocolVersion, Host, HttpSubStatus"
"Get-WebConfigurationProperty -Filter /system.applicationHost/log/centralW3CLogFile -Name logExtFileFlags"
Get-WebConfigurationProperty -Filter /system.applicationHost/log/centralW3CLogFile -Name logExtFileFlags
"----------------------------------------------------"

########siteDefaults
##Get-WebConfiguration //siteDefaults//. | foreach { $_.attributes | select name,value }
Set-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/logFile -Name logExtFileFlags -Value "Date, Time, ClientIP, UserName, SiteName, ComputerName, ServerIP, Method, UriStem, UriQuery, HttpStatus, Win32Status, BytesSent, BytesRecv, TimeTaken, ServerPort, UserAgent, Cookie, Referer, ProtocolVersion, Host, HttpSubStatus"
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

Set-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/logFile -Name truncateSize -Value 1073741824
Get-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/logFile -Name truncateSize
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/logFile -Name localTimeRollover -Value true
Get-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/logFile -Name localTimeRollover
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/traceFailedRequestsLogging -Name directory -Value "Y:\Privateroot\FailedReqLogFiles"
Get-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/traceFailedRequestsLogging -Name directory
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/traceFailedRequestsLogging -Name maxLogFiles -Value 10000
Get-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/traceFailedRequestsLogging -Name maxLogFiles
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/traceFailedRequestsLogging -Name maxLogFileSizeKB -Value 1048576
Get-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/traceFailedRequestsLogging -Name maxLogFileSizeKB
"----------------------------------------------------"

Clear-WebConfiguration -Filter /system.applicationHost/sites/siteDefaults
Add-WebconfigurationProperty -Filter /system.applicationHost/sites/siteDefaults -Name bindings.collection -Value @{protocol="http";bindingInformation="*:443:"}
Add-WebconfigurationProperty -Filter /system.applicationHost/sites/siteDefaults -Name bindings.collection -Value @{protocol="http";bindingInformation="*:80:"}
Get-WebconfigurationProperty -Filter /system.applicationHost/sites/siteDefaults -Name bindings.collection
#Get-WebconfigurationProperty //sites/siteDefaults -Name bindings.collection[0]
#Set-WebconfigurationProperty //sites/siteDefaults -Name bindings.collection[1] -Value @{protocol="http";bindingInformation="*:443:"} 
#Remove-WebconfigurationProperty //sites/siteDefaults -Name bindings.collection[0] 
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/limits -Name connectionTimeout -Value 00:30:00
Get-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/limits -Name connectionTimeout #00:20:00
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/limits -Name maxUrlSegments -Value 64
Get-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/limits -Name maxUrlSegments
"----------------------------------------------------"


##############ApplicationDefaults

Set-WebConfigurationProperty -Filter /system.applicationHost/sites/applicationDefaults -Name applicationPool -Value DefaultAppPool
Get-WebConfigurationProperty -Filter /system.applicationHost/sites/applicationDefaults -Name applicationPool
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/sites/applicationDefaults -Name enabledProtocols -Value https
Get-WebConfigurationProperty -Filter /system.applicationHost/sites/applicationDefaults -Name enabledProtocols
"----------------------------------------------------"

#########VirtualDirectoryDefault
Set-WebConfigurationProperty -Filter /system.applicationHost/sites/virtualDirectoryDefaults -Name allowSubDirConfig -Value true
Get-WebConfigurationProperty -Filter /system.applicationHost/sites/virtualDirectoryDefaults -Name allowSubDirConfig
"----------------------------------------------------"

#######webLimits
Set-WebConfigurationProperty -Filter /system.applicationHost/webLimits -Name connectionTimeout -Value 00:30:00
Get-WebConfigurationProperty -Filter /system.applicationHost/webLimits -Name connectionTimeout
"----------------------------------------------------"

######ConfigurationHistory
Set-WebConfigurationProperty -Filter /system.applicationHost/configHistory -Name path -Value Y:\Privateroot\configHistory
Get-WebConfigurationProperty -Filter /system.applicationHost/configHistory -Name path
"----------------------------------------------------"

Set-WebConfigurationProperty -Filter /system.applicationHost/configHistory -Name maxHistories -Value 1000
Get-WebConfigurationProperty -Filter /system.applicationHost/configHistory -Name maxHistories
"----------------------------------------------------"


#########ASP
Set-WebConfigurationProperty -filter system.webserver/asp -Name errorsToNTLog -Value True
Get-WebConfigurationProperty -filter system.webserver/asp -Name errorsToNTLog
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/asp -Name enableAspHtmlFallback -Value false
Get-WebConfigurationProperty -filter system.webserver/asp -Name enableAspHtmlFallback
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/asp/cache -Name diskTemplateCacheDirectory -Value "%SystemDrive%\inetpub\temp\ASP Compiled Templates"
Get-WebConfigurationProperty -filter system.webserver/asp/cache -Name diskTemplateCacheDirectory
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/asp/cache -Name maxDiskTemplateCacheFiles -Value 2147483647
Get-WebConfigurationProperty -filter system.webserver/asp/cache -Name maxDiskTemplateCacheFiles #2000
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/asp/cache -Name scriptFileCacheSize -Value 2147483647
Get-WebConfigurationProperty -filter system.webserver/asp/cache -Name scriptFileCacheSize #500
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/asp/cache -Name scriptEngineCacheMax -Value 2147483647
Get-WebConfigurationProperty -filter system.webserver/asp/cache -Name scriptEngineCacheMax
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/asp/session -Name timeout -Value 00:30:00
Get-WebConfigurationProperty -filter system.webserver/asp/session -Name timeout #00:20:00
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/asp/limits -Name bufferingLimit -Value 12288000
Get-WebConfigurationProperty -filter system.webserver/asp/limits -Name bufferingLimit #4194304
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/asp/limits -Name maxRequestEntityAllowed -Value 204800
Get-WebConfigurationProperty -filter system.webserver/asp/limits -Name maxRequestEntityAllowed #2000000
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/asp/limits -Name processorThreadMax -Value 100
Get-WebConfigurationProperty -filter system.webserver/asp/limits -Name processorThreadMax
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/asp/limits -Name requestQueueMax -Value 10000
Get-WebConfigurationProperty -filter system.webserver/asp/limits -Name requestQueueMax #3000
"----------------------------------------------------"


#####default Document
Set-WebConfigurationProperty -filter system.webserver/defaultDocument -Name enabled -Value True
Get-WebConfigurationProperty -filter system.webserver/defaultDocument -Name enabled
"----------------------------------------------------"

Clear-WebConfiguration -filter system.webserver/defaultDocument/files 
Add-WebConfigurationProperty -filter system.webserver/defaultDocument/files -Name collection -AtIndex 0 -Value default.html
Add-WebConfigurationProperty -filter system.webserver/defaultDocument/files -Name collection -AtIndex 1 -Value gemsstatus.asp
Add-WebConfigurationProperty -filter system.webserver/defaultDocument/files -Name collection -AtIndex 2 -Value machine.asp
Add-WebConfigurationProperty -filter system.webserver/defaultDocument/files -Name collection -AtIndex 3 -Value machine.html
Add-WebConfigurationProperty -filter system.webserver/defaultDocument/files -Name collection -AtIndex 4 -Value Test.aspx
Add-WebConfigurationProperty -filter system.webserver/defaultDocument/files -Name collection -AtIndex 5 -Value iisstart.html
Get-WebConfigurationProperty -filter system.webserver/defaultDocument/files -Name collection
"----------------------------------------------------"

####httpCompression
Clear-WebConfiguration -filter system.webserver/httpCompression/dynamicTypes
Add-WebConfigurationProperty -filter system.webserver/httpCompression/dynamicTypes -Name collection -AtIndex 0 -Value @{enabled="True";mimeType="text/*"}
Add-WebConfigurationProperty -filter system.webserver/httpCompression/dynamicTypes -Name collection -AtIndex 1 -Value @{enabled="True";mimeType="message/*"}
Add-WebConfigurationProperty -filter system.webserver/httpCompression/dynamicTypes -Name collection -AtIndex 2 -Value @{enabled="True";mimeType="application/x-javascript"}
Add-WebConfigurationProperty -filter system.webserver/httpCompression/dynamicTypes -Name collection -AtIndex 3 -Value @{enabled="True";mimeType="application/javascript"}
Add-WebConfigurationProperty -filter system.webserver/httpCompression/dynamicTypes -Name collection -AtIndex 4 -Value @{enabled="False";mimeType="*/*"}
Get-WebConfigurationProperty -filter system.webserver/httpCompression/dynamicTypes -Name collection
"----------------------------------------------------"

####httpRedirect
Set-WebConfigurationProperty -filter system.webserver/httpRedirect -Name enabled -Value False
Get-WebConfigurationProperty -filter system.webserver/httpRedirect -Name enabled
"----------------------------------------------------"

####security
Set-WebConfigurationProperty -filter system.webserver/security/authentication/anonymousAuthentication -Name enabled -Value True
Get-WebConfigurationProperty -filter system.webserver/security/authentication/anonymousAuthentication -Name enabled
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/security/authentication/basicAuthentication -Name enabled -Value False
Get-WebConfigurationProperty -filter system.webserver/security/authentication/basicAuthentication -Name enabled
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/security/authentication/clientCertificateMappingAuthentication -Name enabled -Value False
Get-WebConfigurationProperty -filter system.webserver/security/authentication/clientCertificateMappingAuthentication -Name enabled
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/security/authentication/digestAuthentication -Name enabled -Value False
Get-WebConfigurationProperty -filter system.webserver/security/authentication/digestAuthentication -Name enabled
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/security/authentication/iisClientCertificateMappingAuthentication -Name enabled -Value False
Get-WebConfigurationProperty -filter system.webserver/security/authentication/iisClientCertificateMappingAuthentication -Name enabled
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/security/authentication/windowsAuthentication -Name enabled -Value False
Get-WebConfigurationProperty -filter system.webserver/security/authentication/windowsAuthentication -Name enabled
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/security/authentication/windowsAuthentication -Name authPersistNonNTLM -Value true
Get-WebConfigurationProperty -filter system.webserver/security/authentication/windowsAuthentication -Name authPersistNonNTLM
"----------------------------------------------------"

Clear-WebConfiguration -Filter system.webserver/security/authentication/windowsAuthentication/providers
Add-WebConfigurationProperty -filter system.webserver/security/authentication/windowsAuthentication/providers -Name collection -Value Negotiate
Add-WebConfigurationProperty -filter system.webserver/security/authentication/windowsAuthentication/providers -Name collection -Value NTLM
Get-WebConfigurationProperty -filter system.webserver/security/authentication/windowsAuthentication/providers -Name collection
"----------------------------------------------------"

Clear-WebConfiguration -Filter system.webserver/security/authorization
Add-WebConfigurationProperty -filter system.webserver/security/authorization -Name collection -Value @{accessType="Allow";users="*"}
Get-WebConfigurationProperty -filter system.webserver/security/authorization -Name collection
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/security/ipSecurity -Name allowUnlisted -Value true
Get-WebConfigurationProperty -filter system.webserver/security/ipSecurity -Name allowUnlisted
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/security/isapiCgiRestriction -Name notListedIsapisAllowed -Value false
Get-WebConfigurationProperty -filter system.webserver/security/isapiCgiRestriction -Name notListedIsapisAllowed
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/security/isapiCgiRestriction -Name notListedCgisAllowed -Value false
Get-WebConfigurationProperty -filter system.webserver/security/isapiCgiRestriction -Name notListedCgisAllowed
"----------------------------------------------------"

Set-WebConfigurationProperty -filter system.webserver/serverRuntime -Name appConcurrentRequestLimit -Value 10000
Get-WebConfigurationProperty -filter system.webserver/serverRuntime -Name appConcurrentRequestLimit 
"----------------------------------------------------"

Set-ItemProperty -Path 'IIS:\Sites\Default Web Site' -Name PhysicalPath -Value 'y:\root'
Get-ItemProperty -Path 'IIS:\Sites\Default Web Site' -Name PhysicalPath
"----------------------------------------------------"

Set-WebConfiguration -filter system.webserver/security/authentication/windowsAuthentication -metadata overrideMode -value Allow 
Get-WebConfiguration -filter /system.webServer/security/authentication/windowsAuthentication | Format-List *
"----------------------------------------------------"

Set-WebConfiguration -filter system.webserver/security/authentication/anonymousAuthentication -metadata overrideMode -value Allow
Get-WebConfiguration -filter /system.webServer/security/authentication/anonymousAuthentication | Format-List *


Pop-Location