
Configuration  applyOnlyConfig

  {

  param(

  [string]$pullServerName =  "DSCPullServer01"

  )
    Node $env:COMPUTERNAME

  {

  LocalConfigurationManager

  {

  ConfigurationModeFrequencyMins = 45
  #This is the property we are really looking to modify
  ConfigurationMode = "ApplyOnly"

  RefreshMode = "Push"

  RebootNodeIfNeeded = $true

  AllowModuleOverwrite = $false

  }

  }

  }

#Modify the output path to suite your needs 
applyOnlyConfig -OutputPath "D:\DSC\Configurations"

#Update the path to reflect your output path
Set-DscLocalConfigurationManager  -Path "D:\DSC\Configurations"