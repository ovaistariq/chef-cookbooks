users_sshkeys Cookbook
======================
Setup SSH keys for users from encrypted databag search.


Requirements
------------
### Platforms
- Debian, Ubuntu
- CentOS, Red Hat, Fedora
- FreeBSD

A data bag populated with user objects must exist. The default data
bag in this recipe is `users`. See USAGE.


Usage
-----
To include just the LWRPs in your cookbook, use:

```ruby
include_recipe "users_sshkeys"
```

Use knife to create an encrypted data bag named 'users_sshkeys'

```bash
$ knife data bag create users_sshkeys username --secret-file /path/to/databag/encryption/key
```

Note: The ssh_keys attribute below can be either a String or an Array. However, Array is recommended.

```javascript
{
  "id": "username",
  "ssh_keys": "ssh-rsa AAAAB3Nz...yhCw== username",
}
```

```javascript
{
  "id": "username",
  "ssh_keys": [
    "ssh-rsa AAA123...xyz== foo",
    "ssh-rsa AAA456...uvw== bar"
  ],
  "ssh_private_key": "+-----BEGIN RSA PRIVATE KEY-----\nXAAddaQYq...\n-----END RSA PRIVATE KEY-----"
}
```

Note this LWRP searches the `users_sshkeys` and for every item in the data bag decrypts the item and sets up the SSH keys. The default action for the LWRP is `:create` only.

If you have different requirements, for example:

 * You want to search a different data bag specific to a role such as
   mail. You may change the data_bag searched.
   - data_bag `mail`

Putting these requirements together our recipe might look like this:

```ruby
users_sshkeys_manage "postmaster" do
  data_bag "mail"
  action :create
end
```

Chef Solo
---------
This cookbook might work with Chef Solo when using [chef-solo-search by edelight](https://github.com/edelight/chef-solo-search).


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
