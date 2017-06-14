function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $FilePath,

        [parameter(Mandatory = $true)]
        [System.String]
        $textToBeReplaced

    )
}

function Set-TargetResource
{

[CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $FilePath,

        [parameter(Mandatory = $true)]
        [System.String]
        $textToBeReplaced,

        [parameter(Mandatory = $true)]
        [String]
        $textToReplaceWith
    )

}

function Test-TargetResource
{
[CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $FilePath,

        [parameter(Mandatory = $true)]
        [System.String]
        $textToBeReplaced

    )


}
