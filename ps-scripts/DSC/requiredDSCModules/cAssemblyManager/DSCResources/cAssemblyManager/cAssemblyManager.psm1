function Get-TargetResource
{
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $AssemblyName,

        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [string]
        $GACInstallPath,

        [Parameter(Mandatory = $true)]
        [string]
        $AssemblyLocationPath,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [string]
        $Ensure
    )

    $returnValue = @{
        Assembly = $Assembly
        Ensure = $false
    }

    $AssemblyFullName = $AssemblyName.Replace(".dll", "")

    $GACInstallPath = Join-Path $GACInstallPath (Join-Path $AssemblyFullName "\*\")

    Write-Verbose "GAC Install Path = $GACInstallPath"

    try
    {
        $fullAssemblyPath = Join-Path $GACInstallPath $AssemblyName 

        Write-Verbose "FullAssemblyPath = $fullAssemblyPath"

        if(Test-Path $fullAssemblyPath)
        {
            Write-Verbose "TestPath: $fullAssemblyPath found!"

            $InstalledAssembly = Get-ChildItem -Path $fullAssemblyPath

            Write-Verbose "Installed Assembly Loadded: $InstalledAssembly"

            $ToBeInstalledAssembly = Get-ChildItem -Path (Join-Path $AssemblyLocationPath $AssemblyName)

            Write-Verbose "To be Installed Assembly Loadded: $ToBeInstalledAssembly"

            $NewVersionInfo = $ToBeInstalledAssembly.VersionInfo

            Write-Verbose "Version to be Installed: $NewVersionInfo"

            $OldVersionInfo = $InstalledAssembly.VersionInfo

            Write-Verbose "Version Installed: $OldVersionInfo"

            if($NewVersionInfo.ProductVersion -eq $OldVersionInfo.ProductVersion)
            {
                $returnValue.Assembly = $InstalledAssembly

                if($Ensure -eq "Present")
                {
                    Write-Verbose "Hello There"
                    $returnValue.Ensure = $true
                }
                else
                {
                    Write-Verbose "Hello There Other"
                    $returnValue.Ensure = $false
                }
            }
        }
        else
        {
            if($Ensure -eq "Present")
            {
                Write-Verbose "Hello Missing"
                $returnValue.Ensure = $false
            }
            else
            {
                Write-Verbose "Hellow Missing Other"
                $returnValue.Ensure = $true
            }
        }
    }
    catch
    {
        Write-Error -Message $Error[0]
        throw $_
    }

	#TODO REMOVE THIS
	$returnValue = $false
    $returnValue
}

function Set-TargetResource
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $AssemblyName,

        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [string]
        $GACInstallPath,

        [Parameter(Mandatory = $true)]
        [string]
        $AssemblyLocationPath,

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

    try
    {
        Set-Location -Path $AssemblyLocationPath

        $DLL = Join-Path $AssemblyLocationPath $AssemblyName 

        [System.Reflection.Assembly]::Load("System.EnterpriseServices, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
        $publish = New-Object System.EnterpriseServices.Internal.Publish

        if($Ensure -eq "Present")
        {
            Write-Verbose "Hello Install $publish.GacInstall($DLL)"
			$publish.GacRemove($DLL)
            $publish.GacInstall($DLL)
        }
        else
        {
            $publish.GacRemove($DLL)
        }

        Pop-Location
    }
    catch
    { 
        Write-Error -Message $Error[0]
        throw $_
    }

    $global:DSCMachineStatus = 0 
}

function Test-TargetResource
{
    [OutputType([System.Boolean])]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $AssemblyName,

        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [string]
        $GACInstallPath,

        [Parameter(Mandatory = $true)]
        [string]
        $AssemblyLocationPath,

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