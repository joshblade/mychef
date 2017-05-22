actions :add, :remove
default_action :add

attribute :user_name, kind_of: String
attribute :computer_name, kind_of: String
attribute :group_name, kind_of: String, required: true
