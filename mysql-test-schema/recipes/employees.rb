#
# Cookbook Name:: mysql-test-schema
# Recipe:: employees
#

# Setup file paths
src_filename = node["mysql_test_schema"]["employee"]["dump_filename"]
src_filepath = "#{Chef::Config['file_cache_path']}/#{src_filename}"
extract_path = "#{Chef::Config['file_cache_path']}/employees-db-1/#{node['mysql_test_schema']['employee']['checksum']}"

# Download the employees db dump
remote_file src_filepath do
  owner "root"
  group "root"
  mode "0644"
  source "#{node["mysql_test_schema"]["employee"]["url"]}/#{src_filename}"
  checksum node['mysql_test_schema']['employee']['checksum']
  notifies :run, "bash[extract_employee_db_dump_archive]", :immediately
end

# Extract the employees db dump
bash "extract_employee_db_dump_archive" do
  action :nothing
  user "root"
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    mkdir -p #{extract_path}
    tar xjf #{src_filename} -C #{extract_path}
    mv #{extract_path}/*/* #{extract_path}/
  EOH
  not_if { ::File.exists?(extract_path) }
  notifies :run, "bash[load_employee_db_dump_mysql]", :immediately
end

# Load the employees db dump 
bash "load_employee_db_dump_mysql" do
  action :nothing
  user "root"
  cwd extract_path
  code <<-EOH
    mysql -t < employees.sql
  EOH
end
