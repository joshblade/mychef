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
    
    $Smtp = Get-WmiObject IISSmtpServerSetting -Namespace "ROOT\MicrosoftIISv2"

    if($Smtp -eq $null)
    {
        Write-Error -Message "IIS Smtp Returned Null, Please Check If SMTP Server is installed properly."
    }

    $ConvertedLogFormat = Convert-ToFileFormat -LogPluginClsid $Smtp.LogPluginClsid

    $ConvertedLogFilePeriod = Convert-ToTimePeriod -TimeValue $Smtp.LogFilePeriod -FileSize $Smtp.LogFileTruncateSize

    $returnValue = @{
		EnableLogging = $Smtp.DontLog
		LogFormat = $ConvertedLogFormat
		LogFileDirectory = $Smtp.LogFileDirectory
		LogFilePeriod = $ConvertedLogFilePeriod
		LogFileSize = $Smtp.LogFileTruncateSize
		FileFlags = $Smtp.FileFlags
		LogType = $Smtp.LogType
		OBDCDataSource = $Smtp.OBDCDataSource
		OBDCTableName = $Smtp.OBDCTableName
		OBDCUserName = $Smtp.OBDCUserName
		OBDCPassword = $Smtp.Pasword
		Date = $Smtp.Date
		Time = $Smtp.Time
		ClientIP = $Smtp.ClientIP
		UserName = $Smtp.UserName
		ServiceName = $Smtp.SiteName
		ServerName = $Smtp.ComputerName
		ServerIPAdress = $Smtp.ServerIP
		ServerPort = $Smtp.ServerPort
		Method = $Smtp.Method
		URIStem = $Smtp.UriStem
		URIQuery = $Smtp.UriQuery
		ProtocolStatus = $Smtp.HttpStatus
		ProtocolSubStatus = $Smtp.HttpSubStatus
		Win32Status = $Smtp.Win32Status
		BytesSent = $Smtp.BytesSent
		BytesReceived = $Smtp.BytesRecv
		TimeTaken = $Smtp.TimeTaken
		ProtocolVersion = $Smtp.ProtocolVersion
		Host = $Smtp.Host
		UserAgent = $Smtp.UserAgent
		Cookie = $Smtp.Cookie
		Referer = $Smtp.Referer
	}

	$returnValue
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$SmtpSvc,

		[System.Boolean]
		$EnableLogging,

		[ValidateSet("MicrosoftIISLogFileFormat","NCSACommonLogFileFormat","ODBCLogging","W3CExtendedLogFileFormat")]
		[System.String]
		$LogFormat,

		[System.String]
		$LogFileDirectory,

		[ValidateSet("Hour","Daily","Weekly","Monthly","UnlimitedFileSize","MB")]
		[System.String]
		$LogFilePeriod,

		[System.Int32]
		$LogFileSize,

		[System.Int32]
		$FileFlags,

		[System.Int32]
		$LogType,

		[System.String]
		$OBDCDataSource,

		[System.String]
		$OBDCTableName,

		[System.String]
		$OBDCUserName,

		[System.String]
		$OBDCPassword,

		[System.Boolean]
		$Date,

		[System.Boolean]
		$Time,

		[System.Boolean]
		$ClientIP,

		[System.Boolean]
		$UserName,

		[System.Boolean]
		$ServiceName,

		[System.Boolean]
		$ServerName,

		[System.Boolean]
		$ServerIPAdress,

		[System.Boolean]
		$ServerPort,

		[System.Boolean]
		$Method,

		[System.Boolean]
		$URIStem,

		[System.Boolean]
		$URIQuery,

		[System.Boolean]
		$ProtocolStatus,

		[System.Boolean]
		$ProtocolSubStatus,

		[System.Boolean]
		$Win32Status,

		[System.Boolean]
		$BytesSent,

		[System.Boolean]
		$BytesReceived,

		[System.Boolean]
		$TimeTaken,

		[System.Boolean]
		$ProtocolVersion,

		[System.Boolean]
		$Host,

		[System.Boolean]
		$UserAgent,

		[System.Boolean]
		$Cookie,

		[System.Boolean]
		$Referer,

		[parameter(Mandatory = $true)]
		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

       
    Write-Verbose -Message "Getting IISv2 Settings"
    
    $Smtp = Get-WmiObject IISSmtpServerSetting -Namespace "ROOT\MicrosoftIISv2"

    if($Smtp -eq $null)
    {
        Write-Error -Message "IIS Smtp Returned Null, Please Check If SMTP Server is installed properly."
    }


    $ConvertedLogFormat = Convert-FromFileFormat -LogFormat $LogFormat

    $ConvertedLogFilePeriod = Convert-FromTimePeriod -TimePeriod $LogFilePeriod -FileSize $LogFileSize

    if($EnableLogging -ne $null)
    {
        $Smtp.DontLog = !$EnableLogging
    }
    if($LogFormat -ne $null)
    {
	    $Smtp.LogPluginClsid = $ConvertedLogFormat
    }
    if($LogFileDirectory -ne $null)
    {
	    $Smtp.LogFileDirectory = $LogFileDirectory
    }
    if($ConvertedLogFilePeriod -ne $null)
    {
	    $Smtp.LogFilePeriod = $ConvertedLogFilePeriod
    }
    if($LogFileSize -ne $null)
    {
	    $Smtp.LogFileTruncateSize = $LogFileSize
    }
    if($FileFlags -ne $null)
    {
	    $Smtp.FileFlags = $FileFlags
    }
    if($LogType -ne $null)
    {
	    $Smtp.LogType = $LogType 
    }
    if($OBDCDataSource -ne $null)
    {
	    $Smtp.OBDCDataSource = $OBDCDataSource
    }
    if($OBDCTableName -ne $null)
    {
	    $Smtp.OBDCTableName = $OBDCTableName
    }
    if($OBDCUserName -ne $null)
    {
        $Smtp.OBDCUserName = $OBDCUserName
    }
    if($OBDCPassword -ne $null)
    {
	    $Smtp.OBDCPasword = $OBDCPassword
    }
    if($Date -ne $null)	
    {
	    $Smtp.Date = $Date
    }
    if($Time -ne $null)
    {
	    $Smtp.Time = $Time
    }
    if($ClientIP -ne $null)
    {
	    $Smtp.ClientIP = $ClientIP 
    }
    if($UserName -ne $null)
    {
	    $Smtp.UserName = $UserName
    }
    if($ServiceName -ne $null)
    {
	    $Smtp.SiteName = $ServiceName
    }
    if($ServiceName -ne $null)
    {
	    $Smtp.ComputerName = $ServerName
    }
    if($ServerIPAdress -ne $null)
    {
	    $Smtp.ServerIP = $ServerIPAdress
    }
    if($ServerPort -ne $null)
    {
	    $Smtp.ServerPort = $ServerPort
    }
    if($Method -ne $null)
    {
	    $Smtp.Method = $Method
    }
    if($URIStem -ne $null)
    {
	    $Smtp.UriStem = $URIStem
	}
    if($URIQuery -ne $null)
    {
        $Smtp.UriQuery = $URIQuery
    }
    if($ProtocolStatus -ne $null)
    {	
        $Smtp.HttpStatus = $ProtocolStatus
    }
    if($ProtocolSubStatus -ne $null)
    {
	    $Smtp.HttpSubStatus = $ProtocolSubStatus
    }
    if($Win32Status -ne $null)
    {
	    $Smtp.Win32Status = $Win32Status
    }
    if($BytesSent -ne $null)
    {
	    $Smtp.BytesSent = $BytesSent
    }
    if($BytesReceived -ne $null)
    {
	    $Smtp.BytesRecv = $BytesReceived
    }
    if($TimeTaken -ne $null)
    {
	    $Smtp.TimeTaken = $TimeTaken
	}
    if($ProtocolVersion -ne $null)
    {
        $Smtp.ProtocolVersion = $ProtocolVersion
    }
    if($Host -ne $null)
    {	
        $Smtp.Host = $Host
    }
    if($UserAgent -ne $null)
    {
	    $Smtp.UserAgent = $UserAgent
    }
    if($Cookie -ne $null)
    {
	    $Smtp.Cookie = $Cookie
    }
    if($Referer -ne $null)
    {
	    $Smtp.Referer = $Referer
    }

    $Smtp.Put() | Out-Null
}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$SmtpSvc,

		[System.Boolean]
		$EnableLogging,

		[ValidateSet("MicrosoftIISLogFileFormat","NCSACommonLogFileFormat","ODBCLogging","W3CExtendedLogFileFormat")]
		[System.String]
		$LogFormat,

		[System.String]
		$LogFileDirectory,

		[ValidateSet("Hour","Daily","Weekly","Monthly","UnlimitedFileSize","MB")]
		[System.String]
		$LogFilePeriod,

		[System.Int32]
		$LogFileSize,

		[System.Int32]
		$FileFlags,

		[System.Int32]
		$LogType,

		[System.String]
		$OBDCDataSource,

		[System.String]
		$OBDCTableName,

		[System.String]
		$OBDCUserName,

		[System.String]
		$OBDCPassword,

		[System.Boolean]
		$Date,

		[System.Boolean]
		$Time,

		[System.Boolean]
		$ClientIP,

		[System.Boolean]
		$UserName,

		[System.Boolean]
		$ServiceName,

		[System.Boolean]
		$ServerName,

		[System.Boolean]
		$ServerIPAdress,

		[System.Boolean]
		$ServerPort,

		[System.Boolean]
		$Method,

		[System.Boolean]
		$URIStem,

		[System.Boolean]
		$URIQuery,

		[System.Boolean]
		$ProtocolStatus,

		[System.Boolean]
		$ProtocolSubStatus,

		[System.Boolean]
		$Win32Status,

		[System.Boolean]
		$BytesSent,

		[System.Boolean]
		$BytesReceived,

		[System.Boolean]
		$TimeTaken,

		[System.Boolean]
		$ProtocolVersion,

		[System.Boolean]
		$Host,

		[System.Boolean]
		$UserAgent,

		[System.Boolean]
		$Cookie,

		[System.Boolean]
		$Referer,

		[parameter(Mandatory = $true)]
		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)
	
	$result = [System.Boolean]

    $Smtp = Get-TargetResource

    $ConvertedLogFormat = Convert-FromFileFormat -LogFormat $LogFormat

    $ConvertedLogFilePeriod = Convert-FromTimePeriod -TimePeriod $LogFilePeriod -FileSize $LogFileSize
    
    if($Ensure -eq "Present")
    {
        if( (($EnableLogging -eq $null) -or ($EnableLogging -eq !$Smtp.DontLog)) -and
            (($LogFormat -eq $null) -or ($ConvertedLogFormat -eq $Smtp.LogPluginClsid)) -and
            (($LogFileDirectory -eq $null) -or ($LogFileDirectory -eq $Smtp.LogFileDirectory)) -and
            (($LogFilePeriod -eq $null) -or ($ConvertedLogFilePeriod -eq $Smtp.LogFilePeriod)) -and
            (($LogFileSize -eq $null) -or  ($LogFileSize -eq $Smtp.LogFileSize)) -and
            (($FileFlags -eq $null) -or ($FileFlags -eq $Smtp.FileFlags)) -and
            (($LogType -eq $null) -or ($LogType -eq $Smtp.LogType)) -and 
            (($OBDCDataSource -eq $null) -or ($OBDCDataSource -eq $Smtp.OBDCDataSource)) -and
            (($OBDCTableName -eq $null) -or ($OBDCTableName -eq $Smtp.OBDCDataSource)) -and
            (($OBDCUserName -eq $null) -or ($OBDCUserName -eq $Smtp.OBDCUserName)) -and
            (($OBDCPassword -eq $null) -or ($OBDCPassword -eq $Smtp.OBDCPassword)) -and
            (($Date -eq $null) -or ($Date -eq $Smtp.Date)) -and
            (($Time -eq $null) -or ($Time -eq $Smtp.Time)) -and
            (($ClientIP -eq $null) -or ($ClientIP -eq $Smtp.ClientIP)) -and
            (($UserName -eq $null) -or ($UserName -eq $Smtp.UserName)) -and
            (($ServiceName -eq $null) -or ($ServiceName -eq $Smtp.SiteName)) -and
            (($ServerName -eq $null) -or ($ServerName -eq $Smtp.ComputerName)) -and 
            (($ServerIPAdress -eq $null) -or ($ServerIPAdress -eq $Smtp.ServerIP)) -and
            (($ServerPort -eq $null) -or ($ServerPort -eq $Smpt.ServerPort)) -and 
            (($Method -eq $null) -or ($Method -eq $Smpt.Method)) -and
            (($URIStem -eq $null) -or ($URIStem -eq $Smpt.UriStem)) -and
            (($URIQuery -eq $null) -or ($URIQuery -eq $Smpt.UriQuery)) -and
            (($ProtocolStatus -eq $null) -or ($ProtocolStatus -eq $Smtp.HttpStatus)) -and
            (($ProtocolSubStatus -eq $null) -or ($ProtocolSubStatus -eq $Smpt.HttpSubStatus)) -and
            (($Win32Status -eq $null) -or ($Win32Status -eq $Smpt.Win32Status)) -and
            (($BytesSent -eq $null) -or ($BytesSent -eq $Smtp.BytesSent)) -and
            (($BytesReceived -eq $null) -or ($BytesReceived -eq $Smtp.BytesRecv )) -and
            (($TimeTaken -eq $null) -or ($TimeTaken -eq $Smpt.TimeTaken)) -and
            (($ProtocolVersion -eq $null) -or ($ProtocolVersion -eq $Smtp.ProtocolVersion)) -and
            (($Host -eq $null) -or ($Host -eq $Smtp.Host)) -and 
            (($UserAgent -eq $null) -or ($UserAgent -eq $Smpt.UserAgent)) -and
            (($Cookie -eq $null) -or ($Cookie -eq $Smtp.Cookie)) -and
            (($Referer -eq $null) -or ($Referer -eq $Smtp.Referer)) )
        {
            $result = $true
        }
        else
        {
            $result = $false
        }
    }
    elseif($Ensure -eq "Absent")
    {
        if( (($EnableLogging -eq $null) -or ($EnableLogging -eq !$Smtp.DontLog)) -and
            (($LogFormat -eq $null) -or ($ConvertedLogFormat -eq $Smtp.LogPluginClsid)) -and
            (($LogFileDirectory -eq $null) -or ($LogFileDirectory -eq $Smtp.LogFileDirectory)) -and
            (($LogFilePeriod -eq $null) -or ($ConvertedLogFilePeriod -eq $Smtp.LogFilePeriod)) -and
            (($LogFileSize -eq $null) -or  ($LogFileSize -eq $Smtp.LogFileSize)) -and
            (($FileFlags -eq $null) -or ($FileFlags -eq $Smtp.FileFlags)) -and
            (($LogType -eq $null) -or ($LogType -eq $Smtp.LogType)) -and 
            (($OBDCDataSource -eq $null) -or ($OBDCDataSource -eq $Smtp.OBDCDataSource)) -and
            (($OBDCTableName -eq $null) -or ($OBDCTableName -eq $Smtp.OBDCDataSource)) -and
            (($OBDCUserName -eq $null) -or ($OBDCUserName -eq $Smtp.OBDCUserName)) -and
            (($OBDCPassword -eq $null) -or ($OBDCPassword -eq $Smtp.OBDCPassword)) -and
            (($Date -eq $null) -or ($Date -eq $Smtp.Date)) -and
            (($Time -eq $null) -or ($Time -eq $Smtp.Time)) -and
            (($ClientIP -eq $null) -or ($ClientIP -eq $Smtp.ClientIP)) -and
            (($UserName -eq $null) -or ($UserName -eq $Smtp.UserName)) -and
            (($ServiceName -eq $null) -or ($ServiceName -eq $Smtp.SiteName)) -and
            (($ServerName -eq $null) -or ($ServerName -eq $Smtp.ComputerName)) -and 
            (($ServerIPAdress -eq $null) -or ($ServerIPAdress -eq $Smtp.ServerIP)) -and
            (($ServerPort -eq $null) -or ($ServerPort -eq $Smpt.ServerPort)) -and 
            (($Method -eq $null) -or ($Method -eq $Smpt.Method)) -and
            (($URIStem -eq $null) -or ($URIStem -eq $Smpt.UriStem)) -and
            (($URIQuery -eq $null) -or ($URIQuery -eq $Smpt.UriQuery)) -and
            (($ProtocolStatus -eq $null) -or ($ProtocolStatus -eq $Smtp.HttpStatus)) -and
            (($ProtocolSubStatus -eq $null) -or ($ProtocolSubStatus -eq $Smpt.HttpSubStatus)) -and
            (($Win32Status -eq $null) -or ($Win32Status -eq $Smpt.Win32Status)) -and
            (($BytesSent -eq $null) -or ($BytesSent -eq $Smtp.BytesSent)) -and
            (($BytesReceived -eq $null) -or ($BytesReceived -eq $Smtp.BytesRecv )) -and
            (($TimeTaken -eq $null) -or ($TimeTaken -eq $Smpt.TimeTaken)) -and
            (($ProtocolVersion -eq $null) -or ($ProtocolVersion -eq $Smtp.ProtocolVersion)) -and
            (($Host -eq $null) -or ($Host -eq $Smtp.Host)) -and 
            (($UserAgent -eq $null) -or ($UserAgent -eq $Smpt.UserAgent)) -and
            (($Cookie -eq $null) -or ($Cookie -eq $Smtp.Cookie)) -and
            (($Referer -eq $null) -or ($Referer -eq $Smtp.Referer)) )
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

function Convert-ToTimePeriod
{
    [CmdletBinding()]
	[OutputType([System.String])]
    param(
        [parameter(Mandatory = $true)]
        [Sint32]
        $TimeValue,
        
        [parameter(Mandatory = $true)]
        [Sint32]
        $FileSize      
    )

    $TimePeriod

    if($TimeValue.LogFilePeriod -eq 4)
    {
        $TimePeriod = "Hour"
    }
    elseif($TimeValue.LogFilePeriod -eq 1)
    {
        $TimePeriod = "Daily"
    }
    elseif($TimeValue.LogFilePeriod -eq 2)
    {
        $TimePeriod = "Weekly"
    }
    elseif($TimeValue.LogFilePeriod -eq 3)
    {
        $TimePeriod = "Monthly"
    }
    elseif($TimeValue.LogFilePeriod -eq 0)
    {
        if($FileSize -ge 0)
        {
            $TimePeriod = "MB"
        }
        else
        {
            $TimePeriod = "Unlimited"
        }
    }
    else
    {
        $TimePeriod = $null
    }

    $TimePeriod
}

function Convert-FromTimePeriod
{
    [CmdletBinding()]
	[OutputType([System.Sint32])]
    param(
        [parameter(Mandatory = $true)]
        [String]
        $TimePeriod,
        
        [parameter(Mandatory = $true)]
        [Sint32]
        $FileSize 
    )

    $ConvertedTimePeriod

    if($TimePeriod  -eq "Hour")
    {
        $ConvertedTimePeriod = 4
    }
    elseif($TimePeriod -eq "Daily")
    {
        $ConvertedTimePeriod = 1
    }
    elseif($TimePeriod -eq "Weekly")
    {
        $ConvertedTimePeriod = 2
    }
    elseif($TimePeriod -eq "Monthly")
    {
        $ConvertedTimePeriod = 3
    }
    elseif(($TimePeriod -eq "MB") -or ($TimePeriod -eq "Unlimited"))
    {
        if($FileSize -ge 0)
        {
            $ConvertedTimePeriod = 0
        }
        else
        {
            $ConvertedTimePeriod = 0
        }
    }
    else
    {
        $ConvertedTimePeriod = $null
    }

    $ConvertedTimePeriod
}

function Convert-ToFileFormat
{
    [CmdletBinding()]
	[OutputType([System.String])]
    param(
        [parameter(Mandatory = $true)]
        [string]
        $LogPluginClsid
    )

    $FileFormat

    if($LogPluginClsid -eq "{FF160657-DE82-11CF-BC0A-00AA006111E0}")
    {
        $FileFormat = "MicrosoftIISLogFileFormat"
    }
    elseif($LogPluginClsid -eq "{FF16065F-DE82-11CF-BC0A-00AA006111E0}")
    {
        $FileFormat = "NCSACommonLogFileFormat"
    }
    elseif($LogPluginClsid -eq "{FF16065B-DE82-11CF-BC0A-00AA006111E0}")
    {
        $FileFormat = "ODBCLogging"
    }
    elseif($LogPluginClsid -eq "{FF160663-DE82-11CF-BC0A-00AA006111E0}")
    {
        $FileFormat = "W3CExtendedLogFileFormat"
    }
    else
    {
        $FileFormat = $null
    }

    $FileFormat
}

function Convert-FromFileFormat
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [parameter(Mandatory = $true)]
        [string]
        $LogFormat
    )

    $LogPluginClsid
     
    if($LogFormat -eq "MicrosoftIISLogFileFormat")
    {
        $LogPluginClsid = "{FF160657-DE82-11CF-BC0A-00AA006111E0}"
    }
    elseif($LogFormat  -eq "NCSACommonLogFileFormat")
    {
        $LogPluginClsid = "{FF16065F-DE82-11CF-BC0A-00AA006111E0}"
    }
    elseif($LogFormat  -eq "ODBCLogging")
    {
        $LogPluginClsid =  "{FF16065B-DE82-11CF-BC0A-00AA006111E0}"
    }
    elseif($LogFormat  -eq "W3CExtendedLogFileFormat")
    {
        $LogPluginClsid = "{FF160663-DE82-11CF-BC0A-00AA006111E0}"
    }
    else
    {
        $LogPluginClsid = $null
    }

    $LogPluginClsid
}

#endregion 

Export-ModuleMember -Function *-TargetResource