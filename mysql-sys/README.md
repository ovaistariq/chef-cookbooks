mysql-sys Cookbook
==================
Installs the mysql-sys tool. The tool is a collection of views, functions and procedures to help MySQL administrators get insight into MySQL database usage. 
Detailed description of the tool is available here: https://github.com/MarkLeith/mysql-sys

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
- mysql-chef_gem
- database

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

Or include the default recipe in another cookbook
```ruby
include_recipe "mysql-sys::default"
```

#### MySQL versions supported
MySQL version 5.6 is supported

#### MySQL users used by the cookbook
The cookbook requires the MySQL root user password.

If data bags are not being used to store the passwords for the users then the following attribute must store the "root" user password:
```ruby
node.set["mysql"]["root_password"] = "changeme"
```

#### Using encrypted data bag for storing MySQL credentials
It is recommended though to store the user passwords in encrypted data bag.
If encrypted data bag is being used then the following attribute must be set:
```ruby
node.set["mysql_sys"]["use_encrypted_databag"] = true
node.set["mysql_sys"]["databag_name"] = "passwords"
node.set["mysql_sys"]["databag_item"] = "mysql_users"
```

The above assumes that a data bag was created as follows:
```ruby
knife data bag create passwords mysql_users --secret-file /path/to/databag_encryption_key
```

An example data bag item json is shown below:
```json
{
    "id": "mysql_users",
    "root": "some_secure_password"
}
```

Attributes
----------
The following attributes are set by default:
```ruby
default["mysql_sys"]["version"] = "1.3.0"
default["mysql_sys"]["git_repository"] = "git://github.com/MarkLeith/mysql-sys.git"
default["mysql_sys"]["git_revision"] = "v1.3.0a"
default["mysql_sys"]["use_encrypted_databag"] = false
default["mysql_sys"]["databag_name"] = "passwords"
default["mysql_sys"]["databag_item"] = "mysql_users"
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
