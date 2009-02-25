class AddGroupsAndMenus < ActiveRecord::Migration
  def self.up
    # Create developer group (backend)
    developer_group = Group.new(
      :name => "Developer", :key => "developer", :description => "Website developers and integrators.",
      :admin => true, :deletable => false)
    developer_group.save
    
    # Create administrator group (backend)
    administrator_group = Group.new(
      :name => "Administrator", :key => "administrator", :description => "Main administrators group.",
      :admin => true, :deletable => false)
    administrator_group.save
    
    # Create user group (frontend)
    user_group = Group.new(
      :name => "User", :key => "user", :description => "Front users (no backend access).",
      :admin => true, :deletable => false)
    user_group.save

    # This is the default group id for each user. By default when a user is
    # created or removed from a group, his new group is "user".
    Radiant::Config['default_group_id'] = '3'
    
    # Create the 'pages' menu
    pages_menus = Menu.new(
      :name => "Pages", :description => "Main content access (pages)" , :url => "/admin/pages",
      :position => nil, :dynamic => 1, :parent_id => nil 
    )
    pages_menus.save
    
    # Create the 'design' menu and 'Layouts'/'Snippets' submenus
    design_menus = Menu.new(
      :name => "Design", :description => "Design access (layouts and snippets)" , :url => "",
      :position => nil, :dynamic => 1, :parent_id => nil 
    )
    design_menus.save
    
    layouts_menus = Menu.new(
      :name => "Layouts", :description => "" , :url => "/admin/layouts",
      :position => 1, :dynamic => 1, :parent_id => "#{design_menus.id}"
    )
    layouts_menus.save
    
    snippets_menus = Menu.new(
      :name => "Snippets", :description => "" , :url => "/admin/snippets",
      :position => 2, :dynamic => 1, :parent_id => "#{design_menus.id}"
    )
    snippets_menus.save
    
    # Create the 'permissions' menu and 'Groups'/'Menus'/'Users' submenus
    permissions_menus = Menu.new(
      :name => "Permissions", :description => "Main permissions access (groups, menu and users)" , :url => "",
      :position => nil, :dynamic => 1, :parent_id => nil 
    )
    permissions_menus.save
    
    groups_menus = Menu.new(
      :name => "Groups", :description => "" , :url => "/admin/groups",
      :position => 1, :dynamic => 1, :parent_id => "#{permissions_menus.id}"
    )
    groups_menus.save
    
    menu_builder_menus = Menu.new(
      :name => "Menus", :description => "" , :url => "/admin/menu_builder",
      :position => 2, :dynamic => 1, :parent_id => "#{permissions_menus.id}"
    )
    menu_builder_menus.save
    
    users_menus = Menu.new(
      :name => "Users", :description => "" , :url => "/admin/users",
      :position => 3, :dynamic => 1, :parent_id => "#{permissions_menus.id}"
    )
    users_menus.save
    
    # Add a link between some menus and default developer group
    developer_group.menus << pages_menus
    developer_group.menus << design_menus
    developer_group.menus << permissions_menus
    developer_group.save

    # Add a link between some menus and default admin group
    administrator_group.menus << pages_menus
    administrator_group.menus << design_menus
    administrator_group.save

    # Add a link between developer group and first user
    user = User.find(:first)
    user.groups << developer_group
    user.save

    # Update user state (enable all users)
    User.update_all "enable = 1"
  end

  def self.down
  
  end
end
