# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
    
  ONTO_PATH = UploadedOnto::PUBLIC_ADDRESS
  AERIA_PATH =  UploadedAeria::PUBLIC_ADDRESS
  
  AERIA_DIRECTORY = UploadedAeria::DIRECTORY
  
  # Persistence file related to the user ontology
  PERSISTENT_ONTO = "onto"
  # Persistence file related to the AERIA ontology
  PERSISTENT_AERIA = "aeria"
  PERSISTENCE_DIR = "persistence_onto"
  
  REPORT_DIR = "report/"
  MAPPINGS_FILE = REPORT_DIR + "mappings"
  ANALYSIS_FILE = REPORT_DIR + "analysis"
  PATTERNS_FILE = REPORT_DIR + "patterns"
  
  
  def path_to_url(path)
    "http://#{request.host_with_port}/#{path.sub(%r[^/],'').sub('public/', '')}"
  end
  
  protected 
  
  def authorize 
    unless User.find_by_id(session[:user_id])
      session[:original_uri] = request.request_uri 
      flash[:notice] = "Please log in" 
      redirect_to :controller => 'admin', :action => 'login' 
    end 
  end
  
  def get_db_config
    c = {}
    config   = Rails::Configuration.new
    c[:host]     = config.database_configuration[RAILS_ENV]["host"] || "127.0.0.1"
    c[:database] = config.database_configuration[RAILS_ENV]["database"]
    c[:username] = config.database_configuration[RAILS_ENV]["username"]
    c[:password] = config.database_configuration[RAILS_ENV]["password"]
    c
  end 
 
end

