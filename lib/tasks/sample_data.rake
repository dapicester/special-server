namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end
end

# Create 1 admin user and 99 users.
def make_users
  admin = User.create!(name:     "Example User",
                       email:    "example@example.com",
                       password: "foobar",
                       password_confirmation: "foobar")
  admin.toggle!(:admin)
  99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@example.com"
    password = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

# Create 50 posts for the first 6 users.
def make_microposts
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each do |user|
      user.microposts.create!(content: content)
    end
  end
end

# Let the first user follow some users and be followed by other users.
def make_relationships
  users = User.all
  user = users.first
  followed_users = users[1..50]
  followers       = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end
