action :create do
  converge_by("Create OU #{ @new_resource }") do
    create_ou
  end
end

def whyrun_supported?
  true
end

def load_current_resource
  @current_resource = Chef::Resource::LsWindowsAdOu.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.path(@new_resource.path)
  @current_resource.protect(@new_resource.protect)
end

private

def create_ou
  powershell_script "Create OU #{new_resource.name}" do
    code <<-EOH
      $OUName = "#{new_resource.name}"
      $Path = "#{new_resource.path}"
      $ProtectfromAccidentalDeletion = #{new_resource.protect}
      New-ADOrganizationalUnit -Name:$OUName -Path:$Path -ProtectedFromAccidentalDeletion:$ProtectFromAccidentalDeletion
    EOH
    guard_interpreter :powershell_script
    not_if <<-EOH
      $exists = $false
      try{
          $OUId = "OU=" + "#{new_resource.name}," + "#{new_resource.path}"
          $OU = Get-ADOrganizationalUnit -Identity $OUId
          if($OU){$exists = $true}
      }
      catch{}
      $exists
    EOH
  end
end