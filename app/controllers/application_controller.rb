class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter do
    if request.ssl? && Rails.env.production?
      unless action_name=="match_from_url"
        redirect_to :protocol => 'http://', :status => :moved_permanently
      end
    end
  end

end
