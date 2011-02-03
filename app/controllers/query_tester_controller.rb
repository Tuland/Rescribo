begin
require 'active_rdf'
rescue Exception
print "This sample needs activerdf and activerdf_jena.\n"
end
require 'fileutils'



include_class 'java.io.ByteArrayOutputStream'


class QueryTesterController < ApplicationController
  
  before_filter :authorize
  
  BASE = "http://www.semanticweb.org/ontologies/2010/4/mantic_global.owl"
  UNDEFINED_PREFIX = "[Undefined]"
  
  layout 'main', :except => [ :load, :search, :edit ]
  
  def index
    FileUtils.rm_rf(PERSISTENCE_DIR + session[:user_id].to_s)
    
    puts path_to_url(ONTO_PATH)
    
  end

  def load
    # http://github.com/net7/ActiveRDF/blob/master/activerdf-jena/test/test_jena_adapter.rb
    FileUtils.mkdir(PERSISTENCE_DIR + session[:user_id].to_s)
    adapter = ConnectionPool.add_data_source( :type => :jena, 
                                              :model => PERSISTENT_ONTO,
                                              :file => PERSISTENCE_DIR + session[:user_id].to_s )
    adapter.load( path_to_url(ONTO_PATH), 
                  :format => :rdfxml, 
                  :into => :default_model )
    @prefix_map = adapter.model.getNsPrefixMap
    
    adapter.close
    
    @base_str = "base " + BASE
    @url_str = "URL: " + path_to_url(ONTO_PATH)
  end
  
  def edit
    @e_uri = params[:uri]
    @e_value = params[:value]
    @e_editorId = params[:editorId]
    @e_old_prefix = params[:old_prefix]
    
    adapter = ConnectionPool.add_data_source( :type => :jena, 
                                              :model => PERSISTENT_ONTO,
                                              :file => PERSISTENCE_DIR  + session[:user_id].to_s)
                  
    if @e_old_prefix == UNDEFINED_PREFIX
      adapter.model.removeNsPrefix("")
    else
      adapter.model.removeNsPrefix(@e_old_prefix)
    end
    adapter.model.setNsPrefix(@e_value, @e_uri)
                  
    adapter.close
    
  end

  def search
    adapter = ConnectionPool.add_data_source( :type => :jena, 
                                              :model => PERSISTENT_ONTO,
                                              :file => PERSISTENCE_DIR + session[:user_id].to_s)
    adapter.model.removeNsPrefix("")
    prefixes_map = adapter.model.getNsPrefixMap
    
    prefix_str = ""
    prefixes_map.each do |key, value|
      prefix_str << "PREFIX " + key + ": "
      prefix_str << "<" + value +">\n"
    end
    
    if params[:query][:select_enable] == "1"
      select_str = "SELECT "+ params[:query][:select]
    else
      select_str = "CONSTRUCT " + params[:query][:construct] 
    end

    select_str << "\n"
    
    where_str = "WHERE " + params[:query][:where] + "\n"
    
    other_str = ""
    if params[:query][:other_enable] == "1"
      other_str << params[:query][:other]
    end
    
    query_str = prefix_str + select_str + where_str + other_str
    
    puts "\n******** Query SPARQL ********\n"
    puts query_str
    puts "******************************"
    
   query = Jena::Query::QueryFactory.create(query_str)
   qe = Jena::Query::QueryExecutionFactory.create(query, adapter.model)
   results = qe.execSelect()
   
   arr = ByteArrayOutputStream.new
     
   Jena::Query::ResultSetFormatter.out(arr, results)
   
   @results = arr.toString
    
   qe.close
   
   adapter.close
  
  end
  
  
end
