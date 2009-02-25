class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string  :name
      t.string  :key
      t.string  :description
      t.boolean :admin,   :default => true
      t.boolean :deletable, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
