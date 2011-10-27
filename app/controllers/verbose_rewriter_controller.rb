begin
  require 'active_rdf'
rescue Exception
  print "This sample needs activerdf and activerdf_jena.\n"
end

require 'pbuilder/adapter'
require 'pbuilder/endpoint_adapter'
require 'pbuilder/clouds_explorer'
require 'pbuilder/yaml_reader'
require 'pbuilder/splitted_explorer'
require 'pbuilder/soft_instance'

class VerboseRewriterController < ApplicationController
  include Pbuilder::PHelper
  
  FREQUENCY = 6
  
  layout 'main', :except => [ :load, 
                              :rewrite, 
                              :edit_prefix, 
                              :hide_pattern, 
                              :show_pattern ]
  
  before_filter :authorize
  
  UNDEFINED_PREFIX = "[Undefined]"
  MAX_SIZE = 20
  
  def index
    delete_all(session[:user_id])
  end
  
  def load
    files = Dir["#{AERIA_DIRECTORY}/*"].collect { |path| path_to_url(path) }
    @url_str = "Files loaded from " + path_to_url(AERIA_DIRECTORY)
    explorer = Pbuilder::CloudsExplorer.new(files,
                                            PERSISTENT_AERIA,
                                            session[:user_id],
                                            { :report => true,
                                              :patterns_file  =>  PATTERNS_FILE,
                                              :analysis_file  =>  ANALYSIS_FILE,
                                              :mappings_file  =>  MAPPINGS_FILE } )
    @global_rc_list = explorer.global_root_concepts
    @global_finders = explorer.global_finders
    @abstract_concepts = explorer.mappings.keys.sort
    @prefixes = explorer.prefixes
    onto_source = OntoSource.find(:first, :conditions => "user_id='#{session[:user_id]}'")
    if onto_source.source == "local"
    # Adapter already builded in uploading step
      adapter = Pbuilder::Adapter.get_connection( PERSISTENT_ONTO, 
                                                  session[:user_id],
                                                  "", PERSISTENCE_DIR)
      begin
        @prefixes = Pbuilder::Adapter.get_prefixes(onto_adapter)
      rescue Exception => e
        puts e.message  
        puts e.backtrace.inspect
      ensure 
        adapter.close 
      end
    else
      @prefixes = explorer.prefixes
      @prefixes.each do |prefix, namespace|
        p = Prefix.new
        p.prefix = prefix
        p.namespace = namespace
        p.user_id = session[:user_id]
        p.save
      end
    end
    @notice = "Ontologies loaded"
    @undefined_prefix = UNDEFINED_PREFIX
          
  end
  
  def rewrite
    delete_all(session[:user_id])
    a_concept = params[:settings][:a_concept]
    constraint = params[:settings][:constraint]
    patterns, analysis = init_patterns(a_concept)
    core_concept_node = patterns[a_concept].root
    @patterns = core_concept_node.build_patterns
    Concept.import_from_matrix(@patterns, session[:user_id])
    @analysis = analysis[a_concept]
    @max_size = max_size(@patterns)
    onto_source = OntoSource.find(:first, :conditions => "user_id='#{session[:user_id]}'")
    adapter = init_adapter({ :prefix => true })
    @core_instances = []                                  
    begin
      @core_concept_rsc = RDFS::Resource.new(core_concept_node.value)
      se = Pbuilder::SplittedExplorer.new(@patterns, 
                                          @core_concept_rsc, 
                                          constraint) do |i, p_count, level, property, parent_id|
        instance = Instance.new(
          :uri => Converter.rsc_2_str(i),
          :pattern => p_count,
          :user_id => session[:user_id],
          :level => level,
          :parent_id => parent_id)
        if ! property.nil?
          prop = Converter.rsc_2_str(property)
          instance.property = Property.find_or_create_by_uri(prop)
        end
        instance.save
        Pbuilder::SoftInstance.new(instance.id, i)
      end
      @core_instances = se.core_instances
      se.scan_patterns
    rescue Exception => e
      puts e.message  
      puts e.backtrace.inspect
    ensure 
      adapter.close 
    end
    @frequency = FREQUENCY
  end
  
  def post_periodically
    @parents = Instance.find( :all,
                              :conditions => ["user_id = ? and level = ?", 
                                              session[:user_id], session[:level] ],
                              :order	=> "parent_id ASC")
    session[:level] = session[:level].next
    @level = session[:level]
    @concepts = Concept.find(:all,
                            :conditions => ["user_id = ? and level = ?", 
                                            session[:user_id], @level],
                            :order => "pattern ASC")
  end
  
  def edit_prefix
    @e_namespace = params[:namespace]
    @e_value = params[:value]
    @e_editorId = params[:editorId]
    @e_old_prefix = params[:old_prefix]
    
    onto_source = OntoSource.find(:first, :conditions => "user_id='#{session[:user_id]}'")
    if onto_source.source == "local"
      adapter = Pbuilder::Adapter.get_connection( PERSISTENT_ONTO, 
                                                session[:user_id].to_s)
      if @e_old_prefix == UNDEFINED_PREFIX
        Pbuilder::Adapter.remove_prefix(adapter, "")
      else
        Pbuilder::Adapter.remove_prefix(adapter, @e_old_prefix)
      end
      Pbuilder::Adapter.set_prefix(adapter, @e_value, @e_namespace)
                  
      adapter.close
    else
      if @e_old_prefix == UNDEFINED_PREFIX
        p = Prefix.find(:first, 
                        :conditions => ["prefix = ? and user_id = ?", "", session[:user_id]])
      else
        p = Prefix.find(:first, 
                        :conditions => ["prefix = ? and user_id = ?", @e_old_prefix, session[:user_id]])
      end
      p.prefix = @e_value
      if ! p.save
        @e_value = @e_old_prefix
      end
    end
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
  
  private
  
  def max_size(patterns)
    max_size = Counter.max_patterns_size(patterns)
    max_size = MAX_SIZE if MAX_SIZE < max_size
    max_size
  end
  
  def init_patterns(a_concept)
    reader = Pbuilder::YamlReader.new(session[:user_id],
                                      MAPPINGS_FILE,
                                      PATTERNS_FILE,
                                      ANALYSIS_FILE)
    reader.load(a_concept)
  end
  
  def delete_all(user_id)
    Prefix.delete_all(["user_id = ?", user_id])
    Instance.delete_all(["user_id = ?", user_id])
    Concept.delete_all(["user_id = ?", user_id])
    init_level
  end
  
  def init_adapter(options = {})
    onto_source = OntoSource.find(:first, :conditions => "user_id='#{session[:user_id]}'")
    if onto_source.source == "endpoint"
      onto = Ontology.find(:first, :conditions => "user_id='#{session[:user_id]}'")
      adapter = Pbuilder::EndpointAdapter.add_source(onto.url)
      Prefix.get_prefixes(session[:user_id]) if options[:prefix] = true
    else
      adapter = Pbuilder::Adapter.get_connection( PERSISTENT_ONTO, 
                                                  session[:user_id])
    end
    adapter
  end
  
  def init_level
    session[:level] = 0
  end

end