﻿#--------------------------------------------------------------------------------- 

Configuration AdjustVirtualMemory
{
    Param
    (
        #Target nodes to apply the configuration  
        [String[]]$ComputerName = $env:COMPUTERNAME
    )
    
    Import-DSCResource -ModuleName xSystemVirtualMemory

    Node $ComputerName
    {
        xSystemVirtualMemory AdjustVirtualMemoryExample
        {
            ConfigureOption = "CustomSize"
            InitialSize = 1000
            MaximumSize = 2000
            DriveLetter = "C:"
        }
    }
}

AdjustVirtualMemory
Start-DscConfiguration -Path .\AdjustVirtualMemory  -Wait -Force -Verbose