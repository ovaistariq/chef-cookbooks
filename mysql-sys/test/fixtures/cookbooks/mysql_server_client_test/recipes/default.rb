
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
