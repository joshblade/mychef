$test = @{ 
                 AllNodes = @(        
                              @{     
                                 NodeName = "localhost" 
                                 # Allows credential to be saved in plain-text in the the *.mof instance document.                             
                                    PSDscAllowPlainTextPassword = $true
                                    PSDscAllowDomainUser = $true
                                  <#  GemsAppPassword = "#GemsUser1"
                                    EHBSSASPassword = "#GemsUser1"
                                    EHBSQLSAPassword = "#GemsUser1"
                                    SQLSAPassword = "#GemsUser1"
                                    eisuserPassword = "#GemsUser1"#>
                                
                              } 
                            )  
              }
               
              Configuration sqltest{

              script SBXTXN-Server-Logins{
        
         Setscript ={
         $SBXTXNServerLogins = Invoke-Sqlcmd -InputFile 'Y:\SQLAutomation\Step-1SBX TXN Server Logins.sql' -ServerInstance 'hsa-sbx-dev\ods'
         Invoke-expression $SBXTXNServerLogins
        }
         TestScript = "Test-Path -path 'C:\Windows\System32\msxml6.dll'"
         Getscript = {@(pathtest = (Test-Path -Path "C:\Windows\System32\msxml6.dll"))}
        }
        }
        }
       sqltest -ConfigurationData $test -OutputPath 'Y:\rburke\DB'



       <#
       Invoke-Sqlcmd -InputFile "Y:\SQLAutomation\Step-1SBX TXN Server Logins.sql" -ServerInstance "hsa-sbx-dev\ods"
Invoke-Sqlcmd -InputFile "Y:\SQLAutomation\SBX ODS Server Logins" -ServerInstance "hsa-sbx-dev\ods"

Invoke-Sqlcmd -InputFile "Y:\SQLAutomation\SBX TXN Configure Distribution.sql" -ServerInstance "hsa-sbx-dev\ods"
Invoke-Sqlcmd -InputFile "Y:\SQLAutomation\SBX ODS Configure Distribution.sql" -ServerInstance "hsa-sbx-dev\ods"

Invoke-Sqlcmd -InputFile "Y:\SQLAutomation\Step 3_ Linked Server Creation for TXN.sql" -ServerInstance "hsa-sbx-dev\ods"
Invoke-Sqlcmd -InputFile "Y:\SQLAutomation\Step 3_ Linked Server Creation in ODS.sql" -ServerInstance "hsa-sbx-dev\ods"

Invoke-Sqlcmd -InputFile "Y:\SQLAutomation\Step 4_ Database Mail Profile for TXN.sql" -ServerInstance "hsa-sbx-dev\ods"

       #>