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

####httpCompression
Clear-WebConfiguration -filter system.webserver/httpCompression/dynamicTypes
Add-WebConfigurationProperty -filter system.webserver/httpCompression/dynamicTypes -Name collection -AtIndex 0 -Value @{enabled="True";mimeType="text/*"}
Add-WebConfigurationProperty -filter system.webserver/httpCompression/dynamicTypes -Name collection -AtIndex 1 -Value @{enabled="True";mimeType="message/*"}
Add-WebConfigurationProperty -filter system.webserver/httpCompression/dynamicTypes -Name collection -AtIndex 2 -Value @{enabled="True";mimeType="application/x-javascript"}
Add-WebConfigurationProperty -filter system.webserver/httpCompression/dynamicTypes -Name collection -AtIndex 3 -Value @{enabled="True";mimeType="application/javascript"}
Add-WebConfigurationProperty -filter system.webserver/httpCompression/dynamicTypes -Name collection -AtIndex 4 -Value @{enabled="False";mimeType="*/*"}
Get-WebConfigurationProperty -filter system.webserver/httpCompression/dynamicTypes -Name collection
"----------------------------------------------------"

####serverRuntime
Set-WebConfigurationProperty -filter system.webserver/serverRuntime -Name appConcurrentRequestLimit -Value 10000
Get-WebConfigurationProperty -filter system.webserver/serverRuntime -Name appConcurrentRequestLimit 
"----------------------------------------------------"

Pop-Location