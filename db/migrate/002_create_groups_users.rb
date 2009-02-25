class CreateGroupsUsers < ActiveRecord::Migration
  def self.up
    create_table :groups_users, :id => false, :force => true do |t|
      t.integer :group_id, :limit => 11
      t.integer :user_id, :limit => 11
    end
    
    add_index :groups_users, :group_id
    add_index :groups_users, :user_id
    
    # Add an state column
    add_column :users, :enable, :boolean, :default => false
  end
  
  def self.down
    remove_column :users, :enable
    drop_table :groups_users
  end
end