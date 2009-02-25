class Group < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :users, :foreign_key => 'group_id', :association_foreign_key => 'user_id', :uniq => true
  has_and_belongs_to_many :menus, :foreign_key => 'menu_id', :association_foreign_key => 'group_id', :uniq => true
  
  # Validations
  validates_presence_of :name, :key, :message => 'is required'
  validates_uniqueness_of :key, :message => 'already in use'

  # Returns the default developer group
  def self.developer_group
    Group.find_by_key("developer")
  end

  # Returns the default administrator group
  def self.administrator_group
    Group.find_by_key("administrator")
  end

  # Returns the default user group
  def self.user_group
    Group.find_by_key("user")
  end
end