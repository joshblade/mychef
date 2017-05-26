actions :install, :remove

default_action :install

# Name the feature or role.
attribute :feature_name,      :kind_of => String

attr_accessor :exists
