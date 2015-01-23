name             "users_sshkeys"
maintainer       'Ovais Tariq'
maintainer_email 'me@ovaistariq.net'
license          'All rights reserved'
description      "Creates users from a databag search and install the keys from an encrypted databag"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

recipe           "users_sshkeys", "Empty recipe for including LWRPs"

depends "users"

%w{ ubuntu debian redhat centos fedora freebsd mac_os_x }.each do |os|
  supports os
end
