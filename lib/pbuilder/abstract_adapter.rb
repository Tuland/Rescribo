module Pbuilder
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  class AbstractAdapter
    
    # SKOS base
    SKOS = "http://www.w3.org/2004/02/skos/core#"
    # AERIA base
    AERIA = "http://www.siti.disco.unimib.it/cmm/2010/aeria#"
    
    # * +model+ - The activeRdf/Jena model
    # * +prefixes+ - RDFS prefixes
    attr_reader :model, :prefixes
    
    ## Not Implemented methods
    
    def initialize
      raise NotImplementedError.
        new("#{self.class.name} is an abstract class")
    end
    
    # Common methods
    
    def purge
      raise NotImplementedError.
        new("#{self.class.name}#purge is an abstract method")
    end
    
    def self.get_connection
      raise NotImplementedError.
        new("#{self.class.name}#get_connection is an abstract method")
    end
    
    ## Implemented methods
    
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
      Namespace.register(prefix, namespace)
    end
    
    ## Private
    
    # Performs mapping from RDF type to Ruby classes
    def init_setup(adapter)
      Namespace.register :skos, SKOS
      Namespace.register :aeria, AERIA
      load_namespaces(adapter)
      ObjectManager.construct_classes
      @model = adapter.model
      @prefixes = Adapter.get_prefixes(adapter)
    end
    
    def load_namespaces(adapter)
      default_namespaces = [:xsd, :rdf, :rdfs, :owl, :shdm, :swui]
      namespaces = adapter.model.getNsPrefixMap.to_a
      namespaces.map!{|ns| [ns.first.to_sym, ns.last] unless ns.first.nil? || ns.first.blank? }
      namespaces.compact!
      namespaces.reject!{|ns| default_namespaces.include?(ns.first) }   
      namespaces.map{|ns| Namespace.register(*ns) }
    end
    
    def self.init_load(url, adapter_name)
      raise NotImplementedError.
        new("#{self.class.name}#init_load is an abstract method")
    end
    
  end
  
end