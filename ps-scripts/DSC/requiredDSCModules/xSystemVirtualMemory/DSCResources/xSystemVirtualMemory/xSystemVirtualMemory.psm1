#--------------------------------------------------------------------------------- #The sample scripts are not supported under any Microsoft standard support #program or service. The sample scripts are provided AS IS without warranty  #of any kind. Microsoft further disclaims all implied warranties including,  #without limitation, any implied warranties of merchantability or of fitness for #a particular purpose. The entire risk arising out of the use or performance of  #the sample scripts and documentation remains with you. In no event shall #Microsoft, its authors, or anyone else involved in the creation, production, or #delivery of the scripts be liable for any damages whatsoever (including, #without limitation, damages for loss of business profits, business interruption, #loss of business information, or other pecuniary loss) arising out of the use #of or inability to use the sample scripts or documentation, even if Microsoft #has been advised of the possibility of such damages #--------------------------------------------------------------------------------- 

Function SetPageFileSize
{
	Param($DL,$InitialSize,$MaximumSize)
	
	#The AutomaticManagedPagefile property determines whether the system managed pagefile is enabled. 
	#This capability is not available on windows server 2003,XP and lower versions.

	$IsAutomaticManagedPagefile = Get-WmiObject -Class Win32_ComputerSystem |Foreach-Object{$_.AutomaticManagedPagefile}
    
    #If the value of AutomaticManagedPageFile is True, we need to set it as False, because Only if it is NOT managed by the system and will also allow you to change the page file size.
	If($IsAutomaticManagedPagefile)
	{
		$SystemInfo = Get-WmiObject -Class Win32_ComputerSystem -EnableAllPrivileges
		$SystemInfo.AutomaticManagedPageFile = $false
        
        #Use the Put method to make the configuration change effective.
		[Void]$SystemInfo.Put()
	}
	
	#configuring the page file size
	$PageFile = Get-WmiObject -Class Win32_PageFileSetting -Filter "SettingID='pagefile.sys @ $DL'"
	
	
		If($PageFile -ne $null)
		{
			$PageFile.Delete()
		}

		Set-WmiInstance -Class Win32_PageFileSetting -Arguments @{name="$DL\pagefile.sys"; InitialSize = 0; MaximumSize = 0} -EnableAllPrivileges | Out-Null
			
		$PageFile = Get-WmiObject Win32_PageFileSetting -Filter "SettingID='pagefile.sys @ $DL'"
			
		$PageFile.InitialSize = $InitialSize
		$PageFile.MaximumSize = $MaximumSize
		[Void]$PageFile.Put()
			
		Write-Warning "Pagefile configuration changed on target computer. The computer must be restarted for the changes to take effect."

}


function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[ValidateSet("AutoManagePagingFile","CustomSize","SystemManagedSize","NoPagingFile")]
		[System.String]
		$ConfigureOption
	)

    #The AutomaticManagedPagefile property determines whether the system managed pagefile is enabled. 
    $IsAutomaticManagedPagefile = Get-WmiObject -Class Win32_ComputerSystem |Foreach-Object{$_.AutomaticManagedPagefile}
    #The PageSetting variable determines whether the page file exist.
    $PageSetting = Get-WmiObject -Class Win32_PageFileSetting

    If($PageSetting -eq $null)
    {
        If($IsAutomaticManagedPagefile)
        {
            $Option = "AutoManagePagingFile"
        }
        Else
        {
            $Option = "NoPagingFile"
        }
    }
    Else
    {
        If($PageSetting.MaximumSize -eq 0)
        {
            $Option = "SystemManagedSize"
        }
        Else
        {
            $Option = "CustomSize"
        }
    }
    
	$returnValue = @{
		ConfigureOption = $Option
	}

	$returnValue
}


function Set-TargetResource
{
	[CmdletBinding(SupportsShouldProcess=$true)]
	param
	(
		[parameter(Mandatory = $true)]
		[ValidateSet("AutoManagePagingFile","CustomSize","SystemManagedSize","NoPagingFile")]
		[System.String]
		$ConfigureOption,

		[System.UInt32]
		$InitialSize,

		[System.UInt32]
		$MaximumSize,

		[System.String[]]
		$DriveLetter
	)

    Switch($ConfigureOption)
    {
        'AutoManagePagingFile'
        {
            If($PSCmdlet.ShouldProcess("All drives","Set automatically manage paging file size"))
            {
		        $SystemInfo=Get-WmiObject -Class Win32_ComputerSystem -EnableAllPrivileges

                If($SystemInfo.AutomaticManagedPagefile -eq $true)
                {
                    Write-Verbose "The currently virtual memory has been set as Automatically manage paging file size for all drives."
                }
                Else
                {
                    Write-Verbose "Set the virtual memory as automatically manage paging file size"
		            $SystemInfo.AutomaticManagedPageFile = $true
		            [Void]$SystemInfo.Put()
                }
            }
        }
        'CustomSize'
        {
            If($DriveLetter)
            {
                Foreach($Drive in $DriveLetter)
                {
                    If($PSCmdlet.ShouldProcess("$Drive","Set the custom size"))
                    {
                        Write-Verbose "Set the custom size of '$Drive'"
                        SetPageFileSize -DL $Drive -InitialSize $InitialSize -MaximumSize $MaximumSize
                    }
                }
            }
        }
        'SystemManagedSize'
        {
            If($DriveLetter)
            {
                Foreach($Drive in $DriveLetter)
                {
                    If($PSCmdlet.ShouldProcess("$Drive","Set the system managed size"))
                    {
                        Write-Verbose "Set the system managed size on '$Drive'"

        	            $InitialSize = 0
			            $MaximumSize = 0
				
			            SetPageFileSize -DL $Drive -InitialSize $InitialSize -MaximumSize $MaximumSize
                    }
                }
            }
        }
        'NoPagingFile'
        {
            If($DriveLetter)
            {
                Foreach($Drive in $DriveLetter)
                {
                    If($PSCmdlet.ShouldProcess("$Drive","Set no paging file"))
                    {
                        Write-Verbose "Set no paging file on '$Drive'"
                        $PageFile = Get-WmiObject -Query "Select * From Win32_PageFileSetting Where Name='$Drive\\pagefile.sys'" -EnableAllPrivileges
                        
                        If($PageFile -ne $null)
				        {
					        $PageFile.Delete()
				        }
				        Else
				        {
					        Write-Warning """$Drive"" is already set No paging file!"
				        }
                    }
                }
            }
        }
    }

	#Include this line if the resource requires a system reboot.
	$global:DSCMachineStatus = 1
}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[ValidateSet("AutoManagePagingFile","CustomSize","SystemManagedSize","NoPagingFile")]
		[System.String]
		$ConfigureOption,

		[System.UInt32]
		$InitialSize,

		[System.UInt32]
		$MaximumSize,

		[System.String[]]
		$DriveLetter
	)

    $Get = Get-TargetResource -ConfigureOption $ConfigureOption

    Switch($ConfigureOption)
    {
        'AutoManagePagingFile'
        {
            If($Get.ConfigureOption -eq "AutoManagePagingFile")
            {
                return $true
            }
            Else
            {
                return $false
            }
        }
        'CustomSize'
        {
            If($Get.ConfigureOption -eq "CustomSize")
            {
                return $true
            }
            Else
            {
                return $false
            }       
        }
        'SystemManagedSize'
        {
            If($Get.ConfigureOption -eq "SystemManagedSize")
            {
                return $true
            }
            Else
            {
                return $false
            }        
        }
        'NoPagingFile'
        {
             If($Get.ConfigureOption -eq "NoPagingFile")
            {
                return $true
            }
            Else
            {
                return $false
            }       
        }
    }
}


Export-ModuleMember -Function *-TargetResource

