(get-wmiobject Win32_ComputerSystem).Name

Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name NetworkDtcAccess -Value 1 #Network DTC Access
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name NetworkDtcAccessAdmin -Value 1 #Allow Remote Administration
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name XaTransactions -Value 0  #Enable XA Transaction
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name NetworkDtcAccessTransactions -Value 1  #Allow Inbound Allow Outbound
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name NetworkDtcAccessOutbound -Value 1 #Allow Outbound
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name NetworkDtcAccessClients -Value 1 #Allow Remote Client
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name NetworkDtcAccessInbound -Value 1 #Allow Inbound
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name LuTransactions  -Value 1 #Allow Inbound
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\ -Name AllowOnlySecureRpcCalls -Value 0
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\ -Name FallbackToUnsecureRPCIfNecessary -Value 0
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\ -Name TurnOffRpcSecurity -Value 1
Get-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security
Get-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\ 

if ((Test-Path HKLM:\Software\Microsoft\Rpc\Internet).Equals($false)) 
{
    New-Item -Path HKLM:\Software\Microsoft\Rpc\Internet
    New-ItemProperty -Path HKLM:\Software\Microsoft\Rpc\Internet -Name Ports -PropertyType MultiString -Value 5000-5200
    New-ItemProperty -Path HKLM:\Software\Microsoft\Rpc\Internet -Name PortsInternetAvailable -PropertyType String -Value Y
    New-ItemProperty -Path HKLM:\Software\Microsoft\Rpc\Internet -Name UseInternetPorts -PropertyType String -Value Y
} 
Get-ItemProperty -Path HKLM:\Software\Microsoft\Rpc\Internet
