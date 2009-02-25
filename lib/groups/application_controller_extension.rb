module Groups::ApplicationControllerExtension
  def self.included(base)
    base.class_eval do
      alias_method_chain :set_javascripts_and_stylesheets, :groups
      alias_method_chain :user_has_role?, :groups
      alias_method_chain :authenticate, :groups
    end

    base.send :helper_method, :current_group
    base.send :helper_method, :current_groups
  end
  
  # Returns the first group of the current user
  def current_group
    group = current_user.groups.first
    group
  end

  # Returns all the groups of the current user
  def current_groups
    groups = current_user.groups
    groups
  end
    
  private
    def user_has_role_with_groups?(role)
      url = request.request_uri
      
      # Backend access (check current user is backend user)
      unless Regexp.new('/admin/').match(url).nil?
        has_right = false

        # Give only access to dashboard, preferences and logout pages
        has_right = Regexp.new('/admin/preferences').match(url).nil? ? has_right : true
        has_right = Regexp.new('/admin/logout').match(url).nil? ? has_right : true
        has_right = Regexp.new('/admin/dashboard').match(url).nil? ? has_right : true

        # Scanning the user's menus to see if he has the right to see this page or not
        (current_group && current_group.menus || []).each do |menu|
          unless menu.url.empty?
            has_right = Regexp.new(menu.url).match(url).nil? ? has_right : true
          end
          menu.children.each do |submenu|
            unless submenu.url.empty?
              has_right = Regexp.new(submenu.url).match(url).nil? ? has_right : true
            end
          end
        end

        has_right
      # Frontend user (everything else)
      else
        allowed_group = Group.find_by_key(role.to_s)
        current_group.id == allowed_group.id ? true : false
      end
    end
    
    def set_javascripts_and_stylesheets_with_groups
      set_javascripts_and_stylesheets_without_groups

      # Include new CSS
      ['groups/menu', 'groups/dashboard'].each do |file|
        @stylesheets << file
       end
    end

    def authenticate_with_groups
      unless Regexp.new('/admin/').match(request.request_uri).nil?
        authenticate_without_groups
      else
        allow_access = false

        if no_login_required?
          allow_access = true
        else
          action = params['action'].to_s.intern
          unless current_user.nil?
            allow_access = user_has_access_to_action?(action) ? true : allow_access
          end
        end

        redirect_to '/members/login' unless allow_access
      end
    end
end
