actions :create
default_action :create

attribute :name, name_attribute: true, kind_of: String, required: true
attribute :path, kind_of: String, required: true
attribute :protect, kind_of: [TrueClass, FalseClass], default: true
