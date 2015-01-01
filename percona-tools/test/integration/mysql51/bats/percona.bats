#!/usr/bin/env bats

load test_helper

@test "Check that the Percona repository is enabled" {
	check_file /etc/yum.repos.d/percona.repo root 644
	ret_code=$?

	if [[ ${ret_code} == 0 ]] && [[ $(sudo grep enabled /etc/yum.repos.d/percona.repo | cut -d= -f2) == 1 ]]; then
		ret_code=0
	else
		ret_code=1
	fi

	[[ ${ret_code} == 0 ]]
}

@test "Check that percona-toolkit package is installed" {
	run rpm -q percona-toolkit
	[[ ${status} == 0 ]]
}

@test "Check that percona-xtrabackup package is installed" {
	run rpm -q percona-xtrabackup
	[[ ${status} == 0 ]]
}

@test "Check that percona schema exists" {
	[[ $(mysql -uroot -proot -S /var/run/mysql-default/mysqld.sock -NB -e "show databases" | grep -wc percona) == 1 ]]
}
