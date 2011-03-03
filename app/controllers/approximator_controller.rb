begin
  require 'active_rdf'
rescue Exception
  print "This sample needs activerdf and activerdf_jena.\n"
end

require 'pbuilder/adapter'
require 'pbuilder/maps_analyzer'

class ApproximatorController < ApplicationController
  layout 'main'
  
  def index
    Pbuilder::Adapter.purge(session[:user_id])
  end
  
  def load
    aeria_adapter = Pbuilder::Adapter.new(session[:user_id],
                                          path_to_url(AERIA_PATH),
                                          PERSISTENT_AERIA)
    maps = Pbuilder::MapsAnalyzer.new({ :report         =>  true,
                                        :id             =>  session[:user_id] ,
                                        :patterns_file  =>  PATTERNS_FILE,
                                        :analysis_file  =>  ANALYSIS_FILE,
                                        :mappings_file  =>  MAPPINGS_FILE} )
    @root_concepts_list = maps.root_concepts_list
    @finders = maps.finders              
    aeria_adapter.close
    @notice = "Ontologies loaded"
  end

end
