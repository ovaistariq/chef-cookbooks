#
# Cookbook Name:: percona-tools
# Attributes:: default
#

# The attributes are related to yum repository setup
default["percona_tools"]["yum"]["description"] = "CentOS $releasever - Percona"
default["percona_tools"]["yum"]["baseurl"] = "http://repo.percona.com/centos/$releasever/os/$basearch/"
default["percona_tools"]["yum"]["gpgkey"] = "http://www.percona.com/downloads/RPM-GPG-KEY-percona"
default["percona_tools"]["yum"]["gpgcheck"] = true

# The Percona tools versions
default["percona_tools"]["xtrabackup"]["version"] = "2.2.5-5027"
default["percona_tools"]["toolkit"]["version"] = "2.2.11-1"

# The definition of the MySQL users used by perconat-toolkit
# If using encrypted data bags then the MySQL usernames defined below 
# should be the key for the data bag item
# The allowed_hosts stores the list of hosts tha are allowed to connect
# to MySQL using these usernames
default["percona_tools"]["read_only_user"] = {
    "username" => "ptro",
    "allowed_hosts" => ["%", node['fqdn'], "localhost"]
}

default["percona_tools"]["read_write_user"] = {
    "username" => "ptrw",
    "allowed_hosts" => ["%", node['fqdn'], "localhost"]
}

# If encrypted databags are being used (which is recommended) then 
# `use_encrypted_databag` should be set to true
default["percona_tools"]["use_encrypted_databag"] = false

# These attributes are the data bag name and item name that are used when
# retrieving MySQL user passwords from the data bag
default["percona_tools"]["databag_name"] = "passwords"
default["percona_tools"]["databag_item"] = "mysql_users"