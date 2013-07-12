class AddNickToUsers < ActiveRecord::Migration
  def up
    add_column :users, :nick, :string, null: false, default: ""

    User.reset_column_information
    User.all.each do |u|
      u.nick = u.email.partition('@')[0]
      u.save! validate: false
    end
    change_column_default :users, :nick, nil

    # FIXME: is index case insensitive?
    add_index :users, :nick, unique: true
  end

  def down
    remove_index :users, :nick
    remove_column :users, :nick
  end
end
