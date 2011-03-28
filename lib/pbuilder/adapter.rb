module Pbuilder

  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end

  require 'fileutils'

  class Adapter
    # Directory where the persistence file is included
    PERSISTENCE_DIR = "jena_persistence"
    # SKOS base
    SKOS = "http://www.w3.org/2004/02/skos/core#"
    # AERIA base
    AERIA = "http://www.siti.disco.unimib.it/cmm/2010/aeria#"
    
    # * +persistence_dir+ - Path of the persistence directory
    # * +model+ - The activeRdf/Jena model
    attr_reader :persistence_dir, :model, :prefixes
    
    # Init
    #  
    # ==== Attributes  
    #  
    # * +identifier+ - A personal identifier
    # * +url+ - A url where the ontology is stored
    # * +adapter_name+ - An adapter name
    # * +path+ - A path where store the persistence directory
    # 
    # ==== Warning
    #
    # * Adaptor must be closed with the public method +close+
    def initialize(identifier, url, adapter_name, path = "")
      @persistence_dir =  Adapter.personal_persistence_dir(identifier, path)
      if ! FileTest.directory?(@persistence_dir)
        FileUtils.mkdir(@persistence_dir)
      end
      @adapter = init_load(url, adapter_name)
      init_setup
      @model = @adapter.model
      @prefixes = Adapter.get_prefixes(@adapter)
    end
  
    # Close adaptor
    def close
      @adapter.close
    end
    
    def self.get_prefixes(adapter)
      @prefixes = adapter.model.getNsPrefixMap
    end
    
    def self.remove_prefix(adapter, prefix)
      adapter.model.removeNsPrefix("")
    end
    
    def self.set_prefix(adapter, prefix, namespace)
      adapter.model.setNsPrefix(prefix, namespace)
    end
  
    # Destroy the persistence file
    #
    # ==== Attributes  
    #  
    # * +identifier+ - A personal identifier
    # * +path+ - A path where is stored the persistence directory
    def self.purge(identifier, path = "")
      FileUtils.rm_rf(self.personal_persistence_dir(identifier, path))
    end
    
    # Perform the connetection with an adapter built in the past
    #
    # ==== Attributes  
    #  
    # * +identifier+ - A personal identifier
    # * +path+ - A path where is stored the persistence directory
    def self.get_connection(adapter_name, identifier, path = "")
      persistence_dir =  Adapter.personal_persistence_dir(identifier, path)
      adapter = ConnectionPool.add_data_source( :type => :jena, 
                                                :model => adapter_name,
                                                :file =>  persistence_dir )
      adapter.enabled = true
      adapter
    end
    
    # Return the persistence directory path
    #
    # ==== Attributes  
    #  
    # * +identifier+ - A personal identifier
    # * +path+ - A path where store the persistence directory
    def self.personal_persistence_dir(identifier, path = "")
      path + PERSISTENCE_DIR + "_" + identifier.to_s
    end
    
    # Return the persistence file path
    #
    # ==== Attributes  
    #  
    # * +adapter_name+ - An adapter name
    # * +identifier+ - A personal identifier
    # * +path+ - A path where store the persistence directory
    def self.personal_persistence_file( adapter_name, 
                                        identifier, 
                                        path = "" )
      dir = self.personal_persistence_dir(identifier, path)
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
      adapter = ConnectionPool.add_data_source( :type => :jena, 
                                                :model => adapter_name,
                                                :file =>  @persistence_dir )
      adapter.enabled = true
      adapter.load( url, 
                    :format => :rdfxml, 
                    :into => :default_model )
      adapter
    end
  
    # Perform mapping from RDF type to Ruby classes
    def init_setup
      Namespace.register :skos, SKOS
      Namespace.register :aeria, AERIA
      ObjectManager.construct_classes
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
