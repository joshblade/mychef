# Define Actions of the Provider
include Chef::Mixin::PowershellOut

def load_current_resource
  @current_resource = Chef::Resource::LsWindowsAdSvcacct.new(@new_resource.name)
  @current_resource.svcacct(@new_resource.svcacct)
  @current_resource.domain_name(@new_resource.domain_name)
  @current_resource.ou(@new_resource.ou)
end

action :create do
  converge_by("Create service account #{ @new_resource }") do
    create_service_acct
  end
end

def whyrun_supported?
  true
end

private

def create_service_acct
  powershell_script "Create Service Account #{new_resource.svcacct}" do
    code <<-EOH
      # Create Properties
      $AcctName = "#{new_resource.svcacct}"
      $DomainName = "#{new_resource.domain_name}"
      $OU = "#{new_resource.ou}"
      $UPN = "#{new_resource.svcacct}@$env:USERDNSDOMAIN"
      $password = ConvertTo-SecureString '#{new_resource.pswd}' -AsPlainText -Force

      New-ADUser -DisplayName $AcctName `
                 -GivenName $AcctName `
                 -Name $AcctName `
                 -Path $OU `
                 -SamAccountName $AcctName `
                 -UserPrincipalName $UPN `
                 -CannotChangePassword $true `
                 -AccountPassword $password `
                 -ChangePasswordAtLogon $false `
                 -PasswordNeverExpires $true `
                 -Enabled $true

    EOH
    guard_interpreter :powershell_script
    not_if <<-EOH
      $exists = $false
      try{
          $user = Get-ADUser "#{new_resource.svcacct}"
          if($user){$exists = $true}
      }
      catch{}
      $exists
    EOH
  end
end
