action :create do
  converge_by("Create group #{@new_resource}") do
    create_group
  end
end

def whyrun_supported?
  true
end

def load_current_resource
  @current_resource = Chef::Resource::LsWindowsAdGroups.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.category(@new_resource.category)
  @current_resource.scope(@new_resource.scope)
  @current_resource.ou(@new_resource.ou)
end

private

def create_group
  powershell_script "Create group #{new_resource.name}" do
    code <<-EOH
      $GroupName = "#{new_resource.name}"
      $Category = "#{new_resource.category}"
      $Scope = "#{new_resource.scope}"
      $OU = "#{new_resource.ou}"
      New-ADGroup -GroupCategory:$Category `
                  -GroupScope:$Scope `
                  -Name:$GroupName `
                  -Path:$OU `
                  -SamAccountName:$GroupName
    EOH
    guard_interpreter :powershell_script
    not_if <<-EOH
    $exists = $false
      try{
          $group = Get-ADGroup "#{new_resource.name}"
          if($group){$exists = $true}
      }
      catch{}
      $exists
    EOH
  end
end
