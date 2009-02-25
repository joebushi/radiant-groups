module Groups::WelcomeControllerExtension
  def self.included(base)
    base.class_eval do
      alias_method_chain :index, :groups
    end
  end

  def index_with_groups
    redirect_to dashboard_url
  end
end