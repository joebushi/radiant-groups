require_dependency 'application'

class GroupsExtension < Radiant::Extension
  version "0.1"
  description "Allow you to manage backend restrictions."
  url "http://github.com/vincentp/radiant-groups/tree/master"
  
  define_routes do |map|
    # Groups module
    map.with_options(:controller => 'admin/groups') do |group|
      group.group_index       'admin/groups',                               :action => 'index'
      group.group_new         'admin/groups/new',                           :action => 'new'
      group.group_edit        'admin/groups/edit/:id',                      :action => 'edit'
      group.group_remove      'admin/groups/remove/:id',                    :action => 'remove'
      group.group_add_user    'admin/groups/edit/:id/add_user',             :action => 'add_user'
      group.group_remove_user 'admin/groups/edit/:id/remove_user/:user_id', :action => 'remove_user'
      group.group_add_menu    'admin/groups/edit/:id/add_menu',             :action => 'add_menu'
      group.group_remove_menu 'admin/groups/edit/:id/remove_menu/:menu_id', :action => 'remove_menu'
    end

    # Menus module
    map.with_options(:controller => 'admin/menus') do |m|
      m.index_menu            'admin/menu_builder',                         :action => 'index'
      m.remove_menu           'admin/menu_builder/remove/:id',              :action => 'remove'
      m.edit_menu             'admin/menu_builder/edit/:id',                :action => 'edit'
      m.add_menu              'admin/menu_builder/add_menu',                :action => 'add_menu'
      m.add_submenu           'admin/menu_builder/add_submenu',             :action => 'add_submenu'
      m.remove_submenu        'admin/menu_builder/remove_submenu/:id',      :action => 'remove_submenu'
      m.move_up_submenu       'admin/menu_builder/move_up_submenu/:id',     :action => 'move_up_submenu'
      m.move_down_submenu     'admin/menu_builder/move_down_submenu/:id',   :action => 'move_down_submenu'
    end

    # Map user controller extension routes to change users status
    map.user_disable 'admin/users/disable/:id', :controller => 'admin/users', :action => 'disable'
  	map.user_enable 'admin/users/enable/:id', :controller => 'admin/users',   :action => 'enable'

    # Dashboard
    map.dashboard 'admin/dashboard', :controller => 'admin/dashboard', :action => 'index'
  end
  
  def activate
    # Controllers update
    ApplicationController.send(:include, Groups::ApplicationControllerExtension)
    Admin::WelcomeController.send(:include, Groups::WelcomeControllerExtension)
    Admin::ExtensionsController.send(:include, Groups::ExtensionsControllerExtension)
    Admin::PagesController.send(:include, Groups::PagesControllerExtension)
    Admin::SnippetsController.send(:include, Groups::SnippetsControllerExtension)
    Admin::UsersController.send(:include, Groups::UsersControllerExtension)

    # Models update
    User.send :include, Groups::UserExtension

    # Helpers update
    ApplicationHelper.send(:include, Groups::ApplicationHelperExtension)
    
    # Backend menus
    admin.tabs.add "Groups", "/admin/groups", :visibility => [:all]
    admin.tabs.add "Users", "/admin/users", :visibility => [:all]
    admin.tabs.add "Menus", "/admin/menu_builder", :visibility => [:all]
  end
  
  def deactivate
    admin.tabs.remove "Groups"
    admin.tabs.remove "Menus"
    admin.tabs.remove "Users"
  end
end