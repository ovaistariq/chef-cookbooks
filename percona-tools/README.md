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

Cookbook Dependencies
---------------------
- yum

Usage
-----
Place a dependency on the percona-tools cookbook in your cookbook's  metadata.rb

```
depends "percona-tools", "~> 0.5"
```

Then, in a recipe:

```
include_recipe "percona-tools"
```

Attributes
----------
In order to keep the README managable and in sync with the attributes, this cookbook documents attributes inline. The usage instructions and default values for attributes can be found in the individual attribute files.

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
