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
    
    @finder = Pbuilder::OfflineFinder.new(@core_concept, Pbuilder::PatternsTree)
    @finder.start({ :id             =>  session[:user_id],
                    :report         =>  true,
                    :patterns_file  =>  PATTERNS_FILE,
                    :analysis_file  =>  ANALYSIS_FILE,
                    :report_view    =>  ""} )
    adapter.close
  end
  
end
