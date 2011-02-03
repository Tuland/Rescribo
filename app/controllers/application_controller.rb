# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  PERSISTENCE_DIR = "jena_persistence"
  
  PERSISTENT_ONTO = "onto"
  PERSISTENT_AERIA = "aeria"
  
  ONTO_PATH = OntoUploaded::PUBLIC_ADDRESS
  AERIA_PATH =  AeriaUploaded::PUBLIC_ADDRESS
  
  def path_to_url(path)
    "http://#{request.host_with_port}/#{path.sub(%r[^/],'')}"
  end
  
  protected 
  
  def authorize 
    unless User.find_by_id(session[:user_id])
      session[:original_uri] = request.request_uri 
      flash[:notice] = "Please log in" 
      redirect_to :controller => 'admin', :action => 'login' 
    end 
  end 

  
end

