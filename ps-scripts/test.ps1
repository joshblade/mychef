$exeToRun = $PSScriptRoot + '\\hrsafs.reisys.com\ise\Tools\RMStudio\VS2015\Update_1\Deployment\rm_DeploymentMsdn.exe'
$username = 'reisys\tfs_user'
$password = '!!w3lc0mTU'
$url = 'https://hrsarm.reisys.com/'
$p = Start-Process $exeToRun -ArgumentList "/q" -Wait -NoNewWindow -PassThru


if( $p.HasExited -and $p.ExitCode -eq 0 )
{
Write-Output 'Deployment Agent Installed'
}

$pathToConfExe = 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\Release Management\bin\DeploymentAgentConfig.exe'
#(get-itemProperty 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\ReleaseManagement\14.0\Deployer\').InstallDir + 'bin\DeploymentAgentConfig.exe'

$arguments = '/Username:' + $username + ' /Password:' + $password + ' /ReleaseServerURL:' + $url

$p2 = Start-Process $pathToConfExe -ArgumentList $arguments -Wait -NoNewWindow -PassThru

if( $p2.HasExited -and $p2.ExitCode -eq 0 )
{
Write-Output 'Deployment Agent Configured'
}
