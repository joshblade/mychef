actions :create
default_action :create

attribute :name, name_attribute: true, kind_of: String, required: true
attribute :category, kind_of: String, default: "Security"
attribute :scope, kind_of: String, default: "Global"
attribute :ou, kind_of: String, required: true
