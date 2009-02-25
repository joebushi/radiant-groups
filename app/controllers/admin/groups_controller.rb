class Admin::GroupsController < ApplicationController
 
  only_allow_access_to :index, :new, :edit, :remove, :add_user, :remove_user, :add_menu, :remove_menu,
    :when => [ :admin ],
    :denied_url => {:controller => 'dashboard', :action => 'index'},
    :denied_message => 'You must have administrative privileges to perform this action.'
    
  def index
    @groups = Group.find(:all)
  end
  
  def new
    if request.post?
  	  @group = Group.new(params[:group])
      
  	  if @group.save
  	    flash[:notice] = 'The group has been created.'
        
      else
        flash[:error] = @group.errors.full_messages.join("<br />")
  	  end
  	end
    
    redirect_to group_index_url
  end
  
  def edit
    @group = Group.find(params[:id])
    
    if request.post?
      # Update current group
      unless params[:group].nil?
        @group.update_attributes(params[:group])
        if @group.save
          flash[:notice] = 'The group has been updated.'
        else
          flash[:error] = @group.errors.full_messages.join("<br />")
        end 
      end   
    end
  end
  
  def remove
    unless params[:id].nil?
      # Recover group 
      group = Group.find(params[:id])
      
      # Remove current group
      group.destroy
      
      flash[:notice] = 'The group has been removed.'
    end
    
    redirect_to group_index_url
  end
 
  def add_user
    if request.post?
      group = Group.find(params[:id])
      user = User.find(params[:groups_users][:user_id])

      group.users << user
      group.save
      
      flash[:notice] = "#{user.name} added to #{group.name}."
    end
  rescue ::ActiveRecord::RecordNotFound
    if group.nil?
      flash[:error] = "Group not found for that id."
    elsif user.nil?
      flash[:error] = "Please select a user (#{params[:user_id]}) to add to #{group.name}."
    end
  ensure
    redirect_to group_edit_url(:id => params[:id])
  end   
  
  def remove_user
    group = Group.find(params[:id])
    user = User.find(params[:user_id])
    
    group.users.delete(user)
    group.save
    flash[:notice] = "#{user.name} removed from #{group.name}."
  rescue
    if group.nil?
      flash[:error] = "Group not found for that group id."
    elsif user.nil?
      flash[:error] = "User not found for that user id."
    end
  ensure
    redirect_to group_edit_url(:id => params[:id])
  end  
  
  def add_menu
    if request.post?
      group = Group.find(params[:id])
      menu = Menu.find(params[:groups_menus][:menu_id])

      group.menus << menu
      group.save
      
      flash[:notice] = "#{menu.name} added to #{group.name}."
    end
  rescue ::ActiveRecord::RecordNotFound
    if group.nil?
      flash[:error] = "Group not found for that id."
    elsif menu.nil?
      flash[:error] = "Please select a menu (#{params[:menu_id]}) to add to #{group.name}."
    end
  ensure
    redirect_to group_edit_url(:id => params[:id])
  end   
  
  def remove_menu
    group = Group.find(params[:id])
    menu = Menu.find(params[:menu_id])
    
    group.menus.delete(menu)
    group.save
    flash[:notice] = "#{menu.name} removed from #{group.name}."
  rescue
    if group.nil?
      flash[:error] = "Group not found for that group id."
    elsif menu.nil?
      flash[:error] = "Menu not found for that user id."
    end
  ensure
    redirect_to group_edit_url(:id => params[:id])
  end  
end