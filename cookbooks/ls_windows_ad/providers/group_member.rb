include Chef::Mixin::PowershellOut

def load_current_resource
  @current_resource = Chef::Resource::LsWindowsAdGroupMember.new(@new_resource.name)
  @current_resource.user_name(@new_resource.user_name)
  @current_resource.computer_name(@new_resource.computer_name)
  @current_resource.group_name(@new_resource.group_name)
  @current_resource.domain_name(@new_resource.domain_name)
  @current_resource.cmd_user(@new_resource.cmd_user)
  @current_resource.cmd_pass(@new_resource.cmd_pass)
  @current_resource.cmd_domain(@new_resource.cmd_domain)  
end

def whyrun_supported?
  true
end

action :add do
  converge_by("Add #{@new_resource.user_name} to group #{@new_resource.group_name}") do
    if @new_resource.user_name
      add_group_member_user
    end
    if @new_resource.computer_name
      add_group_member_computer
    end
  end
end

action :remove do
  converge_by("Remove #{@new_resource.user_name} from group #{@new_resource.group_name}") do
    remove_group_member
  end
end

private

def add_group_member_user
  powershell_script "Add #{new_resource.user_name} to group #{new_resource.group_name}" do
    code <<-EOH
      $user = Get-ADUser "#{new_resource.user_name}" -Properties DistinguishedName
      Set-ADGroup -Identity "#{new_resource.group_name}" -Add @{'Member'=$user.DistinguishedName}
    EOH
    guard_interpreter :powershell_script
    not_if <<-EOH
      (Get-ADGroupMember "#{new_resource.group_name}" | where {$_.SamAccountName -eq "#{new_resource.user_name}"}).SamAccountName -eq "#{new_resource.user_name}"
    EOH
  end 
end

def add_group_member_computer
  powershell_script "Add #{new_resource.computer_name} to group #{new_resource.group_name}" do
    code <<-EOH
      $computer = Get-ADComputer "#{new_resource.computer_name}" -Properties DistinguishedName
      Set-ADGroup -Identity "#{new_resource.group_name}" -Add @{'Member'=$computer.DistinguishedName}
    EOH
    guard_interpreter :powershell_script
    not_if <<-EOH
      (Get-ADGroupMember "#{new_resource.group_name}" | where {$_.SamAccountName -eq '#{new_resource.computer_name}$'}).SamAccountName -eq '#{new_resource.user_name}$'
    EOH
  end
end

def remove_group_member
  powershell_script "Remove #{new_resource.user_name} to group #{new_resource.group_name}" do
    code <<-EOH
      $user = Get-ADUser "#{new_resource.user_name}" -Properties DistinguishedName
      Set-ADGroup -Identity "#{new_resource.group_name}" -Remove @{'Member'=$user.DistinguishedName}
    EOH
    guard_interpreter :powershell_script
    only_if <<-EOH
      (Get-ADMember #{new_resource.group_name} | where {$_.SamAccountName -eq "#{new_resource.user_name}"}).SamAccountName -eq "#{new_resource.user_name}"
    EOH
  end
end
