$user = "devopsadmin"
$password = 'Password123$'
#2016 requires 12 chars: ReiGem#GemsUser1
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword)

$chefSession = New-SSHSession -ComputerName 13.90.248.220 -Credential $cred


#########Works
$cmds = 'cd /home/devopsadmin/chef-starter/.chef', 'sh /home/devopsadmin/chef-starter/.chef/bootstrapPS.sh'
Invoke-SSHCommand -SSHSession $chefSession -Command ($cmds -join ';')
#########




Invoke-SSHCommand -SSHSession $chefSession -Command $cmd3
$cmds = 'cd /home/devopsadmin/chef-starter/.chef', 'sh /home/devopsadmin/chef-starter/.chef/psrunlist.sh'
$cmd2 = 'knife node run_list add rei-azure-pdc ''recipe[PSModules::Default]'''
$cmd3 = 'sh /home/devopsadmin/chef-starter/.chef/bootstrapPS.sh'