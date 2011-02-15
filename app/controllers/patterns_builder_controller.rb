require 'pbuilder/adapter'
require 'pbuilder/search_engine'
require 'pbuilder/offline_finder'

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
    @abstract_concept, @core_concept = Pbuilder::SearchEngine.find_root_concepts
    
    @finder = Pbuilder::OfflineFinder.new(@core_concept)
    @finder.start(session[:user_id],
                  PATTERNS_FILE,
                  ANALYSIS_FILE)
    
    adapter.close
  end
  
end
