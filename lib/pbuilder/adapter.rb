module Pbuilder

  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end

  require 'fileutils'

  class Adapter < AbstractAdapter
    # Directory where the persistence file is included
    PERSISTENCE_DIR = "jena_persistence"
    
    # * +persistence_dir+ - Path of the persistence directory
    attr_reader :persistence_dir
    
    # Init
    #  
    # ==== Attributes  
    #  
    # * +identifier+ - A personal identifier
    # * +urls+ - An array of string. Every string is a url where the ontology is stored
    # * +adapter_name+ - An adapter name (String)
    # * +path+ - A path where store the persistence directory
    # * +persistence_dor+ - A string representing the persistence directory name
    # 
    # ==== Warning
    #
    # * Adaptor must be closed with the public method +close+
    def initialize( identifier, 
                    urls, 
                    adapter_name, 
                    path = "", 
                    persistence_dir = PERSISTENCE_DIR)
      @persistence_dir =  Adapter.personal_persistence_dir(identifier, path, persistence_dir)
      if ! FileTest.directory?(@persistence_dir)
        FileUtils.mkdir(@persistence_dir)
      end
      urls.each do |url|
        @adapter = init_load(url, adapter_name)
      end
      init_setup(@adapter)
    end
  
    # Destroy the persistence file
    #
    # ==== Attributes  
    #  
    # * +identifier+ - A personal identifier
    # * +path+ - A path where is stored the persistence directory
    # * +persistence_dor+ - A string representing the persistence directory name
    def self.purge( identifier, 
                    path = "", 
                    persistence_dir = PERSISTENCE_DIR )
      FileUtils.rm_rf(self.personal_persistence_dir(identifier, path, persistence_dir))
    end
    
    # Perform the connetection with an adapter built in the past
    #
    # ==== Attributes  
    #
    # * +adapter_name+ - An adapter name (String)
    # * +identifier+ - A personal identifier
    # * +path+ - A path where is stored the persistence directory
    # * +persistence_dor+ - A string representing the persistence directory name
    def self.get_connection(adapter_name, 
                            identifier, 
                            path = "", 
                            persistence_dir = PERSISTENCE_DIR)
      persistence_dir =  Adapter.personal_persistence_dir(identifier, path, persistence_dir)
      Adapter.add_source(adapter_name, persistence_dir)
    end
    
    # Return the persistence directory path
    #
    # ==== Attributes  
    #  
    # * +identifier+ - A personal identifier
    # * +path+ - A path where store the persistence directory
    # * +persistence_dor+ - A string representing the persistence directory name
    def self.personal_persistence_dir(identifier, 
                                      path = "", 
                                      persistence_dir = PERSISTENCE_DIR)
      path + persistence_dir + "_" + identifier.to_s
    end
    
    # Return the persistence file path
    #
    # ==== Attributes  
    #  
    # * +adapter_name+ - An adapter name
    # * +identifier+ - A personal identifier
    # * +path+ - A path where store the persistence directory
    # * +persistence_dor+ - A string representing the persistence directory name
    def self.personal_persistence_file( adapter_name, 
                                        identifier, 
                                        path = "",
                                        persistence_dir = PERSISTENCE_DIR)
      dir = self.personal_persistence_dir(identifier, path, persistence_dir)
      file = dir.add_slash + adapter_name
      file
    end
    
    # Return the local url using "file://"
    #
    # ==== Attributes  
    #  
    # * +adapter_name+ - An ontology name
    # * +path+ - A path where the ontology is stored
    def self.local_url(path, onto_name)
      "file://" + path.add_slash + onto_name
    end
  
    private
  
    # Load Jena Adaptor through ActiveRfd
    #
    # ==== Attributes  
    #  
    # * +url+ - A url where the ontology is stored
    # * +adapter_name+ - An adapter name
    def init_load(url, adapter_name)
      adapter = Adapter.add_source(adapter_name, @persistence_dir)
      adapter.load( url, 
                    :format => :rdfxml, 
                    :into => :default_model )
      adapter
    end
    
    def self.add_source(adapter_name,
                        persistence_dir = PERSISTENCE_DIR)
      adapter = ConnectionPool.add_data_source( :type => :jena, 
                                                :model => adapter_name,
                                                :file =>  persistence_dir )
      adapter.enabled = true
      adapter
    end
    
  end
  
end

class String
  
  def add_slash
    str = self
    if str[-1..-1] != "/"
      str = str + "/"
    end
    str
  end
  
end
