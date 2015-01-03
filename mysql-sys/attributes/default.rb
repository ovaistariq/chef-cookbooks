#
# Cookbook Name:: mysql-sys
# Attributes:: default
#

default["mysql_sys"]["version"] = "1.3.0"
default["mysql_sys"]["git_repository"] = "git://github.com/MarkLeith/mysql-sys.git"
default["mysql_sys"]["git_revision"] = "v1.3.0a" # The git release tag name corresponding to the mysql-sys tool version that has to be installed

# If encrypted databags are being used (which is recommended) then 
# `use_encrypted_databag` should be set to true
default["mysql_sys"]["use_encrypted_databag"] = false

# These attributes are the data bag name and item name that are used when
# retrieving MySQL user passwords from the data bag
default["mysql_sys"]["databag_name"] = "passwords"
default["mysql_sys"]["databag_item"] = "mysql_users"