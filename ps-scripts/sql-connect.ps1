#Description: This is a powershell script for connecting to SQL, it can be used with other scripts
$SQLServer = "hsa-db-admin" #use Server\Instance for named SQL instances! 
$SQLDBName = "ehbadmin"
$SqlQuery = "select * from LU_ADMN_Servers WHERE Environment_Abbr LIKE '%SBX%' "

$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Data Source=hsa-db-admin;Initial Catalog=ehbadmin;Integrated Security=SSPI;"
 
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
 
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
 
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)
 
$SqlConnection.Close()
 
clear
$DataSet
 
$DataSet.Tables[0] | Format-Table -AutoSize 