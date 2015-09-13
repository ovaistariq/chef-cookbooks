name             'mysql-test-schema'
maintainer       'Ovais Tariq'
maintainer_email 'me@ovaistariq.net'
license          'All rights reserved'
description      'Installs/Configures mysql-test-schema'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.1'

recipe "mysql-test-schema::employees",  "Sets up the test MySQL schema 'employees'"
recipe "mysql-test-schema::sakila",     "Sets up the test MySQL schema 'sakila'"

depends 'mysql', "~> 6.0"

supports "centos", ">= 6.4"
supports "redhat", ">= 6.4"
supports "debian", ">= 7.4"
supports "ubuntu", ">= 10.04"
