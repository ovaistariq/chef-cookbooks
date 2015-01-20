#
# Cookbook Name:: mysql-test-schema
# Attributes:: default
#

# The attributes are related to the employees db dump
default["mysql_test_schema"]["employee"]["version"] = "1.0.6"
default["mysql_test_schema"]["employee"]["url"] = "https://launchpad.net/test-db/employees-db-1/#{node["mysql_test_schema"]["employee"]["version"]}/+download"
default["mysql_test_schema"]["employee"]["dump_filename"] = "employees_db-full-#{node["mysql_test_schema"]["employee"]["version"]}.tar.bz2"
default["mysql_test_schema"]["employee"]["checksum"] = "9be9b830a185e947758581cb06f529d1e8b675b29cde13a2860b1319b7e1cb7d"

# The attributes are related to the sakila db dump
default["mysql_test_schema"]["sakila"]["url"] = "http://downloads.mysql.com/docs"
default["mysql_test_schema"]["sakila"]["dump_filename"] = "sakila-db.tar.gz"
default["mysql_test_schema"]["sakila"]["checksum"] = "619bad5852078d30d7812492f4e75b3b4baeae99034b34a4934b3715c2abf2b8"

# Databags if available are used to retrieve the MySQL root user password.
# If encrypted databags are being used (which is recommended) then 
# `use_encrypted_databag` should be set to true
default["mysql_test_schema"]["use_encrypted_databag"] = false

# These attributes are the data bag name and item name that are used when
# retrieving MySQL user passwords from the data bag
default["mysql_test_schema"]["databag_name"] = "passwords"
default["mysql_test_schema"]["databag_item"] = "mysql_users"