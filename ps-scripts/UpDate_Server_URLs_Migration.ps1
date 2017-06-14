<#
$SQLServer is where we get our List of Remote Servers where we intend to execute scripts (use if needed) 
$SQLDBName is our Central Server Admin DB
$Serverquery: Provide filtering conditions as needed to acquire desired servers for remote execution. Tested with SBX Dev only.
$ServerDataSet: This is the actual List of Servers that we will iterate

For Each Server in the list we run our SQL Script remotely (via PS execution)
#>




$SQLServer = "HSA-DB-ADMIN.reisys.com"
$SQLDBName = "EHBAdmin"
$Serverquery = "select LookupCode, DbTxnServer from EHBAdmin.dbo.LU_ADMN_Servers WHERE Environment_Abbr like '%utl19' 
And ActiveFlag = 1 "
#And LookupCode = 76
 #$Remotequery = Invoke-Sqlcmd -Query $Serverquery -ServerInstance $SQLServer
$ServerDataSet = New-Object System.Data.DataSet


$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = “Server=$SQLServer;Database=$SQLDBName;Integrated Security=True ”
 
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $Serverquery
$SqlCmd.Connection = $SqlConnection
 
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
 
 
$SqlAdapter.Fill($ServerDataSet)
 
$SqlConnection.Close()




foreach ($row in $ServerDataSet.Tables[0].Rows)
 
{
    $remoteserver = $row[1].ToString().Trim() 
    #$remoteserver = $remoteserver.Replace("\TXN",".reisys.com\TXN")

    Write-Host $row[0].ToString().Trim()  $remoteserver "is the servername"
    Invoke-Sqlcmd -InputFile "\\hrsafs.REISYS.COM\ISE\DB_Refresh_Scripts\TXN\URL_migration_Update_ALL.sql" -ServerInstance $remoteserver -Verbose  
     #Write-Host "-Query $Serverquery -ServerInstance" $row[1].ToString().Trim() 
 
 }