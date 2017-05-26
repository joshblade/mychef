windows_package 'Odbc' do
  source "https://download.microsoft.com/download/5/7/2/57249A3A-19D6-4901-ACCE-80924ABEB267/1033/amd64/msodbcsql.msi"
  options "IACCEPTMSODBCSQLLICENSETERMS=YES"
  checksum "cc7fd7cbb9840de239dcc0c8ab12d2cc2bcf411af4b0b8bd5ab0730805f2f4b3"
  action :install
end

windows_package 'CmdLine' do
  source "https://download.microsoft.com/download/5/5/B/55BEFD44-B899-4B54-ACD7-506E03142B34/1033/x64/MsSqlCmdLnUtils.msi"
  options "IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES"
  checksum "33b136c49105ccbea415038520efbb2370f7b4a80b20bff47f8ae5d155bb1c5d"
  action :install
end

