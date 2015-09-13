
# We need to run update apt-cache before package installation otherwise apt
# picks up outdated packages
if platform_family?("debian")
  execute "update-apt-cache" do
    command "apt-get update"
    creates "/tmp/apt_cache.updated"
    action :run
    not_if { File.exist?("/tmp/apt_cache.updated") }
  end
end

# Install the MySQL client
mysql_client "default" do
  version node["mysql"]["version"]
  action [:create]
end

# Install and setup the MySQL server
mysql_service "default" do
  version node["mysql"]["version"]
  initial_root_password node["mysql"]["root_password"]
  action [:create, :start]
end
