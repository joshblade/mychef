
# Test to see if the SQLPS module is loaded, and if not, load it
Function Load-SQLPS
{
     if (-not(Get-Module -name 'SQLPS')) {
         if (Get-Module -ListAvailable | Where-Object {$_.Name -eq 'SQLPS' }) {
            Push-Location # The SQLPS module load changes location to the Provider, so save the current location
            Import-Module -Name 'SQLPS' -DisableNameChecking
            Pop-Location # Now go back to the original location
         }
     }
}
####################################################AQR_ODS Refresh###########################################################
Function Create-AQRJob
{
    param
    (
        [string]$Server,
        [string]$Instance
    )

    $DesServer=$Server
    if ($Instance -ne "")
        {
            $DesServer=$DesServer+"\"+$Instance
        }

    #$DesServer="HSA-DB-UTL17\ODS"
    #$Server='HSA-DB-UTL17'
    $ServerObject = new-object ('Microsoft.SqlServer.Management.Smo.Server') $DesServer
    #$s=new-object ('Microsoft.SqlServer.Management.Smo.Server') 'HSA-DB-UTL16\ODS'

    $Job = new-object ('Microsoft.SqlServer.Management.Smo.Agent.Job') ($ServerObject.JobServer, 'AQR_ODS Refresh')
    $Job.Description = 'Refresh AQR_ODS database.'
    $Job.OwnerLoginName = $Server+'\ehbsqlsa'
    $Job.EventLogLevel = [Microsoft.SqlServer.Management.Smo.Agent.CompletionAction]::Never
    $Job.Create()

    $JobStep = new-object ('Microsoft.SqlServer.Management.Smo.Agent.JobStep') ($Job, 'AQR_ODS Refresh')
    $JobStep.SubSystem = 'SSIS'
    $JobStep.Command = '/SQL "\"\AQR ODS Controller\"" /SERVER "\"'+$DesServer+'\"" /MAXCONCURRENT " -1 " /CHECKPOINTING OFF /REPORTING E'  #"c:\Scripts\getperf.ps1 '$DesServer' 60 '2199-12-31 23:59:59'"
    $JobStep.OnSuccessAction = 'QuitWithSuccess'
    $JobStep.OnFailAction = 'QuitWithFailure'
    $JobStep.DatabaseName = 'master'
    $JobStep.Create()

    $JobStepId = $JobStep.ID
    $Job.ApplyToTargetServer($ServerObject.Name)
    $Job.StartStepID = $JobStepId
    $Job.Alter()

    $JobStepSchedule = new-object ('Microsoft.SqlServer.Management.Smo.Agent.JobSchedule') ($Job, 'AQR_ODS')
    $JobStepSchedule.FrequencyTypes = [Microsoft.SqlServer.Management.SMO.Agent.FrequencyTypes]::Daily
    $JobStepSchedule.FrequencyInterval = 1
    $JobStepSchedule.FrequencySubDayTypes = [Microsoft.SqlServer.Management.SMO.Agent.FrequencySubDayTypes]::Once
    $JobStepSchedule.FrequencySubDayInterval = 0
    #$JobStepSchedule.ActiveStartDate = "02/12/2015"
    $JobStepSchedule.ActiveStartDate = get-date
    $JobStepSchedule.ActiveEndDate="12/31/9999"  #No end date
    $ts1 =  New-Object -TypeName TimeSpan -argumentlist 5, 50, 0   # hours, minutes, seconds
    $JobStepSchedule.ActiveStartTimeOfDay = $ts1
    $ts2 = New-Object -TypeName TimeSpan -argumentlist 23, 59, 59  # hours, minutes, seconds
    $JobStepSchedule.ActiveEndTimeOfDay = $ts2    
    $JobStepSchedule.Create()
    
 }

####################################################BHCMIS ODS Refresh###########################################################
Function Create-BHCMISJob
{
    param
    (
        [string]$Server,
        [string]$Instance
    )

    $DesServer=$Server
    if ($Instance -ne "")
        {
            $DesServer=$DesServer+"\"+$Instance
        }

    #$DesServer="HSA-DB-UTL17\ODS"
    #$Server='HSA-DB-UTL17'
    $ServerObject = new-object ('Microsoft.SqlServer.Management.Smo.Server') $DesServer
    #$s=new-object ('Microsoft.SqlServer.Management.Smo.Server') 'HSA-DB-UTL16\ODS'

    $Job = new-object ('Microsoft.SqlServer.Management.Smo.Agent.Job') ($ServerObject.JobServer, 'BHCMIS ODS Refresh')
    $Job.Description = 'Refresh BHCMIS_ODS database.'
    $Job.OwnerLoginName = $Server+'\ehbsqlsa'
    $Job.EventLogLevel = [Microsoft.SqlServer.Management.Smo.Agent.CompletionAction]::Never
    $Job.Create()

    $JobStep = new-object ('Microsoft.SqlServer.Management.Smo.Agent.JobStep') ($Job, 'BHCMIS ODS Refresh')
    $JobStep.SubSystem = 'SSIS'
    $JobStep.Command = '/SQL "\"\BHCMIS ODS Controller\"" /SERVER "\"'+$DesServer+'\"" /MAXCONCURRENT " -1 " /CHECKPOINTING OFF /REPORTING E'  #"c:\Scripts\getperf.ps1 '$DesServer' 60 '2199-12-31 23:59:59'"
    $JobStep.OnSuccessAction = 'QuitWithSuccess'
    $JobStep.OnFailAction = 'QuitWithFailure'
    $JobStep.DatabaseName = 'master'
    $JobStep.Create()

    $JobStepId = $JobStep.ID
    $Job.ApplyToTargetServer($ServerObject.Name)
    $Job.StartStepID = $JobStepId
    $Job.Alter()

    $JobStepSchedule = new-object ('Microsoft.SqlServer.Management.Smo.Agent.JobSchedule') ($Job, 'BHCMIS ODS Refresh')
    $JobStepSchedule.FrequencyTypes = [Microsoft.SqlServer.Management.SMO.Agent.FrequencyTypes]::Weekly
    $JobStepSchedule.FrequencyInterval = 62
    $JobStepSchedule.FrequencySubDayTypes = [Microsoft.SqlServer.Management.SMO.Agent.FrequencySubDayTypes]::Once
    $JobStepSchedule.FrequencySubDayInterval = 0
    $JobStepSchedule.FrequencyRelativeIntervals=0
    $JobStepSchedule.FrequencyRecurrenceFactor=1
    #$JobStepSchedule.ActiveStartDate = "02/12/2015"
    $JobStepSchedule.ActiveStartDate = get-date
    $JobStepSchedule.ActiveEndDate="12/31/9999"  #No end date
    $ts1 =  New-Object -TypeName TimeSpan -argumentlist 3, 30, 0   # hours, minutes, seconds
    $JobStepSchedule.ActiveStartTimeOfDay = $ts1
    $ts2 = New-Object -TypeName TimeSpan -argumentlist 23, 59, 59  # hours, minutes, seconds
    $JobStepSchedule.ActiveEndTimeOfDay = $ts2    
    $JobStepSchedule.Create()

    $JobStepSchedule = new-object ('Microsoft.SqlServer.Management.Smo.Agent.JobSchedule') ($Job, 'BHCMIS ODS Refresh - Weekend Schedule')
    $JobStepSchedule.FrequencyTypes = [Microsoft.SqlServer.Management.SMO.Agent.FrequencyTypes]::Weekly
    $JobStepSchedule.FrequencyInterval = 65
    $JobStepSchedule.FrequencySubDayTypes = [Microsoft.SqlServer.Management.SMO.Agent.FrequencySubDayTypes]::Once
    $JobStepSchedule.FrequencySubDayInterval = 0
    $JobStepSchedule.FrequencyRelativeIntervals=0
    $JobStepSchedule.FrequencyRecurrenceFactor=1
    #$JobStepSchedule.ActiveStartDate = "02/12/2015"
    $JobStepSchedule.ActiveStartDate = get-date
    $JobStepSchedule.ActiveEndDate="12/31/9999"  #No end date
    $ts1 =  New-Object -TypeName TimeSpan -argumentlist 4, 0, 0   # hours, minutes, seconds
    $JobStepSchedule.ActiveStartTimeOfDay = $ts1
    $ts2 = New-Object -TypeName TimeSpan -argumentlist 23, 59, 59  # hours, minutes, seconds
    $JobStepSchedule.ActiveEndTimeOfDay = $ts2    
    $JobStepSchedule.Create()
    
 }

####################################################BHPR_ODS Refresh###########################################################
Function Create-BHPRJob
{
    param
    (
        [string]$Server,
        [string]$Instance
    )

    $DesServer=$Server
    if ($Instance -ne "")
        {
            $DesServer=$DesServer+"\"+$Instance
        }

    #$DesServer="HSA-DB-UTL17\ODS"
    #$Server='HSA-DB-UTL17'
    $ServerObject = new-object ('Microsoft.SqlServer.Management.Smo.Server') $DesServer
    #$s=new-object ('Microsoft.SqlServer.Management.Smo.Server') 'HSA-DB-UTL16\ODS'

    $Job = new-object ('Microsoft.SqlServer.Management.Smo.Agent.Job') ($ServerObject.JobServer, 'BHPR_ODS Refresh')
    $Job.Description = 'Refresh BHPR_ODS database.'
    $Job.OwnerLoginName = $Server+'\ehbsqlsa'
    $Job.EventLogLevel = [Microsoft.SqlServer.Management.Smo.Agent.CompletionAction]::Never
    $Job.Create()

    $JobStep = new-object ('Microsoft.SqlServer.Management.Smo.Agent.JobStep') ($Job, 'BHPR_ODS Refresh')
    $JobStep.SubSystem = 'SSIS'
    $JobStep.Command = '/SQL "\"\BHPR ODS Controller\"" /SERVER "\"'+$DesServer+'\"" /MAXCONCURRENT " -1 " /CHECKPOINTING OFF /REPORTING E'  #"c:\Scripts\getperf.ps1 '$DesServer' 60 '2199-12-31 23:59:59'"
    $JobStep.OnSuccessAction = 'QuitWithSuccess'
    $JobStep.OnFailAction = 'QuitWithFailure'
    $JobStep.DatabaseName = 'master'
    $JobStep.Create()

    $JobStepId = $JobStep.ID
    $Job.ApplyToTargetServer($ServerObject.Name)
    $Job.StartStepID = $JobStepId
    $Job.Alter()

    $JobStepSchedule = new-object ('Microsoft.SqlServer.Management.Smo.Agent.JobSchedule') ($Job, 'BHPR_Refresh')
    $JobStepSchedule.FrequencyTypes = [Microsoft.SqlServer.Management.SMO.Agent.FrequencyTypes]::Daily
    $JobStepSchedule.FrequencyInterval = 1
    $JobStepSchedule.FrequencySubDayTypes = [Microsoft.SqlServer.Management.SMO.Agent.FrequencySubDayTypes]::Once
    $JobStepSchedule.FrequencySubDayInterval = 0
    #$JobStepSchedule.ActiveStartDate = "02/12/2015"
    $JobStepSchedule.ActiveStartDate = get-date
    $JobStepSchedule.ActiveEndDate="12/31/9999"  #No end date
    $ts1 =  New-Object -TypeName TimeSpan -argumentlist 6, 0, 0   # hours, minutes, seconds
    $JobStepSchedule.ActiveStartTimeOfDay = $ts1
    $ts2 = New-Object -TypeName TimeSpan -argumentlist 23, 59, 59  # hours, minutes, seconds
    $JobStepSchedule.ActiveEndTimeOfDay = $ts2    
    $JobStepSchedule.Create()
    
 }
####################################################CHGME ODS Refresh###########################################################
Function Create-CHGMEODS
{
    param
    (
        [string]$Server,
        [string]$Instance
    )

    $DesServer=$Server
    if ($Instance -ne "")
        {
            $DesServer=$DesServer+"\"+$Instance
        }

    #$DesServer="HSA-DB-UTL17\ODS"
    #$Server='HSA-DB-UTL17'
    $ServerObject = new-object ('Microsoft.SqlServer.Management.Smo.Server') $DesServer
    #$s=new-object ('Microsoft.SqlServer.Management.Smo.Server') 'HSA-DB-UTL16\ODS'

    $Job = new-object ('Microsoft.SqlServer.Management.Smo.Agent.Job') ($ServerObject.JobServer, 'CHGME ODS Refresh')
    $Job.Description = 'Refresh CHGME_ODS database.'
    $Job.OwnerLoginName = $Server+'\ehbsqlsa'
    $Job.EventLogLevel = [Microsoft.SqlServer.Management.Smo.Agent.CompletionAction]::Never
    $Job.Create()

    $JobStep = new-object ('Microsoft.SqlServer.Management.Smo.Agent.JobStep') ($Job, 'CHGME_ODS Refresh')
    $JobStep.SubSystem = 'SSIS'
    $JobStep.Command = '/SQL "\"\CHGME ODS Controller\"" /SERVER "\"'+$DesServer+'\"" /MAXCONCURRENT " -1 " /CHECKPOINTING OFF /REPORTING E'  #"c:\Scripts\getperf.ps1 '$DesServer' 60 '2199-12-31 23:59:59'"
    $JobStep.OnSuccessAction = 'QuitWithSuccess'
    $JobStep.OnFailAction = 'QuitWithFailure'
    $JobStep.DatabaseName = 'master'
    $JobStep.Create()

    $JobStepId = $JobStep.ID
    $Job.ApplyToTargetServer($ServerObject.Name)
    $Job.StartStepID = $JobStepId
    $Job.Alter()

    $JobStepSchedule = new-object ('Microsoft.SqlServer.Management.Smo.Agent.JobSchedule') ($Job, 'CHGMEODS_Refresh')
    $JobStepSchedule.FrequencyTypes = [Microsoft.SqlServer.Management.SMO.Agent.FrequencyTypes]::Daily
    $JobStepSchedule.FrequencyInterval = 1
    $JobStepSchedule.FrequencySubDayTypes = [Microsoft.SqlServer.Management.SMO.Agent.FrequencySubDayTypes]::Once
    $JobStepSchedule.FrequencySubDayInterval = 0
    #$JobStepSchedule.ActiveStartDate = "02/12/2015"
    $JobStepSchedule.ActiveStartDate = get-date
    $JobStepSchedule.ActiveEndDate="12/31/9999"  #No end date
    $ts1 =  New-Object -TypeName TimeSpan -argumentlist 6, 0, 0   # hours, minutes, seconds
    $JobStepSchedule.ActiveStartTimeOfDay = $ts1
    $ts2 = New-Object -TypeName TimeSpan -argumentlist 23, 59, 59  # hours, minutes, seconds
    $JobStepSchedule.ActiveEndTimeOfDay = $ts2    
    $JobStepSchedule.Create()
    
 }
####################################################ESR ODS Refresh###########################################################
Function Create-ESRODS
{
    param
    (
        [string]$Server,
        [string]$Instance
    )

    $DesServer=$Server
    if ($Instance -ne "")
        {
            $DesServer=$DesServer+"\"+$Instance
        }

    #$DesServer="HSA-DB-UTL17\ODS"
    #$Server='HSA-DB-UTL17'
    $ServerObject = new-object ('Microsoft.SqlServer.Management.Smo.Server') $DesServer
    #$s=new-object ('Microsoft.SqlServer.Management.Smo.Server') 'HSA-DB-UTL16\ODS'

    $Job = new-object ('Microsoft.SqlServer.Management.Smo.Agent.Job') ($ServerObject.JobServer, 'ESR ODS Refresh')
    $Job.Description = 'Refresh ESR_ODS database.'
    $Job.OwnerLoginName = $Server+'\ehbsqlsa'
    $Job.EventLogLevel = [Microsoft.SqlServer.Management.Smo.Agent.CompletionAction]::Never
    $Job.Create()

    $JobStep = new-object ('Microsoft.SqlServer.Management.Smo.Agent.JobStep') ($Job, 'ESR ODS Refresh')
    $JobStep.SubSystem = 'SSIS'
    $JobStep.Command = '/SQL "\"\ESR ODS Controller\"" /SERVER "\"'+$DesServer+'\"" /MAXCONCURRENT " -1 " /CHECKPOINTING OFF /REPORTING E'  #"c:\Scripts\getperf.ps1 '$DesServer' 60 '2199-12-31 23:59:59'"
    $JobStep.OnSuccessAction = 'QuitWithSuccess'
    $JobStep.OnFailAction = 'QuitWithFailure'
    $JobStep.DatabaseName = 'master'
    $JobStep.Create()

    $JobStepId = $JobStep.ID
    $Job.ApplyToTargetServer($ServerObject.Name)
    $Job.StartStepID = $JobStepId
    $Job.Alter()

    $JobStepSchedule = new-object ('Microsoft.SqlServer.Management.Smo.Agent.JobSchedule') ($Job, 'ESR ODS Refresh')
    $JobStepSchedule.FrequencyTypes = [Microsoft.SqlServer.Management.SMO.Agent.FrequencyTypes]::Daily
    $JobStepSchedule.FrequencyInterval = 1
    $JobStepSchedule.FrequencySubDayTypes = [Microsoft.SqlServer.Management.SMO.Agent.FrequencySubDayTypes]::Once
    $JobStepSchedule.FrequencySubDayInterval = 0
    #$JobStepSchedule.ActiveStartDate = "02/12/2015"
    $JobStepSchedule.ActiveStartDate = get-date
    $JobStepSchedule.ActiveEndDate="12/31/9999"  #No end date
    $ts1 =  New-Object -TypeName TimeSpan -argumentlist 6, 0, 0   # hours, minutes, seconds
    $JobStepSchedule.ActiveStartTimeOfDay = $ts1
    $ts2 = New-Object -TypeName TimeSpan -argumentlist 23, 59, 59  # hours, minutes, seconds
    $JobStepSchedule.ActiveEndTimeOfDay = $ts2    
    $JobStepSchedule.Create()
    
 }
####################################################GEMS ODS Refresh###########################################################
Function Create-GEMSODS
{
    param
    (
        [string]$Server,
        [string]$Instance
    )

    $DesServer=$Server
    if ($Instance -ne "")
        {
            $DesServer=$DesServer+"\"+$Instance
        }

    #$DesServer="HSA-DB-UTL17\ODS"
    #$Server='HSA-DB-UTL17'
    $ServerObject = new-object ('Microsoft.SqlServer.Management.Smo.Server') $DesServer
    #$s=new-object ('Microsoft.SqlServer.Management.Smo.Server') 'HSA-DB-UTL16\ODS'

    $Job = new-object ('Microsoft.SqlServer.Management.Smo.Agent.Job') ($ServerObject.JobServer, 'GEMS ODS Refresh')
    $Job.Description = 'Refresh GEMS_ODS database.'
    $Job.OwnerLoginName = $Server+'\ehbsqlsa'
    $Job.EventLogLevel = [Microsoft.SqlServer.Management.Smo.Agent.CompletionAction]::Never
    $Job.Create()

    $JobStep = new-object ('Microsoft.SqlServer.Management.Smo.Agent.JobStep') ($Job, 'GEMS ODS Refresh')
    $JobStep.SubSystem = 'SSIS'
    $JobStep.Command = '/SQL "\"\GEMS ODS Controller\"" /SERVER "\"'+$DesServer+'\"" /MAXCONCURRENT " -1 " /CHECKPOINTING OFF /REPORTING E'  #"c:\Scripts\getperf.ps1 '$DesServer' 60 '2199-12-31 23:59:59'"
    $JobStep.OnSuccessAction = 'QuitWithSuccess'
    $JobStep.OnFailAction = 'QuitWithFailure'
    $JobStep.DatabaseName = 'master'
    $JobStep.Create()

    $JobStepId = $JobStep.ID
    $Job.ApplyToTargetServer($ServerObject.Name)
    $Job.StartStepID = $JobStepId
    $Job.Alter()

    $JobStepSchedule = new-object ('Microsoft.SqlServer.Management.Smo.Agent.JobSchedule') ($Job, 'GEMS ODS Refresh')
    $JobStepSchedule.FrequencyTypes = [Microsoft.SqlServer.Management.SMO.Agent.FrequencyTypes]::Daily
    $JobStepSchedule.FrequencyInterval = 1
    $JobStepSchedule.FrequencySubDayTypes = [Microsoft.SqlServer.Management.SMO.Agent.FrequencySubDayTypes]::Once
    $JobStepSchedule.FrequencySubDayInterval = 0
    #$JobStepSchedule.ActiveStartDate = "02/12/2015"
    $JobStepSchedule.ActiveStartDate = get-date
    $JobStepSchedule.ActiveEndDate="12/31/9999"  #No end date
    $ts1 =  New-Object -TypeName TimeSpan -argumentlist 6, 0, 0   # hours, minutes, seconds
    $JobStepSchedule.ActiveStartTimeOfDay = $ts1
    $ts2 = New-Object -TypeName TimeSpan -argumentlist 23, 59, 59  # hours, minutes, seconds
    $JobStepSchedule.ActiveEndTimeOfDay = $ts2    
    $JobStepSchedule.Create()
    
 }
####################################################TATS ODS Refresh###########################################################
Function Create-TATSODS
{
    param
    (
        [string]$Server,
        [string]$Instance
    )

    $DesServer=$Server
    if ($Instance -ne "")
        {
            $DesServer=$DesServer+"\"+$Instance
        }

    #$DesServer="HSA-DB-UTL17\ODS"
    #$Server='HSA-DB-UTL17'
    $ServerObject = new-object ('Microsoft.SqlServer.Management.Smo.Server') $DesServer
    #$s=new-object ('Microsoft.SqlServer.Management.Smo.Server') 'HSA-DB-UTL16\ODS'

    $Job = new-object ('Microsoft.SqlServer.Management.Smo.Agent.Job') ($ServerObject.JobServer, 'TATS ODS Refresh')
    $Job.Description = 'Refresh TATS_ODS database.'
    $Job.OwnerLoginName = $Server+'\ehbsqlsa'
    $Job.EventLogLevel = [Microsoft.SqlServer.Management.Smo.Agent.CompletionAction]::Never
    $Job.Create()

    $JobStep = new-object ('Microsoft.SqlServer.Management.Smo.Agent.JobStep') ($Job, 'TATS ODS Refresh')
    $JobStep.SubSystem = 'SSIS'
    $JobStep.Command = '/SQL "\"\TATS ODS Controller\"" /SERVER "\"'+$DesServer+'\"" /MAXCONCURRENT " -1 " /CHECKPOINTING OFF /REPORTING E'  #"c:\Scripts\getperf.ps1 '$DesServer' 60 '2199-12-31 23:59:59'"
    $JobStep.OnSuccessAction = 'QuitWithSuccess'
    $JobStep.OnFailAction = 'QuitWithFailure'
    $JobStep.DatabaseName = 'master'
    $JobStep.Create()

    $JobStepId = $JobStep.ID
    $Job.ApplyToTargetServer($ServerObject.Name)
    $Job.StartStepID = $JobStepId
    $Job.Alter()

    $JobStepSchedule = new-object ('Microsoft.SqlServer.Management.Smo.Agent.JobSchedule') ($Job, 'TATS ODS Refresh')
    $JobStepSchedule.FrequencyTypes = [Microsoft.SqlServer.Management.SMO.Agent.FrequencyTypes]::Daily
    $JobStepSchedule.FrequencyInterval = 1
    $JobStepSchedule.FrequencySubDayTypes = [Microsoft.SqlServer.Management.SMO.Agent.FrequencySubDayTypes]::Once
    $JobStepSchedule.FrequencySubDayInterval = 0
    #$JobStepSchedule.ActiveStartDate = "02/12/2015"
    $JobStepSchedule.ActiveStartDate = get-date
    $JobStepSchedule.ActiveEndDate="12/31/9999"  #No end date
    $ts1 =  New-Object -TypeName TimeSpan -argumentlist 6, 0, 0   # hours, minutes, seconds
    $JobStepSchedule.ActiveStartTimeOfDay = $ts1
    $ts2 = New-Object -TypeName TimeSpan -argumentlist 23, 59, 59  # hours, minutes, seconds
    $JobStepSchedule.ActiveEndTimeOfDay = $ts2    
    $JobStepSchedule.Create()
    
 }
####################################################UDS ODS Refresh###########################################################
Function Create-UDSODS
{
    param
    (
        [string]$Server,
        [string]$Instance
    )

    $DesServer=$Server
    if ($Instance -ne "")
        {
            $DesServer=$DesServer+"\"+$Instance
        }

    #$DesServer="HSA-DB-UTL17\ODS"
    #$Server='HSA-DB-UTL17'
    $ServerObject = new-object ('Microsoft.SqlServer.Management.Smo.Server') $DesServer
    #$s=new-object ('Microsoft.SqlServer.Management.Smo.Server') 'HSA-DB-UTL16\ODS'

    $Job = new-object ('Microsoft.SqlServer.Management.Smo.Agent.Job') ($ServerObject.JobServer, 'UDS ODS Refresh')
    $Job.Description = 'Refresh UDS_ODS database.'
    $Job.OwnerLoginName = $Server+'\ehbsqlsa'
    $Job.EventLogLevel = [Microsoft.SqlServer.Management.Smo.Agent.CompletionAction]::Never
    $Job.Create()

    $JobStep = new-object ('Microsoft.SqlServer.Management.Smo.Agent.JobStep') ($Job, 'UDS ODS Refresh')
    $JobStep.SubSystem = 'SSIS'
    $JobStep.Command = '/SQL "\"\UDS ODS Controller\"" /SERVER "\"'+$DesServer+'\"" /MAXCONCURRENT " -1 " /CHECKPOINTING OFF /REPORTING E'  #"c:\Scripts\getperf.ps1 '$DesServer' 60 '2199-12-31 23:59:59'"
    $JobStep.OnSuccessAction = 'QuitWithSuccess'
    $JobStep.OnFailAction = 'QuitWithFailure'
    $JobStep.DatabaseName = 'master'
    $JobStep.Create()

    $JobStepId = $JobStep.ID
    $Job.ApplyToTargetServer($ServerObject.Name)
    $Job.StartStepID = $JobStepId
    $Job.Alter()

    $JobStepSchedule = new-object ('Microsoft.SqlServer.Management.Smo.Agent.JobSchedule') ($Job, 'UDS ODS Refresh')
    $JobStepSchedule.FrequencyTypes = [Microsoft.SqlServer.Management.SMO.Agent.FrequencyTypes]::Daily
    $JobStepSchedule.FrequencyInterval = 1
    $JobStepSchedule.FrequencySubDayTypes = [Microsoft.SqlServer.Management.SMO.Agent.FrequencySubDayTypes]::Once
    $JobStepSchedule.FrequencySubDayInterval = 0
    #$JobStepSchedule.ActiveStartDate = "02/12/2015"
    $JobStepSchedule.ActiveStartDate = get-date
    $JobStepSchedule.ActiveEndDate="12/31/9999"  #No end date
    $ts1 =  New-Object -TypeName TimeSpan -argumentlist 6, 0, 0   # hours, minutes, seconds
    $JobStepSchedule.ActiveStartTimeOfDay = $ts1
    $ts2 = New-Object -TypeName TimeSpan -argumentlist 23, 59, 59  # hours, minutes, seconds
    $JobStepSchedule.ActiveEndTimeOfDay = $ts2    
    $JobStepSchedule.Create()
    
 }
