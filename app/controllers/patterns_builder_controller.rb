require 'pbuilder/adapter'
require 'pbuilder/maps_analyzer'

class PatternsBuilderController < ApplicationController
  layout 'main', :except => [ :load ]
  
  before_filter :authorize
  
  def index
    Pbuilder::Adapter.purge(session[:user_id])
    
    
    
  end
  
  def load
    
   
    files = Dir["#{AERIA_DIRECTORY}/*"]
    
    files.each do |file|
        
      adapter = Pbuilder::Adapter.new(session[:user_id],
                                      path_to_url(file),
                                      PERSISTENT_AERIA)
      begin
        @url_str = "URL: " + path_to_url(AERIA_PATH)
        maps = Pbuilder::MapsAnalyzer.new({ :report         =>  true,
                                            :id             =>  session[:user_id] ,
                                            :patterns_file  =>  PATTERNS_FILE,
                                            :analysis_file  =>  ANALYSIS_FILE,
                                            :mappings_file  =>  MAPPINGS_FILE} )
        @root_concepts_list = maps.root_concepts_list
        @finders = maps.finders
      rescue  Exception => e
        puts e.message
        puts e.backtrace.inspect
      ensure
        adapter.close
      end
    end  

  end
  
end
