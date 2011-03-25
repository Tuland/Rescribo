begin
  require 'active_rdf'
rescue Exception
  print "This sample needs activerdf and activerdf_jena.\n"
end

require 'pbuilder/adapter'
require 'pbuilder/maps_analyzer'
require 'pbuilder/yaml_reader'

class RewriterController < ApplicationController
  layout 'main'
  
  def index
    Pbuilder::Adapter.purge(session[:user_id])
  end
  
  def load
    aeria_adapter = Pbuilder::Adapter.new(session[:user_id],
                                          path_to_url(AERIA_PATH),
                                          PERSISTENT_AERIA)
    begin
      maps = Pbuilder::MapsAnalyzer.new({ :report         =>  true,
                                          :id             =>  session[:user_id] ,
                                          :patterns_file  =>  PATTERNS_FILE,
                                          :analysis_file  =>  ANALYSIS_FILE,
                                          :mappings_file  =>  MAPPINGS_FILE} )
      @root_concepts_list = maps.root_concepts_list
      @finders = maps.finders
    rescue Exception => e
      puts e.message  
      puts e.backtrace.inspect
    ensure 
      aeria_adapter.close
    end              
    
    @notice = "Ontologies loaded"
    
    @abstract_concepts = maps.mappings.keys.sort
    
  end
  
  def rewrite
    reader = Pbuilder::YamlReader.new(session[:user_id],
                                      MAPPINGS_FILE,
                                      PATTERNS_FILE,
                                      ANALYSIS_FILE)
    a_concept = params[:settings][:a_concept]
    patterns, analysis = reader.load(a_concept)
    core_concept_node = patterns[a_concept].root
    @patterns = core_concept_node.build_patterns
    @analysis = analysis[a_concept]

    Pbuilder::Adapter.purge(session[:user_id])
    onto_adapter = Pbuilder::Adapter.new( session[:user_id],
                                          path_to_url(ONTO_PATH),
                                          PERSISTENT_ONTO)
    @core_instances = []
    begin
      @core_concept = core_concept_node.value
      core_concept_rsc = RDFS::Resource.new(@core_concept)
      query = Query.new.distinct(:i).where(:i, RDF::type , core_concept_rsc)
      query.execute do |instance|
        @core_instances << instance
      end
    rescue Exception => e
      puts e.message  
      puts e.backtrace.inspect
    ensure 
      onto_adapter.close 
    end

  end

end
