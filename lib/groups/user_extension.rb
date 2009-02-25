module Groups::UserExtension
  def self.included(base)
    base.class_eval do
      # Associations
      has_and_belongs_to_many :groups, :uniq => true
    end
  end
end