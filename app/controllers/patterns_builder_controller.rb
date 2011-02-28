require 'pbuilder/adapter'
require 'pbuilder/maps_analyzer'

class PatternsBuilderController < ApplicationController
  layout 'main'
  
  before_filter :authorize, :except => [ :load ]
  
  def index
    Pbuilder::Adapter.purge(session[:user_id])
  end
  
  def load
    adapter = Pbuilder::Adapter.new(session[:user_id],
                                    path_to_url(AERIA_PATH),
                                    PERSISTENT_AERIA)
    @url_str = "URL: " + path_to_url(AERIA_PATH)
    maps = Pbuilder::MapsAnalyzer.new(PATTERNS_FILE, 
                                      ANALYSIS_FILE, 
                                      MAPPINGS_FILE, 
                                      session[:user_id])
    @root_concepts_list = maps.root_concepts_list
    @finders = maps.finders
    adapter.close
  end
  
end
