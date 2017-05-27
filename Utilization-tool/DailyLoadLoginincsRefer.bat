for /f %%x in ('wmic path win32_localtime get /format:list ^| findstr "="') do set %%x
set todaysdate=%Year%-0%Month%-%Day%

"C:\Program Files (x86)\Log Parser 2.2\logparser.exe" "SELECT * INTO Stg_IISLogs FROM \\hrsafs.reisys.com\adminftp\IISLOGS\IISLOGS_Internal\*.log WHERE cs(Referer) like '%%Interface/Common/AccessControl/Login.aspx%%' and to_string(to_date(date),'yyyy-MM-dd') ='%ToDaysDate%'"  -i:iisw3c -o:SQL -recurse -server:hsa-db-admin -database:IntEnvAnalysis -username:sa -password:#GemsUser1 -createTable: ON  