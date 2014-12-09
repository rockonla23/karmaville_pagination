class AddIndicesToUsers < ActiveRecord::Migration
  def up
    add_column :users, :total_karma, :integer, :default => 0
    add_column :users, :full_name, :string
    # User.all.each do |user|
    #   user.update_attribute :total_karma, user.update_total_karma
    #   user.update_attribute :full_name, user.create_full_name
    # end
    add_index :users, :total_karma
    add_index :users, :full_name
  end

  def down
    remove_index :users, :total_karma
    remove_index :users, :full_name
    remove_column :users, :total_karma
    remove_column :users, :full_name
  end
end
