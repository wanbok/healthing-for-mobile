class SessionsController < ApplicationController
	def new
    respond_to do |format|
      format.html # new.html.erb
    end
	end

  def create
    session[:password] = params[:password]
    if admin?
    	flash[:notice] = "Successfully logged in"
    	redirect_to hospitals_path
    else
    	flash[:notice] = "Failed to login"
    	redirect_to root_path
    end
  end
  
  def destroy
    reset_session
    flash[:notice] = "Successfully logged out"
    redirect_to root_path
  end
end