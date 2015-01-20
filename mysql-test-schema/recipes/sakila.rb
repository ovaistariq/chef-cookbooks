#
# Cookbook Name:: mysql-test-schema
# Recipe:: sakila
#

# Setup file paths
src_filename = node["mysql_test_schema"]["sakila"]["dump_filename"]
src_filepath = "#{Chef::Config['file_cache_path']}/#{src_filename}"
extract_path = "#{Chef::Config['file_cache_path']}/sakila-db/#{node['mysql_test_schema']['sakila']['checksum']}"

# MySQL authentication related
mysql_socket = node["mysql"]["socket"]
if node["mysql_test_schema"].attribute?("use_encrypted_databag") && node["mysql_test_schema"]["use_encrypted_databag"]
    mysql_user_credentials = Chef::EncryptedDataBagItem.load(node["mysql_test_schema"]["databag_name"], node["mysql_test_schema"]["databag_item"])

    mysql_root_pass = mysql_user_credentials["root"]
else
    # Otherwise we try to fetch the mysql root user password 
    # from a node attribute
    mysql_root_pass = node["mysql"]["root_password"]
end

# Download the employees db dump
remote_file src_filepath do
  owner "root"
  group "root"
  mode "0644"
  source "#{node["mysql_test_schema"]["sakila"]["url"]}/#{src_filename}"
  checksum node['mysql_test_schema']['sakila']['checksum']
  notifies :run, "bash[extract_sakila_db_dump_archive]", :immediately
end

# Extract the employees db dump
bash "extract_sakila_db_dump_archive" do
  action :nothing
  user "root"
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    mkdir -p #{extract_path}
    tar xzf #{src_filename} -C #{extract_path}
    mv #{extract_path}/*/* #{extract_path}/
  EOH
  not_if { ::File.exists?(extract_path) }
  notifies :run, "bash[load_sakila_db_dump_mysql]", :immediately
end

# Load the employees db dump 
bash "load_sakila_db_dump_mysql" do
  action :nothing
  user "root"
  cwd extract_path
  code <<-EOH
    mysql --user=root --password=#{mysql_root_pass} --socket=#{mysql_socket} -t < sakila-schema.sql
    mysql --user=root --password=#{mysql_root_pass} --socket=#{mysql_socket} -t < sakila-data.sql
  EOH
end
