<#
.SYNOPSIS
   Install new ZP4Net application
#DESCRIPTION: This script deploys the new ZP4Net solution, renames the old solution, and adds the user permissions for IIS_IUSRS, run locally

.URL: http://wiki.reisys.com:8080/display/HPLFM/ZP4+Upgrade+August+2016
#>
$domain = (Get-WmiObject Win32_ComputerSystem).Domain
IF($domain -eq 'REISYS.com'){$SourceShare = '\\hrsafs.reisys.com\ise\Prerequisites\ZP4Net'}
ELSEIF($domain -eq 'amer.reisystems.com'){$SourceShare = '\\hrsafs.reisys.com\ise\Prerequisites\ZP4Net'}  
ELSEIF($domain -eq 'HRSA.gov') {$SourceShare = "\\ehb-fs1\ISE\Prerequisites\ZP4Net"}
ELSEIF($domain -eq 'OITNET.local') {$SourceShare = "\\ehb-perf-p1\ISE\Prerequisites\ZP4Net"}

############################################
#Rename old solutions, the uninstall does not seem to work very well
Rename-Item -Path 'c:\zp4' -NewName 'zp4old' 
Rename-Item -Path 'c:\zp4_data' -NewName 'ZP4_DATAOLD'
#Create the required folder structure, and copy required files and folders to their destination
mkdir 'y:\ZP4Net'
Y:
cd 'y:\ZP4Net'

############################################
#Copy the required files into the required directories
Copy-Item -Path "$SourceShare\*" -Exclude 'zp4.ini' -Destination 'y:\zp4net'
Copy-item -Path "$SourceShare\KeepAlive\ZP4CSharp.exe" -Destination 'y:\zp4net\keepalive'
Copy-Item -Path 'y:\zp4net\zp4.dll' -Destination 'c:\windows\' -Force
Copy-Item -Path 'y:\zp4net\zp464.dll' -Destination 'c:\windows\' -Force

############################################
#Rename the old ini file
Rename-Item -Path 'c:\windows\zp4.ini' -NewName 'zp4.inioldrb'
#Create the new ini file, and add the required content
New-Item 'c:\windows\zp4.ini' -ItemType 'file' -Force
#Non-Prod Account=545896
#Prod Account=546084
$IniContent = @"
[home]
home='Y:\ZP4NET'
[Options]
Account=545896
"@
Set-Content -Path 'c:\windows\zp4.ini' -Value $IniContent

############################################
#set the ACL for the iusr user
$Acl = Get-Acl 'y:\zp4net'
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS", "modify", "ContainerInherit,ObjectInherit", "None", "Allow")
$Acl.SetAccessRule($Ar)
Set-Acl 'y:\zp4net' $Acl


############################################
#Non-Prod Password: 'VnsmN4rN'
#Prod Password: 'jJ4KVngr'
$login = 'Y:\ZP4NET\login.exe'
$pass = 'VnsmN4rN'
Add-Type -AssemblyName Microsoft.VisualBasic
[System.Reflection.Assembly]::LoadWithPartialName("'Microsoft.VisualBasic")
start-process $login
Start-Sleep -Seconds 5
$p=get-process | where {$_.Description -like 'Login to ZP4net'}
[Microsoft.VisualBasic.Interaction]::AppActivate($p.ID)
[System.Windows.Forms.SendKeys]::SendWait("$pass{TAB}{TAB}{ENTER}")
[System.Windows.Forms.SendKeys]::SendWait("{F5}{ENTER}")

Start-Sleep -Seconds 2
############################################
#Call the keepalive application
$keepalive = & 'Y:\ZP4Net\KeepAlive\ZP4CSharp.exe' 
Invoke-Command -RunAsAdministrator $keepalive

<#
NONProd
username
545896
password
VnsmN4rN 

#>
