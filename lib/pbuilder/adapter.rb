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
    
    attr_reader :persistence_dir
  
    def initialize(identifier, url, name, path = "")
      @persistence_dir =  Adapter.personal_persistence_dir(identifier, path)
      FileUtils.mkdir(@persistence_dir)
      @adapter = init_load(url, name)
      init_setup
    end
  
    # Close adaptor
    def close
      @adapter.close
    end
  
    # Destroy the persistence file
    def self.purge(identifier, path = "")
      FileUtils.rm_rf(self.personal_persistence_dir(identifier, path))
    end
    
    # Return the persistence directory name 
    def self.personal_persistence_dir(identifier, path = "")
      path + PERSISTENCE_DIR + "_" + identifier.to_s
    end
  
    private
  
    # Load Jena Adaptor through ActiveRfd
    def init_load(url, name)
      adapter = ConnectionPool.add_data_source( :type => :jena, 
                                                :model => name,
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
