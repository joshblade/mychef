
function Check-ProgressRetry
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [System.String]
        $OutBoundRetries
    )
    
    $result = $false

    $OutBoundRetriesArray = $OutBoundRetries.Split(',')

    foreach($OutBoundRetry in $OutBoundRetriesArray)
    {
        if($OutBoundRetries -ne 0)
        {
            $result = $true
        }
    }

    $result
}

function ConvertTo-ProgressRetry
{
    [CmdletBinding()]
	[OutputType([System.String])]
	param(
        [parameter(Mandatory = $true)]
        [AllowEmptyString()]
		[System.String]
        $FirstRetry,

        [parameter(Mandatory = $true)]
        [AllowEmptyString()]
		[System.String]
        $SecondRetry,

        [parameter(Mandatory = $true)]
        [AllowEmptyString()]
		[System.String]
        $ThirdRetry,

        [parameter(Mandatory = $true)]
        [AllowEmptyString()]
		[System.String]
        $SubSequentRetry
    )

    $ProgressRetry = "$FirstRetry,$SecondRetry,$ThirdRetry,$SubSequentRetry" 

    $ProgressRetry
}


function ConvertFrom-ProgressRetry
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [System.String]
        $ProgressRetry
    )

    $SplitProgressRetry = $ProgressRetry.Split(',')

    $returnValue = @{
		OutboundFirstRetry = $SplitProgressRetry[0]
        OutboundSecondRetry = $SplitProgressRetry[1]
        OutboundThirdRetry = $SplitProgressRetry[2]
        OutboundSubsequentRetry = $SplitProgressRetry[3]
	}

	$returnValue
}

function ConvertTo-UserTime
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [System.String]
        $TimeInMinutes
    )

    $Time = $null
    $TimeValue = $null

    if(($TimeInMinutes % 1440) -eq 0)
    {
        $Time = $TimeInMinutes / 1440
        $TimeValue = Days
    }
    else
    {
        if(($TimeInMinutes % 60) -eq 0)
        {
            $Time = $TimeInMinutes / 60
            $TimeValue = Hours
        }
        else
        {
            $Time = $TimeInMinutes
            $TimeValue = Minutes
        }
    }


    $returnValue = @{
		Time = $Time
        TimeValue = $TimeValue
	}

	$returnValue
}

function ConvertFrom-UserTime
{
    [CmdletBinding()]
    [OutputType([System.Int32])]
    param(
        [parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [System.Int32]
        $Time,

        [parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [System.String]
        $TimeValue
    )

    $TimeInMinutes = $null

    if($TimeValue -eq "Days")
    {
        $TimeInMinutes = $Time * 1440
    }
    elseif ($TimeValue -eq "Minutes")
    {
        $TimeInMinutes = $Time * 60
    }
    else
    {
        $TimeInMinutes = $Time
    }
    

    $TimeInMinutes
}

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

    $IISv2Root = Get-WmiObject -Namespace "ROOT\MicrosoftIISv2" -Class  IISSmtpServerSetting

    $OutBoundRetries = ConvertFrom-ProgressRetry -ProgressRetry $IISv2Root.SmtpRemoteProgressiveRetry

    $LocalDelayNotification = ConvertTo-UserTime -TimeInMinutes $IISv2Root.SmtpLocalDelayExpireMinutes

    $LocalExpiration = ConvertTo-UserTime -TimeInMinutes $IISv2Root.SmtpLocalNDRExpireMinutes

    $DelayNotification = ConvertTo-UserTime -TimeInMinutes $IISv2Root.SmtpRemoteDelayExpireMinutes

    $Expiration = ConvertTo-UserTime -TimeInMinutes $IISv2Root.SmtpRemoteNDRExpireMinutes

    $returnValue = @{
		OutboundFirstRetry = $OutBoundRetries.OutboundFirstRetry
        OutboundSecondRetry = $OutBoundRetries.OutboundSecondRetry
        OutboundThirdRetry = $OutBoundRetries.OutboundThirdRetry
        OutboundSubsequentRetry = $OutBoundRetries.OutboundSubsequentRetry
        DelayNotificationValue = $DelayNotification.TimeValue
        DelayNotificationTime = $DelayNotification.Time
        ExpirationTimeoutValue = $Expiration.TimeValue
        ExpirationTimeout = $Expiration.Time
        LocalDelayNotificationValue = $LocalDelayNotification.TimeValue
        LocalDelayNotificationTime = $LocalDelayNotification.Time
        LocalExpirationTimeoutValue = $LocalExpiration.TimeValue
        LocalExpirationTimeout = $LocalDelayNotification.Time
        OutboundConnectionLimit = $IISv2Root.MaxOutConnections 
        TimeOut = $IISv2Root.RemoteTimeout 
        OutboundConnectionPerDomainLimit = $IISv2Root.MaxOutConnectionsPerDomain 
        TCPPort = $IISv2Root.RemoteSmtpPort 
        MaxHopCount = $IISv2Root.HopCount 
        MasqueradeDomain = $IISv2Root.MasqueradeDomain 
        FullyQualifiedDomainName = $IISv2Root.FullyQualifiedDomainName
        SmartHost = $IISv2Root.SmartHost 
        PerformReverseDNSLookup = $IISv2Root.EnableReverseDnsLookup 
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
        $OutboundFirstRetry = 0,

        [System.Int32]
        $OutboundSecondRetry = 0,

        [System.Int32]
        $OutboundThirdRetry = 0,

        [System.Int32]
        $OutboundSubsequentRetry = 0,

        [System.String]
        $DelayNotificationValue,

        [System.Int32]
        $DelayNotificationTime,

        [System.String]
        $ExpirationTimeoutValue,

        [System.Int32]
        $ExpirationTimeout,

        [System.String]
        $LocalDelayNotificationValue,

        [System.Int32]
        $LocalDelayNotificationTime,

        [System.String]
        $LocalExpirationTimeoutValue,

        [System.Int32]
        $LocalExpirationTimeout,

        [System.Int32]
        $OutboundConnectionLimit,

        [System.Int32]
        $TimeOut,
        
        [System.Int32]
        $OutboundConnectionPerDomainLimit,

        [System.Int32]
        $TCPPort,

        [System.Int32]
        $MaxHopCount,

        [System.String]
        $MasqueradeDomain,

        [System.String]
        $FullyQualifiedDomainName,

        [System.String]
        $SmartHost,

        [System.Boolean]
        $PerformReverseDNSLookup,

        [parameter(Mandatory = $true)]
		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
    )

    Write-Verbose -Message "Getting IISv2 Settings"

    $IISv2Root = Get-WmiObject -Namespace "ROOT\MicrosoftIISv2" -Class  IISSmtpServerSetting

    $OutBoundRetries = ConvertTo-ProgressRetry -FirstRetry $OutboundFirstRetry -SecondRetry $OutboundSecondRetry -ThirdRetry $OutboundThirdRetry -SubSequentRetry $OutboundSubsequentRetry

    $LocalDelayNotification = ConvertFrom-UserTime -Time $LocalDelayNotificationTime -TimeValue $LocalDelayNotificationValue

    $LocalExpiration = ConvertFrom-UserTime -Time $LocalExpirationTimeout -TimeValue $LocalExpirationTimeoutValue

    $DelayNotification = ConvertFrom-UserTime -Time $DelayNotificationTime -TimeValue $DelayNotificationValue

    $Expiration = ConvertFrom-UserTime -Time $ExpirationTimeout -TimeValue $ExpirationTimeoutValue

    if($Ensure -eq "Present")
    {
        if(Check-ProgressRetry -OutBoundRetries $OutBoundRetries)
        {
            $IISv2Root.SmtpRemoteProgressiveRetry = $OutBoundRetries
        }
        if(($LocalDelayNotificationValue -ne $null) -and ($LocalDelayNotificationTime -ne $null))
        {
            $IISv2Root.SmtpLocalDelayExpireMinutes = $LocalDelayNotification
        }
        if(($LocalExpirationTimeoutValue -ne $null) -and ($LocalExpirationTimeout -ne $null))
        {
            $IISv2Root.SmtpLocalNDRExpireMinutes = $LocalExpiration
        }
        if(($DelayNotificationValue -ne $null) -and ($DelayNotificationTime -ne $null))
        {
            $IISv2Root.SmtpRemoteDelayExpireMinutes = $DelayNotification
        }
        if(($ExpirationTimeoutValue -ne $null) -and ($ExpirationTimeout -ne $null))
        {
            $IISv2Root.SmtpRemoteNDRExpireMinutes = $Expiration
        }
        if($OutboundConnectionLimit -ne $null)
        {
            $IISv2Root.MaxOutConnections = $OutboundConnectionLimit
        }
        if($TimeOut -ne $null)
        {
            $IISv2Root.RemoteTimeout
        }
        if($OutboundConnectionPerDomainLimit -ne $null)
        {
            $IISv2Root.MaxOutConnectionsPerDomain = $OutboundConnectionPerDomainLimit
        }
        if($TCPPort -ne $null)
        {
            $IISv2Root.RemoteSmtpPort = $TCPPort
        }
        if($MaxHopCount -ne $null)
        {
            $IISv2Root.HopCount = $MaxHopCount
        }
        if($MasqueradeDomain -ne $null)
        {
            $IISv2Root.MasqueradeDomain = $MasqueradeDomain
        }
        if($FullyQualifiedDomainName -ne $null)
        {
            $IISv2Root.FullyQualifiedDomainName = $FullyQualifiedDomainName
        }
        if($SmartHost -ne $null)
        {
            $IISv2Root.SmartHost = $SmartHost
        }
        if($PerformReverseDNSLookup -ne $null)
        {
            $IISv2Root.EnableReverseDnsLookup = $PerformReverseDNSLookup
        }
    }

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

        [System.Int32]
        $OutboundFirstRetry = 0,

        [System.Int32]
        $OutboundSecondRetry = 0,

        [System.Int32]
        $OutboundThirdRetry = 0,

        [System.Int32]
        $OutboundSubsequentRetry = 0,

        [System.String]
        $DelayNotificationValue,

        [System.Int32]
        $DelayNotificationTime,

        [System.String]
        $ExpirationTimeoutValue,

        [System.Int32]
        $ExpirationTimeout,

        [System.String]
        $LocalDelayNotificationValue,

        [System.Int32]
        $LocalDelayNotificationTime,

        [System.String]
        $LocalExpirationTimeoutValue,

        [System.Int32]
        $LocalExpirationTimeout,

        [System.Int32]
        $OutboundConnectionLimit,

        [System.Int32]
        $TimeOut,
        
        [System.Int32]
        $OutboundConnectionPerDomainLimit,

        [System.Int32]
        $TCPPort,

        [System.Int32]
        $MaxHopCount,

        [System.String]
        $MasqueradeDomain,

        [System.String]
        $FullyQualifiedDomainName,

        [System.String]
        $SmartHost,

        [System.Boolean]
        $PerformReverseDNSLookup,

        [parameter(Mandatory = $true)]
		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
    )

    Write-Verbose -Message "Getting IISv2 Settings"

    $IISv2Root = Get-WmiObject -Namespace "ROOT\MicrosoftIISv2" -Class  IISSmtpServerSetting

    $OutBoundRetries = ConvertTo-ProgressRetry -FirstRetry $OutboundFirstRetry -SecondRetry $OutboundSecondRetry -ThirdRetry $OutboundThirdRetry -SubSequentRetry $OutboundSubsequentRetry

    $LocalDelayNotification = ConvertFrom-UserTime -Time $LocalDelayNotificationTime -TimeValue $LocalDelayNotificationValue

    $LocalExpiration = ConvertFrom-UserTime -Time $LocalExpirationTimeout -TimeValue $LocalExpirationTimeoutValue

    $DelayNotification = ConvertFrom-UserTime -Time $DelayNotificationTime -TimeValue $DelayNotificationValue

    $Expiration = ConvertFrom-UserTime -Time $ExpirationTimeout -TimeValue $ExpirationTimeoutValue

    $result = [System.Boolean]

    if($Ensure -eq "Present")
    {
        if( ((($OutboundFirstRetry -ne 0) -or ($OutboundSecondRetry -ne 0) -or ($OutboundThirdRetry -ne 0) -or ($OutboundSubsequentRetry -ne 0)) -or ($OutBoundRetries -eq $IISv2Root.SmtpRemoteProgressiveRetry)) -and
            ((($LocalDelayNotificationValue -ne $null) -or ($LocalDelayNotificationTime -ne $null)) -or ($LocalDelayNotification -eq $IISv2Root.SmtpLocalDelayExpireMinutes)) -and
            ((($LocalExpirationTimeoutValue -ne $null) -or ($LocalExpirationTimeout -ne $null)) -or ($LocalExpiration -eq $IISv2Root.SmtpLocalNDRExpireMinutes)) -and 
            ((($DelayNotificationValue -ne $null) -or ($DelayNotificationTime -ne $null)) -or ($DelayNotification -eq $IISv2Root.SmtpRemoteDelayExpireMinutes)) -and 
            ((($ExpirationTimeoutValue -ne $null) -or ($ExpirationTimeout -ne $null)) -or ($Expiration -eq $IISv2Root.SmtpRemoteNDRExpireMinutes)) -and
            (($OutboundConnectionLimit -ne $null) -or ($OutboundConnectionLimit -eq $IISv2Root.MaxOutConnections)) -and 
            (($TimeOut -ne $null) -or ($TimeOut -eq $IISv2Root.RemoteTimeOut)) -and 
            (($OutboundConnectionPerDomainLimit -ne $null) -or ($OutboundConnectionPerDomainLimit -eq $IISv2Root.MaxOutConnectionsPerDomain)) -and
            (($TCPPort -ne $null) -or ($TCPPort -eq $IISv2Root.RemoteSmtpPort)) -and 
            (($MaxHopCount -ne $null) -or ($MaxHopCount -eq $IISv2Root.HopCount)) -and 
            (($MasqueradeDomain -ne $null) -or ($MasqueradeDomain -eq $IISv2Root.MasqueradeDomain)) -and
            (($FullyQualifiedDomainName -ne $null) -or ($FullyQualifiedDomainName -eq $IISv2Root.FullyQualifiedDomainName)) -and 
            (($SmartHost -ne $null) -or ($SmartHost -eq $IISv2Root.SmartHost)) -and 
            (($PerformReverseDNSLookup -ne $null) -or ($PerformReverseDNSLookup -eq $IISv2Root.EnableReverseDnsLookup)))
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
        if( ((($OutboundFirstRetry -ne 0) -or ($OutboundSecondRetry -ne 0) -or ($OutboundThirdRetry -ne 0) -or ($OutboundSubsequentRetry -ne 0)) -or ($OutBoundRetries -eq $IISv2Root.SmtpRemoteProgressiveRetry)) -and
            ((($LocalDelayNotificationValue -ne $null) -or ($LocalDelayNotificationTime -ne $null)) -or ($LocalDelayNotification -eq $IISv2Root.SmtpLocalDelayExpireMinutes)) -and
            ((($LocalExpirationTimeoutValue -ne $null) -or ($LocalExpirationTimeout -ne $null)) -or ($LocalExpiration -eq $IISv2Root.SmtpLocalNDRExpireMinutes)) -and 
            ((($DelayNotificationValue -ne $null) -or ($DelayNotificationTime -ne $null)) -or ($DelayNotification -eq $IISv2Root.SmtpRemoteDelayExpireMinutes)) -and 
            ((($ExpirationTimeoutValue -ne $null) -or ($ExpirationTimeout -ne $null)) -or ($Expiration -eq $IISv2Root.SmtpRemoteNDRExpireMinutes)) -and
            (($OutboundConnectionLimit -ne $null) -or ($OutboundConnectionLimit -eq $IISv2Root.MaxOutConnections)) -and 
            (($TimeOut -ne $null) -or ($TimeOut -eq $IISv2Root.RemoteTimeOut)) -and 
            (($OutboundConnectionPerDomainLimit -ne $null) -or ($OutboundConnectionPerDomainLimit -eq $IISv2Root.MaxOutConnectionsPerDomain)) -and
            (($TCPPort -ne $null) -or ($TCPPort -eq $IISv2Root.RemoteSmtpPort)) -and 
            (($MaxHopCount -ne $null) -or ($MaxHopCount -eq $IISv2Root.HopCount)) -and 
            (($MasqueradeDomain -ne $null) -or ($MasqueradeDomain -eq $IISv2Root.MasqueradeDomain)) -and
            (($FullyQualifiedDomainName -ne $null) -or ($FullyQualifiedDomainName -eq $IISv2Root.FullyQualifiedDomainName)) -and 
            (($SmartHost -ne $null) -or ($SmartHost -eq $IISv2Root.SmartHost)) -and 
            (($PerformReverseDNSLookup -ne $null) -or ($PerformReverseDNSLookup -eq $IISv2Root.EnableReverseDnsLookup)))
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
