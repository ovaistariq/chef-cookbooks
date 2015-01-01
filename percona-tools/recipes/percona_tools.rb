#
# Cookbook Name:: percona-tools
# Recipe:: percona_tools
#

include_recipe "percona-tools::percona_repo"

# Not including database::mysql recipe here
# This is explained in the issue https://github.com/opscode-cookbooks/database/issues/101
include_recipe "database"

mysql_chef_gem 'default' do
  action :install
end

# Tools versions
toolkit_version = node["percona_tools"]["toolkit"]["version"]
xtrabackup_version = node["percona_tools"]["xtrabackup"]["version"]

mysql_socket = node["mysql"]["socket"]
mysql_root_pass = node["mysql"]["root_password"]
mysql_ro_user = node["percona_tools"]["read_only_user"]["username"]
mysql_rw_user = node["percona_tools"]["read_write_user"]["username"]

# Generate a secure random password using OpenSSL
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless["percona_tools"]["read_only_user"]["password"] = secure_password
mysql_ro_pass = secure_password

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless["percona_tools"]["read_write_user"]["password"] = secure_password
mysql_rw_pass = secure_password

# Install the tools
yum_package "percona-toolkit" do
    action  :install
    version toolkit_version
    flush_cache [:before]
end

yum_package "percona-xtrabackup" do
    action  :install
    version xtrabackup_version
    flush_cache [:before]
end

# Setup configuration files for read-only percona-toolkit tools
for conf_file in [ ".pt-table-checksum.conf", ".pt-slave-find.conf", ".pt-mysql-summary.conf", ".pt-kill.conf", ".pt-log-player.conf", ".pt-upgrade.conf", ".pt-heartbeat.conf", ".pt-slave-delay.conf" ] do
    template "/root/#{conf_file}" do
        variables(
            :username => mysql_ro_user,
            :password => mysql_ro_pass
        )
        source "pt_tool.conf.erb"
        owner "root"
        group "root"
        mode "0600"
        action :create
    end
end

# Setup configuration files for read-write percona-toolkit tools
for conf_file in [ ".pt-table-sync.conf", ".pt-online-schema-change.conf" ] do
    template "/root/#{conf_file}" do
        variables(
            :username => mysql_rw_user,
            :password => mysql_rw_pass
        )
        source "pt_tool.conf.erb"
        owner "root"
        group "root"
        mode "0600"
        action :create
    end
end

# Setup the MySQL conneciton hash that will be used later on
# when creating databases and users
mysql_connection_info = {
  :host     => "localhost",
  :socket   => mysql_socket,
  :username => "root",
  :password => mysql_root_pass
}

# Create the Percona schema
mysql_database "percona" do
  connection mysql_connection_info
  action :create
end

# Create the percona toolkit read-only MySQL user
for host_pattern in node["percona_tools"]["read_only_user"]["allowed_hosts"] do
    mysql_database_user mysql_ro_user do
      connection    mysql_connection_info
      password      mysql_ro_pass
      host          host_pattern
      privileges    ["SELECT","PROCESS","SUPER","REPLICATION SLAVE","REPLICATION CLIENT"]
      action        :grant
    end
end

for host_pattern in node["percona_tools"]["read_only_user"]["allowed_hosts"] do
    mysql_database_user mysql_ro_user do
      connection    mysql_connection_info
      password      mysql_ro_pass
      database_name "percona"
      host          host_pattern
      privileges    [:all]
      action        :grant
    end
end

# Create the percona toolkit read-write MySQL user
for host_pattern in node["percona_tools"]["read_write_user"]["allowed_hosts"] do
    mysql_database_user mysql_rw_user do
      connection    mysql_connection_info
      password      mysql_rw_pass
      host          host_pattern
      privileges    [:all]
      action        :grant
    end
end
