actions :create
default_action :create

attribute :svcacct, name_attribute: true, kind_of: String, required: true
attribute :domain_name, kind_of: String
attribute :ou, kind_of: String
attribute :pswd, kind_of: String, required: true
