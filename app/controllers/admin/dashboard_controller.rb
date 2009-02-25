class Admin::DashboardController < ApplicationController

  only_allow_access_to :index,
    :when => :admin,
    :denied_url => {:controller => 'welcome', :action => 'logout'},
    :denied_message => 'You must have administrative privileges to perform this action.'

  def index
    @informations = {}
    @informations["publish_page"] = Page.count(:conditions => "status_id = 100")
    @informations["draft_page"] = Page.count(:conditions => "status_id = 1")
    @informations["group_number"] = Group.count
    @informations["user_number"] = User.count
    
    @recently_updated = Page.find(:all, :order => "updated_at DESC", :limit => 10)
  end
end
