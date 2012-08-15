class ApplicationController < ActionController::Base
	helper_method :admin?

  protect_from_forgery

  protected

  def authorize
  	unless admin?
  		flash[:notice] = "Unauthorized access"
  		redirect_to root_path
  		false
  	end
  end

  def admin?
  	session[:password] == "1212qw!@"
	end
end
