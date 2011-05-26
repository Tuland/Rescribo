module Pbuilder
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  class EndpointAdapter
    def self.add_source(url, engine = :virtuoso)      
      adapter = ConnectionPool.add_data_source(:type => :sparql, :results => :sparql_xml, :engine => engine, :url => url)
      adapter.enabled = true
      adapter
    end
  end
end