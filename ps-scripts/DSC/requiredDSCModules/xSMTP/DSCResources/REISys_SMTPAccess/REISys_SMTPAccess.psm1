function Get-TargetResource
{
    [CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param(
		[parameter(Mandatory = $true)]
		[System.String]
		$SmtpSvc,
        [parameter(Mandatory = $true)]
		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Write-Verbose -Message "Getting IISv2 Settings"

    $IISv2Root = Get-WmiObject -Namespace "ROOT\MicrosoftIISv2" -Class  IISSmtpServerSetting | Where {$_.Name -eq $SmtpSvc}

    Write-Verbose -Message "Getting IIS IP Security Settings" 

    $IISIPSecurity = Get-WmiObject -Namespace "ROOT\MicrosoftIISv2" -Class IISIPSecuritySetting | Where {$_.Name -eq $SmtpSvc}

    
    $returnValue = @{
		AnonymousAuthentication = $IISv2Root.AuthAnonymous
        BasicAuthentication = $IISv2Root.AuthBasic
        WindowsAuthentication = $IISv2Root.AuthNTLM
        DefaultDomain = $IISv2Root.SaslLogonDomain

        IPDeny = $IISIPSecurity.IPDeny
        IPGrant = $IISIPSecurity.IPGrant
        DomainDeny = $IISIPSecurity.DomainDeny
        DomainGrant = $IISIPSecurity.DomainGrant
        GrantByDefault = $IISIPSecurity.GrantByDefault
	}

	$returnValue
}

function Set-TargetResource
{
    [CmdletBinding()]
	param(
		[parameter(Mandatory = $true)]
		[System.String]
		$SmtpSvc,
		
        [System.Boolean]
        $AnonymousAuthentication,

        [System.Boolean]
        $BasicAuthentication,

        [System.Boolean]
        $WindowsAuthentication,

        [System.String]
        $DefaultDomain,

        [System.String[]]
        $IPDeny,

        [System.String[]]
        $IPGrant,

        [System.String[]]
        $DomainDeny,

        [System.String[]]
        $DomainGrant,

        [System.Boolean]
        $GrantByDefault,

        [parameter(Mandatory = $true)]
		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
    )

    Write-Verbose -Message "Getting IISv2 Settings"

    $IISv2Root = Get-WmiObject -Namespace "ROOT\MicrosoftIISv2" -Class  IISSmtpServerSetting | Where {$_.Name -eq $SmtpSvc}

    Write-Verbose -Message "Getting IIS IP Security Settings" 

    $IISIPSecurity = Get-WmiObject -Namespace "ROOT\MicrosoftIISv2" -Class IISIPSecuritySetting | Where {$_.Name -eq $SmtpSvc}

    if($Ensure -eq "Present")
    {
        if($AnonymousAuthentication -ne $null)
        {
            $IISv2Root.AuthAnonymous = $AnonymousAuthentication
        }
        if($BasicAuthentication -ne $null)
        {
            $IISv2Root.AuthBasic = $BasicAuthentication
        }
        if($WindowsAuthentication -ne $null)
        {
            $IISv2Root.AuthNTLM = $WindowsAuthentication
        }
        if($DefaultDomain -ne $null)
        {
            $IISv2Root.SaslLogonDomain = $DefaultDomain
        }
        if($IPDeny -ne $null)
        {
            $IISIPSecurity.IPDeny = $IPDeny
        }
        if($IPGrant -ne $null)
        {
            $IISIPSecurity.IPGrant = $IPGrant
        }
        if($DomainDeny -ne $null)
        {
            $IISIPSecurity.DomainDeny = $DomainDeny
        }
        if($DomainGrant -ne $null)
        {
            $IISIPSecurity.DomainGrant = $DomainGrant
        }
        if($GrantByDefault -ne $null)
        {
            $IISIPSecurity.GrantByDefault = $GrantByDefault
        }
    }

    Write-Verbose -Message "Putting New IISIPSecurity Settings"
    $IISIPSecurity.Put() | Out-Null


    Write-Verbose -Message "Putting New IIS Root Settings"
    $IISv2Root.Put() | Out-Null
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
	param(
		[parameter(Mandatory = $true)]
		[System.String]
		$SmtpSvc,
		
        [System.Boolean]
        $AnonymousAuthentication,

        [System.Boolean]
        $BasicAuthentication,

        [System.Boolean]
        $WindowsAuthentication,

        [System.String]
        $DefaultDomain,

        [System.String[]]
        $IPDeny,

        [System.String[]]
        $IPGrant,

        [System.String[]]
        $DomainDeny,

        [System.String[]]
        $DomainGrant,

        [System.Boolean]
        $GrantByDefault,

        [parameter(Mandatory = $true)]
		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
    )

    Write-Verbose -Message "Getting IISv2 Settings"

    $IISv2Root = Get-WmiObject -Namespace "ROOT\MicrosoftIISv2" -Class  IISSmtpServerSetting | Where {$_.Name -eq $SmtpSvc}

    Write-Verbose -Message "Getting IIS IP Security Settings" 

    $IISIPSecurity = Get-WmiObject -Namespace "ROOT\MicrosoftIISv2" -Class IISIPSecuritySetting | Where {$_.Name -eq $SmtpSvc}

    $result = [System.Boolean]     

    if($Ensure -eq "Present")
    {
        if( (($AnonymousAuthentication -ne $null) -and ($AnonymousAuthentication -ne $IISv2Root.AuthAnonymous)) -and
            (($BasicAuthentication -ne $null) -and ($BasicAuthentication -ne $IISv2Root.AuthBasic)) -and
            (($WindowsAuthentication -ne $null) -and ($WindowsAuthentication -ne $IISv2Root.AuthNTLM)) -and
            (($DefaultDomain -ne $null) -and ($DefaultDomain -ne $IISv2Root.SaslLogonDomain)) -and 
            (($IPDeny -ne $null) -and (ArrayCompare -StringArray1 $IPDeny -StringArray2 $IISIPSecurity.IPDeny)) -and 
            (($IPGrant -ne $null) -and (ArrayCompare -StringArray1 $IPGrant -StringArray2 $IISIPSecurity.IPGrant)) -and
            (($DomainDeny -ne $null) -and (ArrayCompare -StringArray1 $DomainDeny -StringArray2 $IISIPSecurity.DomainDeny)) -and
            (($DomainGrant -ne $null) -and (ArrayCompare -StringArray1 $DomainGrant -StringArray2 $IISIPSecurity.DomainGrant)) -and
            (($GrantByDefault -ne $null) -and ($GrantByDefault -ne $IISIPSecurity.GrantByDefault))) 
        {
            $result = $true
        }
        else
        {
            $result = $false
        }
    }
    else
    {
        if( (($AnonymousAuthentication -ne $null) -and ($AnonymousAuthentication -ne $IISv2Root.AuthAnonymous)) -and
            (($BasicAuthentication -ne $null) -and ($BasicAuthentication -ne $IISv2Root.AuthBasic)) -and
            (($WindowsAuthentication -ne $null) -and ($WindowsAuthentication -ne $IISv2Root.AuthNTLM)) -and
            (($DefaultDomain -ne $null) -and ($DefaultDomain -ne $IISv2Root.SaslLogonDomain)) -and 
            (($IPDeny -ne $null) -and (ArrayCompare -StringArray1 $IPDeny -StringArray2 $IISIPSecurity.IPDeny)) -and 
            (($IPGrant -ne $null) -and (ArrayCompare -StringArray1 $IPGrant -StringArray2 $IISIPSecurity.IPGrant)) -and
            (($DomainDeny -ne $null) -and (ArrayCompare -StringArray1 $DomainDeny -StringArray2 $IISIPSecurity.DomainDeny)) -and
            (($DomainGrant -ne $null) -and (ArrayCompare -StringArray1 $DomainGrant -StringArray2 $IISIPSecurity.DomainGrant)) -and
            (($GrantByDefault -ne $null) -and ($GrantByDefault -ne $IISIPSecurity.GrantByDefault))) 
        {
            $result = $false
        }
        else
        {
            $result = $true
        }
    }

    $result
}

#region Helper Methods
function ArrayCompare
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
	param(
        [parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [string[]]
        $StringArray1,

        [parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [string[]]
        $StringArray2
    )     

    $result = $true
    if($StringArray1 -ne $null -and $StringArray1.Count -ne 0)
    {


        foreach($String1 in $StringArray1)
        {
            if($StringArray2 -ne $null -and $StringArray2.Count -ne 0)
            {
                foreach($String2 in $StringArray2)
                {
                    if($String1 -ne $String2)
                    {
                        $result = $false
                    }
                }
            }
        }
    }
    $result 
}


#endregion
