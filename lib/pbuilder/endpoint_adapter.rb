module Pbuilder
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  class EndpointAdapter
    
    # Adds data source
    #  
    # ==== Attributes
    #
    # * +url+ - Url of data source
    # * +engine+ - Symbol determining the type of engine (ex: :virtuoso)
    def self.add_source(url, engine = :virtuoso)      
      adapter = ConnectionPool.add_data_source(:type => :sparql, :results => :sparql_xml, :engine => engine, :url => url)
      adapter.enabled = true
      adapter
    end
    
    def self.set_prefixes(prefixes)
      prefixes.each do |p|
        hash = yield p
        Namespace.register(hash[:prefix], p[:namespace]) 
      end
    end
    
  end
end