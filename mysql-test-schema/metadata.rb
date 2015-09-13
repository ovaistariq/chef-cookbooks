name             'mysql-test-schema'
maintainer       'Ovais Tariq'
maintainer_email 'me@ovaistariq.net'
license          'All rights reserved'
description      'Installs/Configures mysql-test-schema'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

recipe "mysql-test-schema::employees",  "Sets up the test MySQL schema 'employees'"
recipe "mysql-test-schema::sakila",     "Sets up the test MySQL schema 'sakila'"

depends 'mysql', "~> 5.6"

supports "centos", ">= 6.4"
supports "redhat", ">= 6.4"
