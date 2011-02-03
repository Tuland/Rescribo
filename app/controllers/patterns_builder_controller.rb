begin
require 'active_rdf'
rescue Exception
print "This sample needs activerdf and activerdf_jena.\n"
end

require 'fileutils'


class PatternsBuilderController < ApplicationController
  layout 'main'
  
  before_filter :authorize, :except => [ :load ]
  
  SKOS = "http://www.w3.org/2004/02/skos/core#"
  AERIA = "http://www.siti.disco.unimib.it/cmm/2010/aeria#"
  
  def index
    FileUtils.rm_rf(PERSISTENCE_DIR + session[:user_id].to_s)
    puts path_to_url(AERIA_PATH)
  end
  
  def load  
    adapter = load_adapter
    init_adapter
    @url_str = "URL: " + path_to_url(AERIA_PATH)
    s_engine = SearchEngine.new
    @abstract_concept, @core_concept = s_engine.find_root_concepts
    @analysis = PatternsAnalysis.new(@core_concept)
    @patterns = PatternsStorage.new(@core_concept) 
    step_count = 0
    #puts_report(step_count, @patterns_analysis)
    while ! @analysis.concepts_list.empty?
      s_engine.find_neighbours( @analysis.concepts_list.first, 
                                @analysis,
                                @patterns)
      step_count = step_count.next 
      #puts_report(step_count, @patterns_analysis)
      #puts_patterns(step_count, @patterns_list)
      @analysis.concepts_list.shift
    end
    adapter.close
  end
  
  private
  
  def load_adapter
    FileUtils.mkdir(PERSISTENCE_DIR + session[:user_id].to_s)
    adapter = ConnectionPool.add_data_source( :type => :jena, 
                                              :model => PERSISTENT_AERIA,
                                              :file => PERSISTENCE_DIR + session[:user_id].to_s )
    adapter.enabled = true
    adapter.load( path_to_url(AERIA_PATH), 
                  :format => :rdfxml, 
                  :into => :default_model )
    return adapter
  end
  
  def init_adapter
    Namespace.register :skos, SKOS
    Namespace.register :aeria, AERIA
    ObjectManager.construct_classes
  end
  
end
