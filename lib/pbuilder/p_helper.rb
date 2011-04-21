module Pbuilder::PHelper
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  class RDFS::Resource
    
    def different?(*items)
      items.each do |item|
        if item == self
          return false
        end
      end
      return true
    end
    
  end
  
  class Converter
    
    def self.src_2_str(concept)
      concept = case concept
        when RDFS::Resource
          concept.to_s.delete("<>")
        when /^<([^>]*)>$/
          concept.delete("<>")
        when String
          concept
      end
    end
    
    def self.abbreviate(resource)
      Namespace.prefix(resource).to_s + "#" + Namespace.localname(resource)
    end
    
  end
  
end