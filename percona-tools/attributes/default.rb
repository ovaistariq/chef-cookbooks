#
# Cookbook Name:: percona-tools
# Attributes:: default
#

default["percona_tools"]["yum"]["description"] = "CentOS $releasever - Percona"
default["percona_tools"]["yum"]["baseurl"] = "http://repo.percona.com/centos/$releasever/os/$basearch/"
default["percona_tools"]["yum"]["gpgkey"] = "http://www.percona.com/downloads/RPM-GPG-KEY-percona"
default["percona_tools"]["yum"]["gpgcheck"] = true

default["percona_tools"]["xtrabackup"]["version"] = "2.2.5-5027.el6"
default["percona_tools"]["toolkit"]["version"] = "2.2.11-1"

default["percona_tools"]["read_only_user"] = {
    "username" => "ptro",
    "allowed_hosts" => ["%", "localhost"]
}

default["percona_tools"]["read_write_user"] = {
    "username" => "ptrw",
    "allowed_hosts" => ["%", "localhost"]
}