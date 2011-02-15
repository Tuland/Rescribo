begin
  require 'active_rdf'
rescue Exception
  print "This sample needs activerdf and activerdf_jena.\n"
end

class ApproximatorController < ApplicationController
  layout 'main'
  
  def index
    Pbuilder::Adapter.purge(session[:user_id])
  end
  
  def load
    aeria_adapter = Pbuilder::Adapter.new(session[:user_id],
                                          path_to_url(AERIA_PATH),
                                          PERSISTENT_AERIA)                                
    @abstract_concept, @core_concept = Pbuilder::SearchEngine.find_root_concepts
    @finder = Pbuilder::OfflineFinder.new(@core_concept)
    @finder.start(session[:user_id],
                  PATTERNS_FILE,
                  ANALYSIS_FILE)
                              
    aeria_adapter.close
   
    @notice = "Ontologies loaded"
    
  end

end
