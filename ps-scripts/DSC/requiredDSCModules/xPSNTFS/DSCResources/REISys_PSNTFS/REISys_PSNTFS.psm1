function Get-TargetResource
{
	   [OutputType([System.Collections.Hashtable])]
    Param(
       [Parameter(Mandatory = $true)]
        [string]
        $Path,

        [Parameter(Mandatory = $true)]
        [Alias("Group","UserName")]
        [string]
        $Account,

        [Parameter(Mandatory = $true)]
        #List is expandable including only basic options
        [ValidateSet("FullControl", "Modify", "ReadAndExecute", "ListDirectory", "Read", "Write")]
        [Alias("Rule")]
        [string]
        $Permission,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Allow", "Deny")]
        [string]
        $Access,

        [Parameter(Mandatory = $false)]
        #Both parameter could be renamed to ContainerInheritAndOnjectInherit
        [ValidateSet("None","ContainerInherit", "ObjectInherit", "Both")]
        [string]
        $Inheritance = "Both",

        [Parameter(Mandatory = $false)]
        #Both parameter could be renamed to InheritOnlyAndNoPropagateInherit
        [ValidateSet("None","InheritOnly", "NoPropagateInherit", "Both")]
        [string]
        $Propagation = "None",

        [Parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [string]
        $Ensure
    )

    $returnValue = @{
        AccessRule = $AccessRule
        Ensure = $false
    }
    
    $UsableInheritance = $Inheritance

    if($Inheritance.Equals("Both"))
    {
        $UsableInheritance = "ContainerInherit, ObjectInherit"
    }

    $UsablePropagation = $Propagation

    if($Propagation -eq "Both")
    {
        $UsablePropagation = "InheritOnly, NoPropagateInherit"
    }

    Write-Verbose -Message "Checking $Path AccessRules for $Account"

    try
    {
        $ACLObject = Get-Acl $Path 
        $CurrentState = $ACLObject.GetAccessRules($true, $true, [System.Security.Principal.NTAccount])
        $DesiredState = New-Object System.Security.AccessControl.FileSystemAccessRule $Account,$Permission,$UsableInheritance,$UsablePropagation,$Access

        $Match = $CurrentState | ?{ ($DesiredState.IdentityReference -eq $_.IdentityReference) -and 
                                 ($DesiredState.FileSystemRights -eq $_.FileSystemRights) -and 
                                 ($DesiredState.AccessControlType -eq $_.AccessControlType) -and 
                                 ($DesiredState.InheritanceFlags -eq $_.InheritanceFlags ) -and
                                 ($DesiredState.PropagationFlags -eq $_.PropagationFlags)}
     
        $returnValue.Ensure = if($Match) {$true} else {$false}
        $returnValue.AccessRule = $Match
        
    }
    catch
    { 
        Write-Error -Message $Error[0]
        throw $_
    }

    $returnValue
}


function Set-TargetResource
{
	[CmdletBinding()]
	   Param(
        [Parameter(Mandatory = $true)]
        [string]
        $Path,

        [Parameter(Mandatory = $true)]
        [Alias("Group","UserName")]
        [string]
        $Account,

        [Parameter(Mandatory = $true)]
        #List is expandable including only basic options
        [ValidateSet("FullControl", "Modify", "ReadAndExecute", "ListDirectory", "Read", "Write")]
        [Alias("Rule")]
        [string]
        $Permission,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Allow", "Deny")]
        [string]
        $Access,

        [Parameter(Mandatory = $false)]
        #Both parameter could be renamed to ContainerInheritAndOnjectInherit
        [ValidateSet("None","ContainerInherit", "ObjectInherit", "Both")]
        [string]
        $Inheritance = "None",

        [Parameter(Mandatory = $false)]
        #Both parameter could be renamed to InheritOnlyAndNoPropagateInherit
        [ValidateSet("None","InheritOnly", "NoPropagateInherit", "Both")]
        [string]
        $Propagation = "None",

        [Parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [string]
        $Ensure
    )

    $parameters = $PSBoundParameters.Remove("Debug");
    $state = Test-TargetResource @PSBoundParameters
    if( $state -eq $true )
    {
        Write-Verbose -Message "Already at desired state. Returning."
        return
    }

    Write-Verbose -Message "Checking $Path permission status for $Account"

    try
    {
        $ACLObject = Get-Acl $Path

        $UsableInheritance = $Inheritance

        if($Inheritance.Equals("Both"))
        {
            $UsableInheritance = "ContainerInherit, ObjectInherit"
        }

        $UsablePropagation = $Propagation

        if($Propagation -eq "Both")
        {
            $UsablePropagation = "InheritOnly, NoPropagateInherit"
        }

        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $Account,$Permission,$UsableInheritance,$UsablePropagation,$Access
 
        if($Ensure -eq "Present")
        {
            Write-Verbose -Message "Setting $Account for $Path"
            $ACLObject.SetAccessRule($AccessRule)
            Set-Acl $Path $ACLObject
        }
        else
        {
            Write-Verbose -Message "Removing $Account for $Path"
            $ACLObject.RemoveAccessRule($AccessRule)
            Set-Acl $Path $ACLObject
        }
    }
    catch
    { 
        Write-Error -Message $Error[0]
        throw $_
    }

    #Get-Acl $Path | Format-List
    
    $global:DSCMachineStatus = 0 
}


function Test-TargetResource
{
    [OutputType([System.Boolean])]
     Param(
        [Parameter(Mandatory = $true)]
        [string]
        $Path,

        [Parameter(Mandatory = $true)]
        [Alias("Group","UserName")]
        [string]
        $Account,

        [Parameter(Mandatory = $true)]
        #List is expandable including only basic options
        [ValidateSet("FullControl", "Modify", "ReadAndExecute", "ListDirectory", "Read", "Write")]
        [Alias("Rule")]
        [string]
        $Permission,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Allow", "Deny")]
        [string]
        $Access,

        [Parameter(Mandatory = $false)]
        #Both parameter could be renamed to ContainerInheritAndOnjectInherit
        [ValidateSet("None","ContainerInherit", "ObjectInherit", "Both")]
        [string]
        $Inheritance = "None",

        [Parameter(Mandatory = $false)]
        #Both parameter could be renamed to InheritOnlyAndNoPropagateInherit
        [ValidateSet("None","InheritOnly", "NoPropagateInherit", "Both")]
        [string]
        $Propagation = "None",

        [Parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [string]
        $Ensure
    )

    $TestResults = [System.Boolean]

    try
    {
        $parameters = $PSBoundParameters.Remove("Debug");
        $existingResource = Get-TargetResource @PSBoundParameters
        $TestResults = $existingResource.Ensure
    }
    catch
    {
        Write-Error $Error[0]
        throw $_
    } 

    $TestResults
}


Export-ModuleMember -Function *-TargetResource