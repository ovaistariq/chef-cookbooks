#
# Cookbook Name:: percona-tools
# Recipe:: percona_repo
#

include_recipe "yum"

yum_repository 'percona' do
	name 'percona'
	description node["percona_tools"]["yum"]["description"]
	url node["percona_tools"]["yum"]["baseurl"]
	gpgkey node["percona_tools"]["yum"]["gpgkey"]
	gpgcheck node["percona_tools"]["yum"]["gpgcheck"] if respond_to? :gpgcheck
	action :add
end