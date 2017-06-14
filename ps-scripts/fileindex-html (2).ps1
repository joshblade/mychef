#READ THE COMMENTS BEFORE RUNNING, IT TELLS YOU HOW TO USE THIS SCRIPT

#Description: This script will search a specified directory and create an index with the following content: FullName,PSChildName,CreationTimeUTC,LastAccessTimeUtc,Length. It will output into HTML
#Author: Robert Burke 
#Email: Robert.Burke@reisystems.com
#Inputs to the script:
#SearchPath: This is the directory you want to search
#FileType: This is the file or files you are looking to index: *.ps*, *.mp*, help.txt
#OutputPath: directory and filename you want the output to be saved as: C:\mydirectory\myindex.html
#Run the script first to load it as a function, the use the below example to pass arguments
#USE EXAMPLE: FileIndex-Html -SearchPath 'C:\Users\robert.burke\Scripts' -fileType '*.ps*' -OutPutfile 'C:\Users\robert.burke\Scripts\script-out\mytest.html'

#This is a function, execute the code in this script by hitting the play button, then call it using the above example


#Function declaration
Function FileIndex-Html{
[CmdletBinding()]
#Arguments to the script
Param(
  [Parameter(Mandatory=$True,Position=1,HelpMessage="Enter the PATH to the directory you want to search, ie...'C:\Users\robert.burke\Scripts\script-out' no trailing slash ")]
   [string]$SearchPath,
	
   [Parameter(Mandatory=$False)]
   [string]$fileType,

   [Parameter(Mandatory=$True,HelpMessage="Save output as an HTML file")]
   [string]$OutPutfile

   
   
)
#HTML Header, this provides the formatting using CSS
$Header = @"
<style>
TABLE {border-width: 1px;border-style: solid;border-color: blue;border-collapse: collapse;background-color: lightblue}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #6495ED;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
</style>
"@

$htmlout = Get-ChildItem -Path "$SearchPath" -Filter "$fileType" | Select @{Name="Link";Expression={("<a rel=" + $_.FullName + " href=file:///" + $_.FullName + ">$_</a>")}},DirectoryName, PSChildName,CreationTimeUTC,LastAccessTimeUtc,Length,@{Name='Owner';Expression={ (Get-Acl $_.PSPath).Owner }},@{Name ='Description';Expression={ (Get-content -Path $_.PSPath | Select-String -SimpleMatch '#Description:') }}
$htmlout | ConvertTo-Html -Head $Header -Title "Files of type $filetype in $SearchPath"  | foreach {$tmp = $_ -replace "&lt;","<"; $tmp -replace "&gt;",">";} | Out-File "$OutPutfile"
}
