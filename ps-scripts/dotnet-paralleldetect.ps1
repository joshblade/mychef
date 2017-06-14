#Synopsis: This script attempts to identify an absolute way of getting the currently installed version of DOTNET
###Begin Script
$script = {
$outputpath = "\\hsa-sbx-dev\Y$\rburke\paratest.csv"
$a = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\' -name 'release'
$release = $a.Release

IF($release -eq '378389'){
$output = "$env:COMPUTERNAME" + " " + "$release"
$output | Export-Csv "$outputpath" -Append -NoTypeInformation
Echo "$env:COMPUTERNAME has .NET Framework 4.5 installed"
}

IF($release -eq '378675'){
$output = "$env:COMPUTERNAME" + " " + "$release"
$output | Export-Csv "$outputpath" -Append -NoTypeInformation
Echo "$env:COMPUTERNAME has .NET Framework 4.5.1 installed with Windows 8.1 installed"
}
IF($release -eq '378758'){
$output = "$env:COMPUTERNAME" + " " + "$release"
$output | Export-Csv "$outputpath" -Append -NoTypeInformation
Echo "$env:COMPUTERNAME has .NET Framework 4.5.1 installed on Windows 8, Windows 7 SP1, or Windows Vista SP2 installed"
}
IF($release -eq '379893'){
$output = "$env:COMPUTERNAME" + " " + "$release"
$output | Export-Csv "$outputpath" -Append -NoTypeInformation
Echo "$env:COMPUTERNAME has .NET Framework 4.5.2 installed"
}
IF($release -eq '393295'){
$output = "$env:COMPUTERNAME" + " " + "$release"
$output | Export-Csv "$outputpath" -Append -NoTypeInformation
Echo "$env:COMPUTERNAME has .NET Framework 4.6 installed with Windows 10 installed"
}
IF($release -eq '393297'){
$output = "$env:COMPUTERNAME" + " " + "$release"
$output | Export-Csv "$outputpath" -Append -NoTypeInformation
Echo "$env:COMPUTERNAME has .NET Framework 4.6 installed on all other Windows OS versions installed"
}
IF($release -eq '394254'){
$output = "$env:COMPUTERNAME" + " " + "$release"
$output | Export-Csv "$outputpath" -Append -NoTypeInformation
Echo "$env:COMPUTERNAME has .NET Framework 4.6.1 installed on Windows 10 installed"
}
IF($release -eq '394271'){
$output = "$env:COMPUTERNAME" + " " + "$release"
$output | Export-Csv "$outputpath" -Append -NoTypeInformation
Echo "$env:COMPUTERNAME has .NET Framework 4.6.1 installed on all other Windows OS versions installed"
}

}
$PSDefaultParameterValues = @{'Receive-Job:Keep'=$true}
$servers = Get-Content "Y:\rburke\dotNetUpgradeserverlist.txt"
#Get-Content "Y:\rburke\dotNetUpgradeserverlist.txt"
#"hsa-is-utl26.reisys.com"
foreach($server in $servers) {
#Start-Job -ScriptBlock $script -ArgumentList $server

Invoke-Command -ComputerName $server -ScriptBlock $script

}
<#get-job | wait-job
$out = get-job | receive-job
$out | export-csv y:\rburke\paratest.csv#>
###End Script