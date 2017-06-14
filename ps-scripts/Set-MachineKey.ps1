function MyFunction ($path)
{
    $machineconfig=[xml](get-content($path))
    $systemweb=$machineconfig.configuration["system.web"]
    if ($systemweb.machinekey -eq $null)
    {
        $mk=$machineconfig.CreateElement("machineKey")
        $mk.SetAttribute("validationKey","C172BD7C078161C2E773FD6B7C8A54A2404321F6B24F055B8B3FE192D01896C0FA0625249C378EBCAC245EEBFC7EEDD98C476611D72212B6D42044D3D713A233")
        $mk.SetAttribute("decryptionKey","50BEF71195B75AC778AF26905528C2EF4951D39DFCD2F0F798763CE4496D7D3F")
        $mk.SetAttribute("validation","SHA1")
        $mk.SetAttribute("decryption","AES")
        $systemweb.AppendChild($mk)
        $machineconfig.Save($path)
        "MachineKey added to $path"
    } else
    {
        "MachineKey already exists in $path"
    }
    $systemweb.machinekey |Format-List
    
}

MyFunction("C:\Windows\Microsoft.NET\Framework\v2.0.50727\CONFIG\machine.config")
MyFunction("C:\Windows\Microsoft.NET\Framework\v4.0.30319\CONFIG\machine.config")
MyFunction("C:\Windows\Microsoft.NET\Framework64\v2.0.50727\CONFIG\machine.config")
MyFunction("C:\Windows\Microsoft.NET\Framework64\v4.0.30319\CONFIG\machine.config")