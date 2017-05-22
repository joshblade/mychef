if defined?(ChefSpec)
  ChefSpec.define_matcher :ls_windows_ad_svcacct
  
  def create_ls_windows_ad_svcacct(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ls_windows_ad_svcacct, :create,
                                            resource_name)
  end
  
  def modify_ls_windows_ad_svcacct(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ls_windows_ad_svcacct, :modify,
                                            resource_name)
  end
  
  def move_ls_windows_ad_svcacct(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ls_windows_ad_svcacct, :move,
                                            resource_name)
  end
  
  def delete_ls_windows_ad_svcacct(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ls_windows_ad_svcacct, :delete,
                                            resource_name)
  end
end