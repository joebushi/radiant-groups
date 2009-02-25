class Admin::MenusController < ApplicationController

  only_allow_access_to :index, :remove, :edit, :add_menu, :add_submenu, :remove_submenu, :move_up_submenu, :move_down_submenu,
    :when => :admin,
    :denied_url => {:controller => 'dashboard', :action => 'index'},
    :denied_message => 'You must have administrative privileges to perform this action.'
   
  def index
    @parent_menus = Menu.find(:all, :conditions => "parent_id is NULL")
  end
  
  def remove    
    Menu.destroy_all(:parent_id => params[:id])
    Menu.destroy(params[:id])
    
    respond_to do |format|
      format.html{redirect_to index_menu_path}
    end
  end
  
  def edit
    @parent_menu = Menu.find(params[:id])
    @submenus = Menu.find(:all, :conditions => { :parent_id => @parent_menu.id }, :order => :position )
  end
  
  def add_menu
    if params[:extension] != ''
      Radiant::Extension.admin.tabs.each do |tab|
        if tab.url == params[:extension]
          menu = Menu.new
          menu.name = tab.name
          menu.url = tab.url
          menu.description = params[:description]
          menu.dynamic = true
          menu.save
        end #End tab.name == params[:extension]
      end #End each do |tab|
    elsif (params[:name] != '')
      menu = Menu.new
      menu.name = params[:name]
      menu.url = params[:url]
      menu.description = params[:description]
      menu.save
    end #End params['existing_extension'] == 'true'
    redirect_to :back
  end
  
  def add_submenu
    position = Menu.maximum('position', :conditions => ["parent_id = ?", params[:id]])
    if position.nil?
      position = 0
    end
    
    if params[:extension] != ''
      Radiant::Extension.admin.tabs.each do |tab|
        if tab.url == params[:extension]
          submenu = Menu.new
          submenu.name = tab.name
          submenu.url = tab.url
          submenu.description = params[:description]
          submenu.dynamic = true
          submenu.parent_id = params[:id]
          submenu.position = position + 1
          submenu.save
        end #End tab.name == params[:extension]
      end #End each do |tab|
    
    elsif (params[:name] != "") && (params[:url] != "")
      submenu = Menu.new
      submenu.name = params[:name]
      submenu.url = params[:url]
      submenu.description = params[:description]
      submenu.parent_id = params[:id]
      submenu.position = position + 1
      submenu.save
      
    end #End params['existing_extension'] == 'true'
    redirect_to :back
  end
  
  def remove_submenu
    submenu = Menu.find(params[:id])
    tab_submenu = Menu.find(:all, :conditions => ["parent_id = ? AND position > ?", submenu.parent_id, submenu.position])
    tab_submenu.each do |menu|
      Menu.update_counters(menu.id, :position => -1)
    end
    
    submenu.destroy
    
    redirect_to edit_menu_path(:id => submenu.parent_id)
  end 
  
  def move_up_submenu
    submenu = Menu.find(params[:id])
    tab_submenu = Menu.find(:first, :conditions => ["parent_id = ? AND position = ?", submenu.parent_id, submenu.position - 1])
    
    if tab_submenu
      submenu.position -= 1
      submenu.save
      tab_submenu.position += 1
      tab_submenu.save
      
      flash[:notice] = 'Menu has been moved.'
    end
    
    redirect_to edit_menu_path(:id => submenu.parent_id)
  end 
  
  def move_down_submenu
    submenu = Menu.find(params[:id])
    tab_submenu = Menu.find(:first, :conditions => ["parent_id = ? AND position = ?", submenu.parent_id, submenu.position + 1])
    
    if tab_submenu
      submenu.position += 1
      submenu.save
      tab_submenu.position -= 1
      tab_submenu.save
      
      flash[:notice] = 'Menu has been moved.'
    end
    
    redirect_to edit_menu_path(:id => submenu.parent_id)
  end
end
