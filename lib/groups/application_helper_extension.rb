module Groups::ApplicationHelperExtension
  def self.included(base)
    
    base.class_eval do
      def match_current_url?(url)
        if url != ''
          reg = Regexp.new(url)  
          reg.match("#{request.request_uri}") ? true : false
        else
          false
        end
      end
      
      alias_method_chain :admin?, :groups
      alias_method_chain :developer?, :groups
      alias_method_chain :links_for_navigation, :groups
    end
  end
  
  def admin_with_groups?
    current_group.nil? ? false : current_group.admin?
  end
  
  def developer_with_groups?
    admin_with_groups?
  end
  
  def links_for_navigation_with_groups
    has_menu = false
    
    unless @current_user.groups.empty?
      @current_user.groups.each do |group|
        unless group.menus.empty?
          has_menu = true
        end
      end
    end
    
    unless has_menu
      #if the user hasn't got any menu then we don't display anything. 
      #links_for_navigation_without_groups
    else
      menus = @current_user.groups.first.menus
      html = '<ul id="main-menu">'

      menus.each do |menu|
        is_current_page = false
      
        # Display sub menus
        sub_html = ''
        sub_html += '<ul>'
        menu.children.each do |submenu|
          is_current_page = self.match_current_url?(submenu.url) ? true : is_current_page
          sub_html += '<li>'
          sub_html += self.match_current_url?(submenu.url) ? '<strong>' : ''
          sub_html += link_to(submenu.name, submenu.url.empty? ? '#' : submenu.url)
          sub_html += self.match_current_url?(submenu.url) ? '</strong>' : ''
          sub_html += '</li>'
        end
        sub_html += '</ul>'
        
        # Display tab
        is_current_page = self.match_current_url?(menu.url) ? true : is_current_page
        
        html += '<li>'
        html += is_current_page ? '<strong>' : ''
        html += link_to(menu.name, menu.url.empty? ? '#' : menu.url)
        html += is_current_page ? '</strong>' : ''
        html += sub_html
        html += '</li>'
      end #End each menu
      
      html + '</ul>'
    end
  end
end