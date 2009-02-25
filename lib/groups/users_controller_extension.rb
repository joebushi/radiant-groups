module Groups::UsersControllerExtension
  def self.included(base)
    base.class_eval do
      only_allow_access_to :index, :new, :edit, :remove, :preferences,
        :when => :admin,
        :denied_url => {:controller => 'dashboard', :action => :index},
        :denied_message => 'You must have administrative privileges to perform this action.'
      
      alias_method_chain :index,  :groups
      alias_method_chain :remove, :groups
    end
  end
  
  def index_with_groups
    @users = User.find(:all)
  end
  
  def remove_with_groups
    if current_user.id.to_s != params[:id].to_s
      disable
    end
  end
  
  # Enable an user
  def enable
    if current_user.id.to_s != params[:id].to_s
      user = User.find(params[:id])
      user.enable = true

      if user.save
        flash[:notice] = 'User has been successfully enabled.'
      else
        flash[:notice] = 'User error.'
      end
    end

    redirect_to user_index_url
  end
  
  # Disable an user
  def disable
    if current_user.id.to_s != params[:id].to_s
      user = User.find(params[:id])
      user.enable = false

      if user.save
        flash[:notice] = 'User has been successfully disabled.'
      else
        flash[:notice] = 'User error.'
      end
    end
    
    redirect_to user_index_url
  end
end