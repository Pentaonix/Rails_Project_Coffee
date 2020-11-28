class ApplicationController < ActionController::Base
  helper_method [:current_user, :is_admin]

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
  end

  def is_admin
    if current_user
      @isAdmin = current_user.role == "Admin"
    else
      @isAdmin = false
    end
  end
end
