class CreateGroupsMenus < ActiveRecord::Migration
  def self.up
    create_table :groups_menus, :id => false do |t|
      t.integer :group_id
      t.integer :menu_id
    end
    
    add_index :groups_menus, :group_id
    add_index :groups_menus, :menu_id
  end
  
  def self.down
    drop_table :groups_menus
  end
end