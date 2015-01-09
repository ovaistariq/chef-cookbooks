percona-tools Cookbook
=====================
The percona-tools cookbook does the following:
- Installs Percona yum repository
- Installs and configures percona-toolkit package
- Installs and configures percona-xtrabackup package

Requirements
------------
- Chef 11 or higher
- Ruby 1.9 or higher (preferably from the Chef full-stack installer)
- Network accessible package repositories

Platform Support
----------------
The following platforms are supported:
* CentOS
* Red Hat

The following 64-bit platforms have been tested:
* CentOS 6.4
* CentOS 6.5
* CentOS 7.0

Cookbook Dependencies
---------------------
- yum
- mysql-chef_gem
- database
- openssl

Usage
-----
Just include `mysql-sys` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[mysql-sys]"
  ]
}
```

Or, place a dependency on the percona-tools cookbook in your cookbook's  metadata.rb

```ruby
depends "percona-tools", "~> 0.5"
```

Then, in a recipe:

```ruby
include_recipe "percona-tools"
```

#### MySQL versions supported
MySQL versions 5.1, 5.5 and 5.6 are supported

#### MySQL users used by the cookbook
The cookbook requires the MySQL root user password and the password for two separate users that are setup for use by percona-toolkit. By default the usernames used are "ptro" for user with read-only privileges and "ptrw" for user with read-write privileges. You can change the usernames used by setting the below attributes:
```ruby
node.set["percona_tools"]["read_only_user"]["username"] = "some_other_read_only_username"
node.set["percona_tools"]["read_write_user"]["username"] = "some_other_read_write_username"
```

If data bags are not being used to store the passwords for the users then the following attribute must store the "root" user password:
```ruby
node.set["mysql"]["root_password"] = "changeme"
```

And the following attribute must store the passwords for the two additional users used by percona-toolkit:
```ruby
node.set["percona_tools"]["read_only_user"]["password"] = "changeme"
node.set["percona_tools"]["read_write_user"]["password"] = "changeme"
```

If you do not set the password then they are randomly generated using OpenSSL and stored in the attributes mentioned above.


#### Using encrypted data bag for storing MySQL credentials
It is recommended though to store the user passwords in encrypted data bag.
If encrypted data bag is being used then the following attribute must be set:
```ruby
node.set["percona_tools"]["use_encrypted_databag"] = true
node.set["percona_tools"]["databag_name"] = "passwords"
node.set["percona_tools"]["databag_item"] = "mysql_users"
```

The above assumes that a data bag was created as follows:
```
knife data bag create passwords mysql_users --secret-file /path/to/databag_encryption_key
```

An example data bag item json is shown below:
```json
{
    "id": "mysql_users",
    "root": "some_secure_password",
    "ptro": "another_secure_password",
    "ptrw": "yet_another_secure_password"
}
```

The above example assumes that the default users "ptro" and "ptrw" are being used.


Attributes
----------
The following attributes are set by default:
```ruby
default["percona_tools"]["yum"]["description"] = "CentOS $releasever - Percona"
default["percona_tools"]["yum"]["baseurl"] = "http://repo.percona.com/centos/$releasever/os/$basearch/"
default["percona_tools"]["yum"]["gpgkey"] = "http://www.percona.com/downloads/RPM-GPG-KEY-percona"
default["percona_tools"]["yum"]["gpgcheck"] = true
default["percona_tools"]["xtrabackup"]["version"] = "2.2.5-5027"
default["percona_tools"]["toolkit"]["version"] = "2.2.11-1"
default["percona_tools"]["read_only_user"] = {
    "username" => "ptro",
    "allowed_hosts" => ["%", "#{node['fqdn']}", "localhost"]
}
default["percona_tools"]["read_write_user"] = {
    "username" => "ptrw",
    "allowed_hosts" => ["%", "#{node['fqdn']}", "localhost"]
}
default["percona_tools"]["use_encrypted_databag"] = false
default["percona_tools"]["databag_name"] = "passwords"
default["percona_tools"]["databag_item"] = "mysql_users"
```

The other attribute that is needed and not set by default is:
```ruby
node["mysql"]["socket"]
```

Contributing
------------
1. Fork the repository https://github.com/ovaistariq/chef-cookbooks.git on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License & Authors
-----------------
- Author: Ovais Tariq (<me@ovaistariq.net>)

```text
(c) 2014, Ovais Tariq <me@ovaistariq.net>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```
