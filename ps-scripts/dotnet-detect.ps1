#Description: This script attempts to identify an absolute way of getting the currently installed version of DOTNET
###Begin Script
$script = {
$a = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\' -name 'release'
$release = $a.Release

IF($release -eq '378389'){
Echo "$env:COMPUTERNAME has .NET Framework 4.5 installed"
}

IF($release -eq '378675'){
Echo "$env:COMPUTERNAME has .NET Framework 4.5.1 installed with Windows 8.1 installed"
}
IF($release -eq '378758'){
Echo "$env:COMPUTERNAME has .NET Framework 4.5.1 installed on Windows 8, Windows 7 SP1, or Windows Vista SP2 installed"
}
IF($release -eq '379893'){
Echo "$env:COMPUTERNAME has .NET Framework 4.5.2 installed"
}
IF($release -eq '393295'){
Echo "$env:COMPUTERNAME has .NET Framework 4.6 installed with Windows 10 installed"
}
IF($release -eq '393297'){
Echo "$env:COMPUTERNAME has .NET Framework 4.6 installed on all other Windows OS versions installed"
}
IF($release -eq '394254'){
Echo "$env:COMPUTERNAME has .NET Framework 4.6.1 installed on Windows 10 installed"
}
IF($release -eq '394271'){
Echo "$env:COMPUTERNAME has .NET Framework 4.6.1 installed on all other Windows OS versions installed"
}

}

$servers = Get-Content "Y:\rburke\dotNetUpgradeserverlist.txt"
#Get-Content "Y:\rburke\dotNetUpgradeserverlist.txt"
#"hsa-is-utl26.reisys.com"
foreach($server in $servers) {
Invoke-Command -ComputerName $server -ScriptBlock $script

}
###End Script