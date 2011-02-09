begin
require 'active_rdf'
rescue Exception
print "This sample needs activerdf and activerdf_jena.\n"
end

require 'fileutils'
require 'pbuilder/adapter'
require 'pbuilder/search_engine'
require 'pbuilder/offline_finder'

class PatternsBuilderController < ApplicationController
  layout 'main'
  
  before_filter :authorize, :except => [ :load ]
  
  def index
    Pbuilder::Adapter.purge(session[:user_id])
    puts path_to_url(AERIA_PATH)
  end
  
  def load
    puts session[:user_id]
    adapter = Pbuilder::Adapter.new(session[:user_id],
                                    path_to_url(AERIA_PATH),
                                    PERSISTENT_AERIA)
    @url_str = "URL: " + path_to_url(AERIA_PATH)
    @abstract_concept, @core_concept = Pbuilder::SearchEngine.find_root_concepts
    
    @finder = Pbuilder::OfflineFinder.new(@core_concept)
    @finder.start
    
    adapter.close
  end
  
end
