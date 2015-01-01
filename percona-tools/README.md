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
- Author: Ovais Tariq (<ovaistariq@gmail.com>)

```text
All rights reserved
```
