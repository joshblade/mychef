<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2014 v4.1.75
	 Created on:   	1/9/2015 10:37 AM
	 Created by:   	Gordon Coveney
	 Organization: 	REI Systems, inc.
	 Filename: CleanPrivateroot.ps1    	
	===========================================================================
	.DESCRIPTION
		Removes files from Y:\Privateroot that are more than 7 days old.
#>
$Today = Get-Date
$ExpireDate = $Today.AddDays(-7)
$files = Get-ChildItem Y:\Privateroot -Recurse | Where { $_.LastWriteTime -le $ExpireDate -and !$_.PSisContainer }
foreach ($f in $files)
{
	Remove-Item $f.FullName
}