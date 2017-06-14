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
mkdir "X:\Program Files\Microsoft SQL Server\TXN\MSSQL11\MSSQL\Data"
Exit-PSSession
Remove-PSSession -Session $session
<#
."Y:\UAT\Script\Automate-ODS-package-deployment.ps1"
Walk-SubFolder -RootFolder "Y:\SSIS Packages" -DeployServer "hsa-sbx-dev" -ServerInstance "ods"
#>




#TXN
#create database logins for, machine accounts db users/groups
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\1 Create Logins.SQL" -ServerInstance "$server\$instance"
#grant SA to specific users
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\2 Grant Admin Roles to Selected Users.SQL" -ServerInstance "$server\$instance"
#linked servers
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\3 Create Linked server ODS.SQL" -ServerInstance "$server\$instance"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\4 Create Linked server Admin.SQL" -ServerInstance "$server\$instance"
#mail setup
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\5 Setup DB Mail.SQL" -ServerInstance "$server\$instance"
#change connection properties
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\6 Update Server Connection Properties.SQL" -ServerInstance "$server\$instance"
#change SQL server settings
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\7 Update DB compatibility DB Memory and Compress Backup Settings.SQL" -ServerInstance "$server\$instance"
#restart SQL server service to apply changes
$service = 'SQL Server (TXN)'
get-service -computername $server -name $service | restart-service -force -verbose
$service = 'SQL Server Agent (TXN)'
get-service -computername $server -name $service | restart-service -force -verbose
#create jobs
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\9 Create TXN Refresh Job.SQL" -ServerInstance "$server\$instance"

Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\10 Restore EHBAdmin DB.SQL" -ServerInstance "$server\$instance"

Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\11 Update EHBAdmin DB to Server Name.SQL" -ServerInstance "$server\$instance"

Invoke-Expression "C:\Users\nikolay.sorokin\Documents\PowerShell\SSIS Deployment TXN.ps1"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\13 Start TXN Refresh Job.SQL" -ServerInstance "$server\$instance"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\14 Create Other Jobs.SQL" -ServerInstance "$server\$instance"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\15 Run Backup Jobs.SQL" -ServerInstance "$server\$instance"
#foreach ($file in get-ChildItem *.bak) { ./RenameBackup.ps1 $file.name }
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\17 Disable Replication TXN.SQL" -ServerInstance "$server\$instance"

#ODS
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ODS\1 Create Logins.SQL" -ServerInstance "$server\$instance2"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ODS\2 Grant Admin Roles to Selected Users.SQL" -ServerInstance "$server\$instance2"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ODS\3 Create Linked server TXN.SQL" -ServerInstance "$server\$instance2"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ODS\4 Create Linked server Admin.SQL" -ServerInstance "$server\$instance2"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ODS\5 Setup DB Mail.SQL" -ServerInstance "$server\$instance2"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ODS\6 Update Server connection properties.SQL" -ServerInstance "$server\$instance2"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ODS\7 Update DB compatibility DB Memory and Compress Backup Settings.SQL" -ServerInstance "$server\$instance2"
$service = 'SQL Server (ODS)'
get-service -computername $server -name $service | restart-service -force -verbose
$service = 'SQL Server Agent (ODS)'
get-service -computername $server -name $service | restart-service -verbose
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ODS\9 Create ODS Jobs.SQL" -ServerInstance "$server\$instance2"
Invoke-Expression C:\Users\nikolay.sorokin\Documents\PowerShell\SSIS Deployment ODS.ps1
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ODS\11 Restore Dummy BHCMIS_ODS DB.SQL" -ServerInstance "$server\$instance2"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ODS\12 Run GEMS_ODS Refresh Job.SQL" -ServerInstance "$server\$instance2"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ODS\13 Run BHCMIS_ODS Refresh Job.SQL" -ServerInstance "$server\$instance2"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ODS\14 Run Other ODS Refresh Jobs.SQL" -ServerInstance "$server\$instance2"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ODS\15 Shrink Logs.SQL" -ServerInstance "$server\$instance2"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ODS\16 Manual Restore Other DB.SQL" -ServerInstance "$server\$instance2"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ODS\17 Map Orphan Users.SQL" -ServerInstance "$server\$instance2"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ODS\18 Shrink Logs.SQL" -ServerInstance "$server\$instance2"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ODS\19 Disable Replication ODS.SQL" -ServerInstance "$server\$instance2"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\ODS\20 Configure Distribution on ODS.SQL" -ServerInstance "$server\$instance2"

#TXN
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\18 Configure Distribution on TXN.SQL" -ServerInstance "$server\$instance"
Invoke-Sqlcmd -InputFile "\\hrsafs\ISE\DB_Refresh_Scripts\TXN\19 Create Replication.SQL" -ServerInstance "$server\$instance"

<#
mkdir "Y:\SSIS Package Logs\AQR\ODS"
mkdir "Y:\SSIS Package Logs\BHCMIS\ODS"
mkdir "Y:\SSIS Package Logs\BHPR\ODS"
mkdir "Y:\SSIS Package Logs\BSV\ODS"
mkdir "Y:\SSIS Package Logs\CHGME\ODS"
mkdir "Y:\SSIS Package Logs\ESR\ODS"
mkdir "Y:\SSIS Package Logs\HRSA EHBs\ODS"
mkdir "Y:\SSIS Package Logs\TATS\ODS"
#> 
