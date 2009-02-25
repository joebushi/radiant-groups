class CreateMenus < ActiveRecord::Migration
  def self.up
    create_table :menus do |t|
      t.string  :name
      t.string  :description
      t.string  :url
      t.integer :position
      t.boolean :dynamic, :default => false
      t.integer :parent_id
      t.timestamps
    end
  end

  def self.down
    drop_table :menus
  end
end
