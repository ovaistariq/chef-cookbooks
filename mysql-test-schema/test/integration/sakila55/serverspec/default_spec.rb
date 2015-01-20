require 'serverspec'

# Required by serverspec
set :backend, :exec

puts "os: #{os}"

def mysql_bin
  return "/usr/bin/mysql -uroot -proot -S/var/run/mysql-default/mysqld.sock" if os[:family] == 'redhat'
  return "/usr/bin/mysql -uroot -proot -S/run/mysql-default/mysqld.sock" if ['debian', 'ubuntu'].include?(os[:family])
  "/usr/bin/mysql"
end

describe "'sakila' database exists" do
  describe command(
    "#{mysql_bin} -NB -e \"show databases like 'sakila'\""
  ) do
    its(:stdout) { should match /sakila/ }
  end
end

describe "select from sakila.film table" do
  describe command(
    "#{mysql_bin} -NB -e \"select * from film order by film_id limit 10\" sakila"
  ) do
    its(:stdout) { should match /ACADEMY DINOSAUR/ }
  end
end
