"C:\Program Files (x86)\Log Parser 2.2\logparser.exe" "SELECT * INTO Stg_IISLogs FROM \\hrsafs.reisys.com\adminftp\IISLOGS\IISLOGS_Internal\*.log WHERE cs-uri-stem like '%%Interface/Common/AccessControl/Login.aspx%%' or or cs(Referer) like '%%Interface/Common/AccessControl/Login.aspx%%'"  -i:iisw3c -o:SQL -recurse -server:hsa-db-admin -database:IntEnvAnalysis -username:sa -password:#GemsUser1 -createTable: ON  