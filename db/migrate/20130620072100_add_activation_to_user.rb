class AddActivationToUser < ActiveRecord::Migration
  def change
    add_column :users, :activation_token, :string
    add_column :users, :activation_sent_at, :datetime
    add_column :users, :active, :boolean, default: false
    add_index :users, :activation_token
  end
end
