#Description: This script will search a specified directory and create an index with the following content: FullName,PSChildName,CreationTimeUTC,LastAccessTimeUtc,Length. It will output into HTML

$Header = @"
<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #6495ED;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
</style>
"@
 


$htmlout = Get-ChildItem -Path '\\hrsafs.reisys.com\ise\Scripts' -Filter '*.ps*' | Select @{name="FullName";Expression={"<a href=file:///$_.FullName></a>"}},PSChildName,CreationTimeUTC,LastAccessTimeUtc,Length,@{Name='Owner';Expression={ (Get-Acl $_.PSPath).Owner }},@{Name ='Description';Expression={ (Get-content -Path $_.PSPath | Select-String -SimpleMatch '#Description:') }}
$htmlout | ConvertTo-Html -Head $Header | Out-File 'C:\Users\robert.burke\Scripts\XML-Testing\htmltest.html'



<#
$xmlout = Get-ChildItem -Path '\\hrsafs.reisys.com\ise\Scripts' -Filter '*.ps*' | Select FullName,PSChildName,CreationTimeUTC,LastAccessTimeUtc,Length,@{Name='Owner';Expression={ (Get-Acl $_.PSPath).Owner }}
$xmlout | Export-Clixml 'C:\Users\robert.burke\Scripts\XML-Testing\xmltest.xml'
#>

