# Override mysql cookbook attributes
node.set['mysql']['server_root_password'] = 'changeme'
node.set['mysql']['data_dir'] = '/var/lib/mysql'

# Install and configure MySQL server
include_recipe 'mysql::client'
include_recipe 'mysql::server'

template "/root/.my.cnf" do
    source "my.root.cnf.erb"
    owner "root"
    group "root"
    mode "0600"
    variables( :password => node['mysql']['server_root_password'] )
end
