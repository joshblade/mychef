Import-Module WebAdministration
"Windows Authentication Before"
Get-WebConfiguration -filter /system.webServer/security/authentication/windowsAuthentication | Format-List *
Set-WebConfiguration -filter system.webserver/security/authentication/windowsAuthentication -metadata overrideMode -value Allow 
"Windows Authentication After"
Get-WebConfiguration -filter /system.webServer/security/authentication/windowsAuthentication | Format-List *

"anonymousAuthentication Before"
Get-WebConfiguration -filter /system.webServer/security/authentication/anonymousAuthentication | Format-List *
Set-WebConfiguration -filter system.webserver/security/authentication/anonymousAuthentication -metadata overrideMode -value Allow
"anonymousAuthentication After"
Get-WebConfiguration -filter /system.webServer/security/authentication/anonymousAuthentication | Format-List *