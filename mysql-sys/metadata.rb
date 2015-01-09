name              "mysql-sys"
maintainer        "Ovais Tariq"
maintainer_email  "me@ovaistariq.net"
description       "Installs the mysql-sys tool. Description of the tool is available here https://github.com/MarkLeith/mysql-sys"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.5.1"
license           "All rights reserved"

recipe "mysql-sys",       "Installs the mysql-sys tool"

depends "mysql-chef_gem", ">= 0.0.0"
depends "database", "~> 2.1"

supports "centos", ">= 6.4"
supports "redhat", ">= 6.4"
