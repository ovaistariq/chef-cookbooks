# Include the recipes that we will use to create the necessary user 
include_recipe "users"

# Create the user "test_user" using the databag "users"
users_manage "Create the #{node["test_user"]["system_username"]} user" do
  search_group node["test_user"]["system_group_name"]
  group_name node["test_user"]["system_group_name"]
  group_id 2300
  action [ :remove, :create ]
end

# Create the SSH keys for the user "test_user" using 
# the encrypted data bag "users_sshkeys"
include_recipe "users_sshkeys"

users_sshkeys_manage "Create the SSH keys for the #{node["test_user"]["system_username"]} user" do
  action :create
end
