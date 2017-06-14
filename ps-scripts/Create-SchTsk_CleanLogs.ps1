<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2014 v4.1.75
	 Created on:   	2/4/2015 @ 11:37 AM
	 Created by:   	Gordon Coveney
	 Organization: 	REI Systems, inc.
	 Filename: Create-SchTask_CleanLogs.ps1    	
	===========================================================================
	.DESCRIPTION
		Createa a scheduled task to execute "CleanLogs.ps1" at 3:00am every day.
#>
$action = New-ScheduledTaskAction -execute "Powershell.exe"  -argument "-NoProfile -file ""\\hrsafs.reisys.com\ise\scripts\cleanlogs.ps1"""
$trigger = New-ScheduledTaskTrigger -daily -at 3:00AM
Register-ScheduledTask -TaskName REI-CleanLogs -Trigger $trigger -Action $action -description "Recursively delete files in 'Y:\Logs' that are 1 wk old or older" -User "gemsapp" -Password "#GemsUser1" -RunLevel Highest
