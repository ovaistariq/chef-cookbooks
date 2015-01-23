#
# Cookbook Name:: users_sshkeys
# Provider:: manage
#

use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

def initialize(*args)
  super
  @action = :create
end

def chef_solo_search_installed?
  klass = ::Search::const_get('Helper')
  return klass.is_a?(Class)
rescue NameError
  return false
end

action :create do
  if Chef::Config[:solo] and not chef_solo_search_installed?
    Chef::Log.warn("This recipe uses search. Chef Solo does not support search unless you install the chef-solo-search cookbook.")
  else
    search(new_resource.data_bag, "*:*") do |databag_item|
      username = databag_item['id']
      user = Chef::EncryptedDataBagItem.load(new_resource.data_bag, username)

      # Set home_basedir based on platform_family
      case node['platform_family']
      when 'mac_os_x'
          home_basedir = '/Users'
      when 'debian', 'rhel', 'fedora', 'arch', 'suse', 'freebsd'
          home_basedir = '/home' 
      end

      # Set home to a reasonable default ($home_basedir/$user).
      home_dir = "#{home_basedir}/#{username}"

    	if home_dir != "/dev/null"
    	  converge_by("would create #{home_dir}/.ssh") do
    	    directory "#{home_dir}/.ssh" do
    	      owner username
    	      mode "0700"
          end
        end

        if user['ssh_keys']
          template "#{home_dir}/.ssh/authorized_keys" do
            source "authorized_keys.erb"
            cookbook new_resource.cookbook
            owner username
            mode "0600"
            variables :ssh_keys => user['ssh_keys']
          end
        end

        if user['ssh_private_key']
          key_type = user['ssh_private_key'].include?("BEGIN RSA PRIVATE KEY") ? "rsa" : "dsa"
          template "#{home_dir}/.ssh/id_#{key_type}" do
            source "private_key.erb"
            cookbook new_resource.cookbook
            owner username
            mode "0400"
            variables :private_key => user['ssh_private_key']
          end
        end

        if user['ssh_public_key']
          key_type = user['ssh_public_key'].include?("ssh-rsa") ? "rsa" : "dsa"
          template "#{home_dir}/.ssh/id_#{key_type}.pub" do
            source "public_key.pub.erb"
            cookbook new_resource.cookbook
            owner username
            mode "0400"
            variables :public_key => user['ssh_public_key']
          end
        end
      end
    end
  end
end
