#
# Cookbook Name:: users_sshkeys
# Resources:: manage
#

# Data bag user object needs an "action": "remove" tag to actually be removed by the action.
actions :create

# :data_bag is the object to search
# :search_group is the groups name to search for, defaults to resource name
# :group_name is the string name of the group to create, defaults to resource name
# :group_id is the numeric id of the group to create, default is to allow the OS to pick next
# :cookbook is the name of the cookbook that the authorized_keys template should be found in
attribute :data_bag, :kind_of => String, :default => "users_sshkeys"
attribute :cookbook, :kind_of => String, :default => "users_sshkeys"

def initialize(*args)
  super
  @action = :create
end
