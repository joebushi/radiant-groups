class Menu < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :groups, :uniq => true
  acts_as_tree :order => "position ASC"
  belongs_to :menu

  # Validations
  validates_presence_of :name, :message => "name is required"
end
