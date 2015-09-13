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
default["mysql_test_schema"]["sakila"]["checksum"] = "5879c37ddf08a5f97111ffd15e05c12f31a68843ce91f7e0d40ad45e6cce0ce4"
