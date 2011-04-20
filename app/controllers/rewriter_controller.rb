begin
  require 'active_rdf'
rescue Exception
  print "This sample needs activerdf and activerdf_jena.\n"
end

require 'pbuilder/adapter'
require 'pbuilder/maps_analyzer'
require 'pbuilder/yaml_reader'

class RewriterController < ApplicationController
  layout 'main', :except => [ :load, 
                              :rewrite, 
                              :edit_prefix, 
                              :hide_pattern, 
                              :show_pattern ]
  
  before_filter :authorize
  
  UNDEFINED_PREFIX = "[Undefined]"
  
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
    
    @abstract_concepts = maps.mappings.keys.sort
   
    onto_adapter = Pbuilder::Adapter.new( session[:user_id],
                                          path_to_url(ONTO_PATH),
                                          PERSISTENT_ONTO)
    begin
      @prefixes = onto_adapter.prefixes
    rescue Exception => e
      puts e.message  
      puts e.backtrace.inspect
    ensure 
      onto_adapter.close 
    end
    
    @notice = "Ontologies loaded"
    @undefined_prefix = UNDEFINED_PREFIX
          
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
    
    onto_adapter = Pbuilder::Adapter.get_connection(PERSISTENT_ONTO, 
                                                    session[:user_id]) 
    @core_instances = []                                  
    begin
      @core_concept_rsc = RDFS::Resource.new(core_concept_node.value)
      
      query = Query.new.distinct(:i).where(:i, RDF::type , @core_concept_rsc)
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
  
  def edit_prefix
    @e_namespace = params[:namespace]
    @e_value = params[:value]
    @e_editorId = params[:editorId]
    @e_old_prefix = params[:old_prefix]
    
    adapter = Pbuilder::Adapter.get_connection( PERSISTENT_ONTO, 
                                                session[:user_id].to_s)
    if @e_old_prefix == UNDEFINED_PREFIX
      Pbuilder::Adapter.remove_prefix(adapter, "")
    else
      Pbuilder::Adapter.remove_prefix(adapter, @e_old_prefix)
    end
    Pbuilder::Adapter.set_prefix(adapter, @e_value, @e_namespace)
                  
    adapter.close
  end
  
  def hide_pattern
    i = params[:id]
    @hide_str = "hide_#{i}"
    @pattern_str = "pattern_#{i}"
    @show_str = "show_#{i}"
  end
  
  def show_pattern
    i = params[:id]
    @hide_str = "hide_#{i}"
    @pattern_str = "pattern_#{i}"
    @show_str = "show_#{i}"
  end

end
