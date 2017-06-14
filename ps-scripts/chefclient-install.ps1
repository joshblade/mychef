$fileName = 'chef-client-13.0.118-1-x64.msi'
$fileshare = 'https://reieast2storage.file.core.windows.net/ise/prerequisites/'
$accesskey = '?sv=2016-05-31&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-05-06T20:54:27Z&st=2017-05-06T12:54:27Z&spr=https,http&sig=8bqhO9hwixImNAvlJaz7JBzE1z0QNYfSoxm2jT7Lnwk%3D'

wget -UseBasicParsing -Uri ($fileshare + $fileName + $accesskey)  -OutFile 'c:\temp\chef-client-13.0.118-1-x64.msi'