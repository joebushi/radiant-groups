class GroupsUsers < ActiveRecord::Base
  # Validations
  validates_uniqueness_of :user_id, :scope => [ :group_id ], :message => 'is already in group'
  validates_presence_of :users_id, :group_id, :message => 'is required'
end