$test = @{ 
                 AllNodes = @(        
                              @{     
                                 NodeName = "localhost" 
                                 # Allows credential to be saved in plain-text in the the *.mof instance document.                             
                                    PSDscAllowPlainTextPassword = $true
                                    PSDscAllowDomainUser = $true
                              
                              } 
                            )  
              } 