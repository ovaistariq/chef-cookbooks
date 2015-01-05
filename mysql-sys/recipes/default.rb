#
# Cookbook Name:: mysql-sys
# Recipe:: default
#

mysql_sys_src_dir = "/usr/src/mysql-sys"

mysql_socket = node["mysql"]["socket"]

# here we check if databag has been setup to be used for fetching
# the mysql user passwords
if node["mysql_sys"].attribute?("use_encrypted_databag") && node["mysql_sys"]["use_encrypted_databag"]
    mysql_user_credentials = Chef::EncryptedDataBagItem.load(node["mysql_sys"]["databag_name"], node["mysql_sys"]["databag_item"])

    mysql_root_pass = mysql_user_credentials["root"]
else
    # Otherwise we try to fetch the mysql root user password 
    # from a node attribute
    mysql_root_pass = node["mysql"]["root_password"]
end

# Install the git package
package "git" do
    action :install
end

# Not including database::mysql recipe here
# This is explained in the issue https://github.com/opscode-cookbooks/database/issues/101
include_recipe "database"

mysql_chef_gem "default" do
  action :install
end

# Setup the MySQL conneciton hash that will be used later on
# when creating database and executing the sql script
mysql_connection_info = {
  :host     => "localhost",
  :socket   => mysql_socket,
  :username => "root",
  :password => mysql_root_pass
}

# Checkout the mysql-sys repository
git mysql_sys_src_dir do
    repository node["mysql_sys"]["git_repository"]
    revision node["mysql_sys"]["git_revision"]
    action :sync
end

bash "generate_sql_installation_file" do
    cwd mysql_sys_src_dir
    user "root"
    group "root"
    code "./generate_sql_file.sh -v 56"
    action :run
    not_if { ::File.exists?("#{mysql_sys_src_dir}/sys_#{node["mysql_sys"]["version"]}_56_inline.sql") }
    notifies :create, "mysql_database[create_sys_schema]", :immediately
end

# Create the sys schema that is required by mysql-sys
mysql_database "create_sys_schema" do
    connection mysql_connection_info
    database_name "sys"
    action :nothing
end

# By default we do nothing, this action is only fired when the "sys" schema
# was created above because it did not exist
bash "install_mysql_sys" do
    cwd mysql_sys_src_dir
    user "root"
    group "root"
    code <<-EOF
        mysql --user=root --password='#{mysql_root_pass}' --socket=#{mysql_socket} < #{mysql_sys_src_dir}/sys_#{node["mysql_sys"]["version"]}_56_inline.sql
    EOF
    action :nothing
    subscribes :run, "bash[generate_sql_installation_file]"
    subscribes :run, "mysql_database[create_sys_schema]"
end
