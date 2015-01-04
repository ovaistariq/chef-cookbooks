#
# Cookbook Name:: percona-tools
# Recipe:: percona_tools
#

include_recipe "percona-tools::percona_repo"

# Not including database::mysql recipe here
# This is explained in the issue https://github.com/opscode-cookbooks/database/issues/101
include_recipe "database"
mysql_chef_gem "default" do
  action :install
end

# Tools versions
if node["platform"] == "redhat"
  if node["platform_version"].to_f >= 7.0
    toolkit_version = node["percona_tools"]["toolkit"]["version"]
    xtrabackup_version = node["percona_tools"]["xtrabackup"]["version"] + ".el7"
  elsif node["platform_version"].to_f >= 6.0
    toolkit_version = node["percona_tools"]["toolkit"]["version"]
    xtrabackup_version = node["percona_tools"]["xtrabackup"]["version"] + ".el6"
  end
end

mysql_socket = node["mysql"]["socket"]
mysql_ro_user = node["percona_tools"]["read_only_user"]["username"]
mysql_rw_user = node["percona_tools"]["read_write_user"]["username"]

# here we check if databag has been setup to be used for fetching
# the mysql user passwords
if node["percona_tools"].attribute?("use_encrypted_databag") && node["percona_tools"]["use_encrypted_databag"]
    mysql_user_credentials = Chef::EncryptedDataBagItem.load(node["percona_tools"]["databag_name"], node["percona_tools"]["databag_item"])

    mysql_root_pass = mysql_user_credentials["root"]
    mysql_ro_pass = mysql_user_credentials[mysql_ro_user]
    mysql_rw_pass = mysql_user_credentials[mysql_rw_user]
else
    # Otherwise we try to fetch the mysql root user password 
    # from a node attribute
    mysql_root_pass = node["mysql"]["root_password"]

    # and we generate secure passwords for percona-toolkit 
    # specific users using OpenSSL
    if node["percona_tools"]["read_only_user"].attribute?("password")
        mysql_ro_pass = node["percona_tools"]["read_only_user"]["password"]
    else
        ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
        node.set["percona_tools"]["read_only_user"]["password"] = secure_password
        mysql_ro_pass = secure_password
    end

    if node["percona_tools"]["read_write_user"].attribute?("password")
        mysql_rw_pass = node["percona_tools"]["read_write_user"]["password"]
    else
        ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
        node.set["percona_tools"]["read_write_user"]["password"] = secure_password
        mysql_rw_pass = secure_password
    end
end

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
            :password => mysql_ro_pass,
            :socket => mysql_socket
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
            :password => mysql_rw_pass,
            :socket => mysql_socket
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
