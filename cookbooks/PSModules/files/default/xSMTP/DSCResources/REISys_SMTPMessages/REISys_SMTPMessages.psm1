function Get-TargetResource
{
    [CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param(
		[parameter(Mandatory = $true)]
		[System.String]
		$SmtpSvc
    )
    
    Write-Verbose -Message "Getting IISv2 Settings"

    $IISv2Root = Get-WmiObject -Namespace "ROOT\MicrosoftIISv2" -Class  IISSmtpServerSetting

    $returnValue = @{
		MessageSizeLimit = ($IISv2Root.MaxMessageSize / 1024)
        SessionSizeLimit = ($IISv2Root.MaxSessionSize / 1024)
        ConnectionLimit = $IISv2Root.MaxConnections
        RecipientLimit = $IISv2Root.MaxRecipients
        NonDeliveryReport = $IISv2Root.SendNdrTo
        BadMailDirectory = $IISv2Root.SendBadTo
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

        [System.Int32]
        $MessageSizeLimit,

        [System.Int32]
        $SessionSizeLimit,

        [System.Int32]
        $ConnectionLimit,

        [System.Int32]
        $RecipientLimit,

        [System.String]
        $NonDeliveryReport,

        [System.String]
        $BadMailDirectory,

        [parameter(Mandatory = $true)]
		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
    )

    Write-Verbose -Message "Getting IISv2 Settings"

    $IISv2Root = Get-WmiObject -Namespace "ROOT\MicrosoftIISv2" -Class  IISSmtpServerSetting

    if($Ensure -eq "Present")
    {
        if($MessageSizeLimit -ne $null)
        {
            $IISv2Root.MaxMessageSize = ($MessageSizeLimit * 1024)
        }
        if($SessionSizeLimit -ne $null)
        {
            $IISv2Root.MaxSessionSize = ($SessionSizeLimit * 1024)
        }
        if($ConnectionLimit -ne $null)
        {
            $IISv2Root.MaxConnections = $ConnectionLimit
        }
        if($RecipientLimit -ne $null)
        {
            $IISv2Root.MaxRecipients = $RecipientLimit
        }
        if($NonDeliveryReport -ne $null)
        {
            $IISv2Root.SendNdrTo = $NonDeliveryReport
        }
        if($BadMailDirectory -ne $null)
        {
            $IISv2Root.SendBadTo = $BadMailDirectory
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

        [System.Int32]
        $MessageSizeLimit,

        [System.Int32]
        $SessionSizeLimit,

        [System.Int32]
        $ConnectionLimit,

        [System.Int32]
        $RecipientLimit,

        [System.String]
        $NonDeliveryReport,

        [System.String]
        $BadMailDirectory,

        [parameter(Mandatory = $true)]
		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
    )

    Write-Verbose -Message "Getting IISv2 Settings"

    $IISv2Root = Get-WmiObject -Namespace "ROOT\MicrosoftIISv2" -Class  IISSmtpServerSetting

    $result = [System.Boolean]

    if($Ensure -eq "Present")
    {
        if( (($MessageSizeLimit -ne $null) -or (($MessageSizeLimit * 1024) -eq $IISv2Root.MaxMessageSize)) -and
            (($SessionSizeLimit -ne $null) -or (($SessionSizeLimit * 1024) -eq $IISv2Root.MaxSessionSize)) -and
            (($ConnectionLimit -ne $null) -or ($ConnectionLimit -eq $IISv2Root.MaxConnections)) -and
            (($RecipientLimit -ne $null) -or ($RecipientLimit -eq $IISv2Root.MaxRecipients)) -and 
            (($NonDeliveryReport -ne $null) -or ($NonDeliveryReport -eq $IISv2Root.SendNdrTo)) -and 
            (($BadMailDirectory -ne $null) -or ($BadMailDirectory -eq $IISv2Root.SendBadTo)))
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
        if( (($MessageSizeLimit -ne $null) -or (($MessageSizeLimit * 1024) -eq $IISv2Root.MaxMessageSize)) -and
            (($SessionSizeLimit -ne $null) -or (($SessionSizeLimit * 1024) -eq $IISv2Root.MaxSessionSize)) -and
            (($ConnectionLimit -ne $null) -or ($ConnectionLimit -eq $IISv2Root.MaxConnections)) -and
            (($RecipientLimit -ne $null) -or ($RecipientLimit -eq $IISv2Root.MaxRecipients)) -and 
            (($NonDeliveryReport -ne $null) -or ($NonDeliveryReport -eq $IISv2Root.SendNdrTo)) -and 
            (($BadMailDirectory -ne $null) -or ($BadMailDirectory -eq $IISv2Root.SendBadTo)))
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