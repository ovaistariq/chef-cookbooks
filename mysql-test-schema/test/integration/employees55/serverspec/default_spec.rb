require 'serverspec'

# Required by serverspec
set :backend, :exec

puts "os: #{os}"

def mysql_bin
  return "/usr/bin/mysql -uroot -proot -S/var/run/mysql-default/mysqld.sock" if os[:family] == 'redhat'
  return "/usr/bin/mysql -uroot -proot -S/run/mysql-default/mysqld.sock" if ['debian', 'ubuntu'].include?(os[:family])
  "/usr/bin/mysql"
end

describe "'employees' database exists" do
  describe command(
    "#{mysql_bin} -NB -e \"show databases like 'employees'\""
  ) do
    its(:stdout) { should match /employees/ }
  end
end

describe "select from employees.employees table" do
  describe command(
    "#{mysql_bin} -NB -e \"select * from employees order by emp_no limit 10\" employees"
  ) do
    its(:stdout) { should match /Anneke/ }
  end
end
