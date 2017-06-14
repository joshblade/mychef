Import-Module WebAdministration
Set-Location iis:\

New-WebAppPool -Name WebReports 
Set-ItemProperty -Path IIS:\AppPools\WebReports -Name managedRuntimeVersion -Value v2.0
Set-ItemProperty -Path IIS:\AppPools\WebReports -Name enable32BitAppOnWin64 -Value true
Set-ItemProperty -Path IIS:\AppPools\WebReports -Name managedPipelineMode -Value 1
Set-ItemProperty -Path IIS:\AppPools\WebReports -Name recycling.periodicRestart.privateMemory -Value 0
Set-ItemProperty -Path IIS:\AppPools\WebReports -Name recycling.periodicRestart.memory -Value 1992295
Set-ItemProperty -Path IIS:\AppPools\WebReports -Name processModel.loadUserProfile -Value True

New-WebApplication -Name WebReports -PhysicalPath 'Y:\ERS\WebReportsInternal' -ApplicationPool 'WebReports' -Site 'Default Web Site' 





