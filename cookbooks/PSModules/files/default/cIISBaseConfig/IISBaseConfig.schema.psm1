Configuration IISBaseConfig 
{
    Import-DscResource -ModuleName cWebAdministration
    cAppHostKeyValue queueLength
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/applicationPools/applicationPoolDefaults"
            Key = "queueLength"
            Value = "10005"
            IsAttribute = $true
        }
        cAppHostKeyValue managedRuntimeVersion
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/applicationPools/applicationPoolDefaults"
            Key = "managedRuntimeVersion"
            Value = "v4.0"
            IsAttribute = $true
        }
        cAppHostKeyValue startMode
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/applicationPools/applicationPoolDefaults"
            Key = "startMode"
            Value = "AlwaysRunning"
            IsAttribute = $true
        }
        cAppHostKeyValue idleTimeout
        {
            Ensure = "Present"
            WebsitePath = "MACHINE/WEBROOT/APPHOST"
            ConfigSection =  "/system.applicationHost/applicationPools/applicationPoolDefaults/processModel"
            Key = "idleTimeout"
            Value = "01:00:00"
            IsAttribute = $true
        }
}