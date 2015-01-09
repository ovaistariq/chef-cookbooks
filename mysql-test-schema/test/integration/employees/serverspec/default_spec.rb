require 'serverspec'

# Required by serverspec
set :backend, :exec

describe "'employees' database exists" do
  describe command(
    "/usr/bin/mysql -NB -e \"show databases like 'employees'\""
  ) do
    its(:stdout) { should match /employees/ }
  end
end

describe "select from employees.employees table" do
  describe command(
    "/usr/bin/mysql -NB -e \"select * from employees order by emp_no limit 10\" employees"
  ) do
    its(:stdout) { should match /Anneke/ }
  end
end
