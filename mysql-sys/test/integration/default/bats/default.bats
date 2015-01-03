#!/usr/bin/env bats

load test_helper

@test "Check that MySQL sys schema is installed" {
	mysql_sys_schema_tables_count=$(mysql -uroot -proot -S /var/run/mysql-default/mysqld.sock -NB -e "select count(*) from tables where table_schema='sys' and table_name='version'" information_schema)
    
    (( $mysql_sys_schema_tables_count > 0 ))
}

@test "Check that MySQL sys schema version is 1.3.0" {
	mysql_sys_version_installed=$(mysql -uroot -proot -S /var/run/mysql-default/mysqld.sock -NB -e "select sys_version from version" sys)

	[[ "$mysql_sys_version_installed" == "1.3.0" ]]
}

@test "Check that Performance Schema is enabled in MySQL" {
    performance_schema_enabled=$(mysqladmin -uroot -proot -S /var/run/mysql-default/mysqld.sock variables | grep -w performance_schema | awk '{print $4}')
    [[ ${performance_schema_enabled} == "ON" ]]
}

@test "Check that Performance Schema instrumentation is working" {
    instrumentation_host_summary=$(mysql -uroot -proot -S /var/run/mysql-default/mysqld.sock -NB -e "select count(*) from host_summary" sys)

    (( ${instrumentation_host_summary} > 0 ))
}