namespace :db do
  namespace :populate do

    desc "Add the admin user"
    task :admin => :environment do
      make_admin
    end

    desc "Fill database with sample data (for testing purposes)"
    task :samples => :environment do
      Rake::Task['db:reset'].invoke
      make_admin
      make_users
      make_microposts
      make_relationships
    end

  end
end

# Create the admin user.
def make_admin
  attributes = {
    name:     "Administrator",
    email:    "admin@example.com",
    nick:     "admin",
    password: "admin123",
    password_confirmation: "admin123"
  }
  admin = User.find_by_email 'admin@example.com'
  unless admin
    puts "Creating the Administrator user ..."
    admin = User.create! attributes
  else
    puts "Updating the Administrator user ..."
    admin.update_attributes! attributes
  end
  admin.toggle!(:admin)
  admin.activate!
  puts "  email:\t#{admin.email}\n  password:\t#{admin.password}"
end

# Create users.
def make_users(num_users = 99)
  puts "Creating #{num_users} users ..."
  num_users.times do |n|
    user = User.create! name:     Faker::Name.name,
                        nick:     Faker::Lorem.words(2).join('_'),
                        email:    "example-#{n+1}@example.com",
                        password: "password",
                        password_confirmation: "password"
    user.activate!
  end
end

# Create microposts for the some users.
def make_microposts(num_microposts = 10, num_users = 5)
  puts "Creating #{num_microposts} microposts for #{num_users} users ..."
  users = User.where(admin: false).limit num_users
  num_microposts.times do
    users.each do |user|
      user.microposts.create! content: Faker::Lorem.sentence
    end
  end
end

# Let the first user follow some users and be followed by other users.
def make_relationships
  users = User.where admin:false
  user = users.first
  puts "Creating relationships for user #{user.name} ..."
  followed_users = users[1..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end
