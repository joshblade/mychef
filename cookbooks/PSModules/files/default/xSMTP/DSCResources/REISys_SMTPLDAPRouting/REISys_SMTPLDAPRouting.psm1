function Get-TargetResource
{
    [CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param(
		[parameter(Mandatory = $true)]
		[System.String]
		$SmtpSvc
    )
    
    Write-Verbose -Message "Getting LDAP Settings"

    $LDAPRouting = Get-WmiObject -Namespace "ROOT\MicrosoftIISv2" -Class "IIsSmtpRoutingSourceSetting"

    $returnValue = @{
		Server = $LDAPRouting.SmtpDSHost
        Schema = $LDAPRouting.SmtpDsSchemaType
        Binding = $LDAPRouting.SmtpDsBindType
        Domain = $LDAPRouting.SmtpDsDomain
        UserName = $LDAPRouting.SmtpDsAccount
        Password = $LDAPRouting.SmtpDsPassword 
        Base = $LDAPRouting.SmtpDsNamingContext
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

        [System.String]
        $Server,

        [System.String]
        $Schema,

        [System.String]
        $Binding,
        
        [System.String]
        $Base,

        [System.String]
        $Domain,

        [System.String]
        $UserName,

        [System.String]
        $Password,

        [parameter(Mandatory = $true)]
		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
    )

    Write-Verbose -Message "Getting LDAP Settings"

    $LDAPRouting = Get-WmiObject -Namespace "ROOT\MicrosoftIISv2" -Class "IIsSmtpRoutingSourceSetting"

    if($Ensure -eq "Present")
    {
        if($Server -ne $null)
        {
            $LDAPRouting.SmtpDSHost = $Server
        }
        if($Schema -ne $null)
        {
           $LDAPRouting.SmtpDsSchemaType = ConvertTo-Schema -Value $Schema
        }
        if($Binding -ne $null)
        {
            $LDAPRouting.SmtpDsBindType = ConvertTo-Binding -Value $Binding
        }
        if($Domain -ne $null)
        {
            $LDAPRouting.SmtpDsDomain = $Domain
        }
        if($UserName -ne $null)
        {
            $LDAPRouting.SmtpDsAccount = $UserName
        }
        if($Password -ne $null)
        {
            $LDAPRouting.SmtpDsPassword = $Password
        }
        if($Base -ne $null)
        {
            $LDAPRouting.SmtpDsNamingContext = $Base
        }
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
	param(
		[parameter(Mandatory = $true)]
		[System.String]
		$SmtpSvc,

        [System.String]
        $Server,

        [System.String]
        $Schema,

        [System.String]
        $Binding,

        [System.String]
        $Domain,

        [System.String]
        $UserName,

        [System.String]
        $Password,

        [System.String]
        $Base,

        [parameter(Mandatory = $true)]
		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
    )

    Write-Verbose -Message "Getting LDAP Settings"

    $LDAPRouting = Get-WmiObject -Namespace "ROOT\MicrosoftIISv2" -Class "IIsSmtpRoutingSourceSetting"

    $result = [System.Boolean]

    if($Ensure -eq "Present")
    {
        if( (($Server -ne $null) -or ($Server -eq $LDAPRouting.SmtpDSHost)) -and
            (($Schema -ne $null) -or ($Schema -eq (ConvertFrom-Schema -Value $LDAPRouting.SmtpDsSchemaType))) -and 
            (($Binding -ne $null) -or ($Binding -eq (ConvertFrom-Binding -Value $LDAPRouting.SmtpDsBindType))) -and
            (($Domain -ne $null) -or ($Domain -eq $LDAPRouting.SmtpDSDomain)) -and 
            (($UserName -ne $null) -or ($UserName -eq $LDAPRouting.UserName)) -and
            (($Password -ne $null) -or ($Password -eq $LDAPRouting.SmtpDsPassword)) -and
            (($Base -ne $null) -or ($Base -eq $LDAPRouting.SmtpDsNamingContext))) 
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
        if( (($Server -ne $null) -or ($Server -eq $LDAPRouting.SmtpDSHost)) -and
            (($Schema -ne $null) -or ($Schema -eq (ConvertFrom-Schema -Value $LDAPRouting.SmtpDsSchemaType))) -and 
            (($Binding -ne $null) -or ($Binding -eq (ConvertFrom-Binding -Value $LDAPRouting.SmtpDsBindType))) -and
            (($Domain -ne $null) -or ($Domain -eq $LDAPRouting.SmtpDSDomain)) -and 
            (($UserName -ne $null) -or ($UserName -eq $LDAPRouting.UserName)) -and
            (($Password -ne $null) -or ($Password -eq $LDAPRouting.SmtpDsPassword)) -and
            (($Base -ne $null) -or ($Base -eq $LDAPRouting.SmtpDsNamingContext))) 
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

function ConvertTo-Schema
{
    [CmdletBinding()]
	[OutputType([System.String])]
    param(
        [parameter(Mandatory = $true)]
		[System.String]
		$Value
    )

    $Schema = [System.String]

    if($Value -eq "ActiveDirectory")
    {
        $Schema = "NT5"
    }
    if($Value -eq "SiteServerMembershipDirectory")
    {
        $Schema = "MCIS3"
    }
    if($Value -eq "ExchangeLDAPService")
    {
        $Schema = "Exchange5"
    }

    $Schema
}

function ConvertFrom-Schema
{
    [CmdletBinding()]
	[OutputType([System.String])]
    param(
        [parameter(Mandatory = $true)]
		[System.String]
		$Value
    )

    $Schema = [System.String]

    if($Value -eq "NT5")
    {
        $Schema = "ActiveDirectory"
    }
    if($Value -eq "MCIS3")
    {
        $Schema = "SiteServerMembershipDirectory"
    }
    if($Value -eq "Exchange5")
    {
        $Schema = "ExchangeLDAPService"
    }

    $Schema
}

function ConvertTo-Binding
{
    [CmdletBinding()]
	[OutputType([System.String])]
    param(
        [parameter(Mandatory = $true)]
		[System.String]
		$Value
    )

    $Binding = [System.String]

    if($Value -eq "PlainText")
    {
        $Binding = "Simple"
    }
    if($Value -eq "Anonymous")
    {
        $Binding = "None"
    }
    if($Value -eq "WindowsSSPI")
    {
        $Binding = "Generic"
    }
    if($Value -eq "ServiceAccount")
    {
        $Binding = "CurrentUser"
    }

    $Binding
}

function ConvertFrom-Binding
{
     [CmdletBinding()]
	[OutputType([System.String])]
    param(
        [parameter(Mandatory = $true)]
		[System.String]
		$Value
    )

    $Binding = [System.String]

    if($Value -eq "Simple")
    {
        $Binding = "PlainText"
    }
    if($Value -eq "None")
    {
        $Binding = "Anonymous"
    }
    if($Value -eq "Generic")
    {
        $Binding = "WindowsSSPI"
    }
    if($Value -eq "CurrentUser")
    {
        $Binding = "ServiceAccount"
    }

    $Binding
}
