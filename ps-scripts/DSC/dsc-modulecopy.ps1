configuration DSCModuleCopy {

File cAssemblyManager
        {
            Ensure = 'Present'
            DestinationPath = 'y:\Temp'
            Type = 'Directory'
            SourcePath = z:\cAssemblyManager
        }
        File cIISBaseConfig
        {
            Ensure = 'Present'
            DestinationPath = 'y:\Temp'
            Type = 'Directory'
            SourcePath = z:\cIISBaseConfig
        }
        File cSQLServer
        {
            Ensure = 'Present'
            DestinationPath = 'y:\Temp'
            Type = 'Directory'
            SourcePath = z:\cSQLServer
        }
        File cWebAdministration
        {
            Ensure = 'Present'
            DestinationPath = 'y:\Temp'
            Type = 'Directory'
            SourcePath = z:\cWebAdministration
        }


}