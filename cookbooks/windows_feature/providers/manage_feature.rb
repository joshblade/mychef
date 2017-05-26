use_inline_resources

def whyrun_supported?
  false
end

action :install do

  if reboot_pending_status
    Chef::Log.info("********* A reboot is needed because of a previous feature/role addition or removal. Please reboot to avoid errors. *****************")
  end

  begin
  # If this is true then don't converge
  if @current_resource.exists
    Chef::Log.info("#{@new_resource.feature_name} was found on node #{node[:hostname]}. Did NOT run converge action to install feature/role")
    # Resource does not exist so converge
  else
    # Use Windows Features object to install feature specified in recipe.
    @feature.install_feature
    @new_resource.updated_by_last_action(true)
    Chef::Log.info("#{@new_resource.feature_name} was NOT found on node #{node[:hostname]}. Ran converge action to install feature/role")
  end

  rescue => e
    handle_error(e)
  end
end

action :remove do

  begin
  # If this is true then converge
  if @current_resource.exists
    # Use Windows Features object to remove feature specified in recipe.
    @feature.remove_feature
    @new_resource.updated_by_last_action(true)

    if reboot_pending_status
      Chef::Log.info("********* A reboot is needed to complete removal of the feature/role. Please reboot to avoid errors. *****************")
    end
    Chef::Log.info("#{@new_resource.feature_name} was found on node #{node[:hostname]}. Ran converge action to remove feature/role")

    # Resource does not exist so don't converge
  else
    Chef::Log.info("#{@new_resource.feature_name} was NOT found on node #{node[:hostname]}. Did NOT run converge action to remove feature/role")
  end

  rescue => e
    handle_error(e)
  end
end

def load_current_resource

  require 'mixlibrary/core/windows/features'

  begin
  @current_resource = Chef::Resource::WindowsFeatureManageFeature.new(@new_resource.name)
  @current_resource.feature_name(@new_resource.feature_name)

  @feature = Mixlibrary::Core::Windows::Features.new(@new_resource.feature_name)

  if @feature.is_feature_available?

    # Initialize the current_resource to false that way we always run the
    # idempotency check which determines if the resource is in the desired state
    @current_resource.exists = false

    # Use Windows Features object to do idompotency check.
    if @feature.is_installed?
      @current_resource.exists = true
    end
  else
    raise ArgumentError, "'#{@new_resource.feature_name}' is not an available feature/role on the target windows server. Raising an exception."
  end

  rescue ArgumentError => e
    raise e
  rescue => e
    Chef::Log.error("#{cookbook_name}_providers/manager_feature:load_current_resource - Failed to initialize instance of Mixlibrary::Core::Windows::Features.new(#{@new_resource.feature_name})")
    raise e
  end
end

def reboot_pending_status

  require 'mixlibrary/core/apps/shell'

  # The bulk of the following powershell script was "borrowed" from the Get-PendingReboot.ps1 script at
  # https://gallery.technet.microsoft.com/scriptcenter/Get-PendingReboot-Query-bdb79542 authored by Brian Wilhite

  # In this powershell script we just check if a reboot is needed because of previous feature/role addition or removal.
  script = <<-EOF

    $Computer = "#{node['hostname']}"

    # Making registry connection to the local/remote computer
    $RegCon = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]"LocalMachine",$Computer)

    $RegSubKeysCBS = $RegCon.OpenSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Component Based Servicing\\").GetSubKeyNames()
    $CBSRebootPend = $RegSubKeysCBS -contains "RebootPending"

    $RegCon.Close()

    if($CBSRebootPend){
      exit 55
    }
    else{
      exit 54
    }
  EOF

  result = Mixlibrary::Core::Shell.windows_script_out(:powershell,script)
  # Add Chef log debug for result.inspect
  Chef::Log.debug(result.inspect)

  exit_status = result.exitstatus

  if exit_status == 55
    return true
  elsif exit_status == 54
    return false
  else
    raise "Something unexpected happened while checking the reboot_pending status"
  end

end

def handle_error(err)
  # Strip all whitespace from error message to parse for specific string.
  estr = err.to_s.gsub(/\s+/, "")
  # If error message contains "restart the computer", without whitespace, then notify reboot resource.
  if estr.include?("Pleaserestartthecomputer")
    Chef::Log.error("@feature.install_feature experienced an error because the computer needs to be rebooted before adding/removing a feature/role.")
    raise err
  else
    Chef::Log.error("@feature.install_feature experienced an unknown error. Raising exception")
    raise err
  end
end
