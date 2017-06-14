#Description: Search for processes on remote computer and kill the process
$servers = 'ehb-appg1-p1', 'ehb-appg1-p2', 'ehb-appg1-p3', 'ehb-app-qa3', 'ehb-app-qa4', 'ehb-app-os3', 'ehb-app-os4'
#Get-Content 'Y:\rburke\zp4servers.txt'
foreach($comp in $servers){

invoke-command -computer "$comp" {get-process -ComputerName $comp | where 'processname' -EQ 'ZP4' | stop-process -Force}

}

<#
ZP4 Servers
ehb-appg1-p1
ehb-appg1-p2
ehb-appg1-p3
ehb-appg2-p1
ehb-appg2-p2
ehb-appg3-p1
ehb-appg3-p2
ehb-appg4-p4
ehb-appg4-p5
ehb-appg5-p3
ehb-appg5-p4
ehb-app-os3
ehb-app-os4#>