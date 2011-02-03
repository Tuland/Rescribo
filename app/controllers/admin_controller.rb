class AdminController < ApplicationController
  layout 'main'
  
  before_filter :authorize, :except => :login
  
  
  def index
    redirect_to :controller => "admin", :action => "login"
  end
  
  def login
    if request.post? 
      user = User.authenticate(params[:name], params[:password]) 
      if user 
        session[:user_id] = user.id
        uri = session[:original_uri] 
        session[:original_uri] = nil 
        redirect_to(uri || {  :controller => "guide", 
                              :action => "index" })
      else 
        flash.now[:notice] = "Invalid user/password combination" 
      end 
    end
  end
  
  def logout 
    session[:user_id] = nil 
    flash[:notice] = "Logged out" 
    redirect_to :controller => "admin", :action => "login" 
  end 
  
  
  
end
