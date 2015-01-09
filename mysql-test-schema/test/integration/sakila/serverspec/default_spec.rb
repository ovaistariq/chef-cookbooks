require 'serverspec'

# Required by serverspec
set :backend, :exec

describe "'sakila' database exists" do
  describe command(
    "/usr/bin/mysql -NB -e \"show databases like 'sakila'\""
  ) do
    its(:stdout) { should match /sakila/ }
  end
end

describe "select from sakila.film table" do
  describe command(
    "/usr/bin/mysql -NB -e \"select * from film order by film_id limit 10\" sakila"
  ) do
    its(:stdout) { should match /ACADEMY DINOSAUR/ }
  end
end
