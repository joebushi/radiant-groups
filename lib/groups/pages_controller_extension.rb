module Groups::PagesControllerExtension
  def self.included(base)
    base.class_eval do
      only_allow_access_to :index, :new, :edit, :remove,
        :when => :admin,
        :denied_url => {:controller => 'dashboard', :action => 'index'},
        :denied_message => 'You must have administrative privileges to perform this action.' 
    end
  end
end