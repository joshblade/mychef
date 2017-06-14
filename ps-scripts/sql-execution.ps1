$server = read-host -Prompt "Enter the server name"
$instance = "txn"
$instance2 = "ods"
<#
$session = New-PSSession -ComputerName $server
Enter-PSSession $session
#
x:
mkdir "X:\Program Files\Microsoft SQL Server\ODS\MSSQL11\MSSQL\Data"
mkdir "X:\Program Files\Microsoft SQL Server\TXN\MSSQL11\MSSQL\Data"
Exit-PSSession
Remove-PSSession -Session $session
<#
."Y:\UAT\Script\Automate-ODS-package-deployment.ps1"
Walk-SubFolder -RootFolder "Y:\SSIS Packages" -DeployServer "hsa-sbx-dev" -ServerInstance "ods"
#>





<#
Create-AQRJob -Server "$server" -instance "$instance2"
Create-BHCMISJob -Server $server -instance $instance2
Create-BHPRJob -Server $server -instance $instance2
Create-CHGMEODS -Server $server -instance $instance2
Create-ESRODS -Server $server -instance $instance2
Create-GEMSODS -Server $server -instance $instance2
Create-TATSODS -Server $server -instance $instance2
Create-UDSODS -Server $server -instance $instance2
#>


#TXN
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\Step 1_SBX TXN Server Logins.sql" -ServerInstance "$server\$instance"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\Step 3_ Linked Server Admin Creation.sql" -ServerInstance "$server\$instance"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\Step 3_ Linked Server Creation for TXN.sql" -ServerInstance "$server\$instance"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\Step 4_ Database Mail Profile for TXN.sql" -ServerInstance "$server\$instance"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\Step 5_ Server Connection Properties for TXN.sql" -ServerInstance "$server\$instance"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\Step 6_ All DBs Compatibility for 2012 for TXN.sql" -ServerInstance "$server\$instance"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\Step 7_TXN Refresh Job.sql" -ServerInstance "$server\$instance"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\Step 55_Restore EHBAdmin.sql" -ServerInstance "$server\$instance"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\Step 56_Update EHBAdmin.sql" -ServerInstance "$server\$instance"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\Step 57_Start TXN Refresh.sql" -ServerInstance "$server\$instance"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\Step 8_Environment Jobs TXN.sql" -ServerInstance "$server\$instance"


#ODS
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ods\JOBNAME" -ServerInstance "$server\$instance2"

#TXN 1-8
#TXN Refresh
#ODS 1-8
