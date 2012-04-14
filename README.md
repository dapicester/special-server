== Special

This is the server of the Special Social Network.

-- Development

After cloning the repository, run
$ bundle install 
Use the following options:
--binstubs=./bundlerstubs
  set the binstubs directory, used when enabling RVM hooks)
-- without [group]
  disables one or more groups (see the Gemfile)

Create the database:
$ rake db:migrate
$ rake db:test:prepare
