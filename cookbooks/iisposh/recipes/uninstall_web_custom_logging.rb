
windows_feature_manage_feature "#{cookbook_name}_uninstall_Web_Custom_Logging_Feature" do
  feature_name "Web-Custom-Logging"
  action :remove
end