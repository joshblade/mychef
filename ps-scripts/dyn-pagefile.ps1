#Description: In progress DSC module to setup dynamically generated pagefile
#region helper methods

function Free-Space{


        [CmdletBinding()]
                param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $PFDrive

       
    )
    
#Calculates the amount of freespace on the Primary Disk the Pagefile will be deployed on

$Disk = Get-WmiObject Win32_LogicalDisk -ComputerName localhost -Filter "DeviceID='$PFDrive'"
$DiskFreeSpace = $Disk.FreeSpace
return $DiskFreeSpace

}


####################################
function PageFile-Size
{
        [CmdletBinding()]
        param
    (

        [parameter(Mandatory = $true)]
        [System.Int32]
        $multiplier

    )
$physicalmemProps = Get-WmiObject Win32_PhysicalMemory
$physicalmem = $physicalmemProps.Capacity 
$pageFilesize = ($physicalmem * $multiplier)
return $pageFilesize
}


####################################
function Calc-Pagefile
{
        [CmdletBinding()]
        param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $PFDrive,

        [parameter(Mandatory = $true)]
        [System.Int32]
        $DiskFreeSpace,

        [parameter(Mandatory = $true)]
        [System.Int32]
        $ReserveSpace,

        [parameter(Mandatory = $true)]
        [System.Int32]
        $pageFilesize

        
                
    )
$FreeSpaceMB = ($DiskFreeSpace /1024 / 1024)
$PageFile = ($FreeSpaceMB - $ReserveSpace)
$PageFileRounded = [math]::Round($PageFile)
$remainder = $NULL
IF($PageFileRounded -ge $pageFilesize)
{
Create-PageFile -PFDrive $PFDrive -pageFilesize $pageFilesize
$remainder = $pageFilesize - $pageFilesize #yes it could be 0, but I am learning
}
ELSE
{
Create-PageFile -PFDrive $PFDrive -pageFilesize $PageFileRounded
$remainder = $pageFilesize - $PageFileRounded
}
return $remainder
}

####################################
function Create-PageFile
{
        [CmdletBinding()]
        [OutputType([System.Collections.Hashtable])]
        param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $PFDrive,

        [parameter(Mandatory = $true)]
        [System.String]
        $pageFilesize

    )
Set-WMIInstance -class Win32_PageFileSetting -Arguments @{name="$PFDrive :\\pagefile.sys";InitialSize =($pageFilesize);MaximumSize = ($pageFilesize)} 
}


####################################
function Delete-PageFile
{
        [CmdletBinding()]
        [OutputType([System.Collections.Hashtable])]
        param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $PFDrive

        
    )
$DELpagefile = Get-WmiObject -Query "Select * From Win32_PageFileSetting Where Name='$PFDrive\\pagefile.sys'"
$DELpagefile.Delete()
} 

#endregion
####################################
function Get-TargetResource
{
        [CmdletBinding()]
        [OutputType([System.Collections.Hashtable])]
        param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $PrimaryPFDrive,

        [parameter(Mandatory = $true)]
        [System.String]
        $SecondaryPFDrive,

        [parameter(Mandatory = $false)]
        [System.Int32]
        $multiplier,

        [parameter(Mandatory = $false)]
        [System.String]
        $AutomaticManagedPFExists
    )
    $Primaryfreespace = freeSpace $PrimaryPFDrive
    $Secondaryfreespace = freespace $SecondaryPFDrive
}
####################################
function Set-TargetResource
{

        [CmdletBinding()]
        param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Enabled,
        
        [parameter(Mandatory = $true)]
        [System.String]
        $PrimaryPFDrive,

        [parameter(Mandatory = $true)]
        [System.String]
        $SecondaryPFDrive,

        [parameter(Mandatory = $false)]
        [System.Int32]
        $multiplier,

        [parameter(Mandatory = $false)]
        [System.String]
        $AutomaticManagedPFExists,

        [parameter(Mandatory = $false)]
        [System.String]
        $reserveSpace

        
    )
    IF($enabled -eq 'Present')
    {
    $primaryFreeSpace = Free-Space -PFDrive $PrimaryPFDrive
    $SecondaryFreeSpace = Free-Space -PFDrive $SecondaryPFDrive
    $pagefileSize = PageFile-Size -multiplier $multiplier
    $PageFileSizeRemainder = Calc-Pagefile -PFDrive $PrimaryPFDrive -DiskFreeSpace $primaryFreeSpace -ReserveSpace $reserveSpace -pageFilesize $pagefileSize
    $PageFileSizeRemainder = Calc-Pagefile -PFDrive $SecondaryPFDrive -DiskFreeSpace $SecondaryFreeSpace -ReserveSpace $reserveSpace -pageFilesize $PageFileSizeRemainder
    }
ELSEIF($enabled -eq 'Absent')
{
Delete-PageFile -PFDrive $PrimaryPFDrive
Delete-PageFile -PFDrive $SecondaryPFDrive
}
}
####################################
function Test-TargetResource
{
        [CmdletBinding()]
        [OutputType([bool])]
        param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $PrimaryPFDrive,

        [parameter(Mandatory = $true)]
        [System.String]
        $SecondaryPFDrive,

        [parameter(Mandatory = $false)]
        [System.Int32]
        $multiplier,

        [parameter(Mandatory = $false)]
        [System.String]
        $AutomaticManagedPFExists

    )


}
