begin
require 'active_rdf'
rescue Exception
print "This sample needs activerdf and activerdf_jena.\n"
end
require 'fileutils'

class QueryTesterController < ApplicationController
  
  # TODO rendere uguale per il deploy
  ONTO_PATH = "onto/onto.owl"
  BASE = "http://www.semanticweb.org/ontologies/2010/4/mantic_global.owl"
  UNDEFINED_PREFIX = "[Undefined]"
  
  PERSISTENCE_DIR = "jena_persistence"
  PERSISTENCE_NAME = "source"
  
  layout 'main', :except => [ :load, :search, :edit ]
  
  def index
    FileUtils.rm_rf(PERSISTENCE_DIR)
    @header = "Query Tester"
    
    puts path_to_url(ONTO_PATH)
  end

  def load
    # http://github.com/net7/ActiveRDF/blob/master/activerdf-jena/test/test_jena_adapter.rb
    # TODO association model name -> user 
    FileUtils.mkdir(PERSISTENCE_DIR)
    adapter = ConnectionPool.add_data_source( :type => :jena, 
                                              :model => "source",
                                              :file => PERSISTENCE_DIR)
    adapter.load( path_to_url(ONTO_PATH), 
                  :format => :rdfxml, 
                  :into => :default_model )
    @prefix_map = adapter.model.getNsPrefixMap
    
    adapter.close
    
    @base_str = "base " + BASE
    @url_str = "URL: " + path_to_url(ONTO_PATH)
  end
  
  def edit
    
    
  end

  def search
  
  end


  
  
end
