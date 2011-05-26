module Pbuilder::PHelper
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  class RDFS::Resource
    
    # Compares the resource with a list of items. If there is an item equal to the resource return false, true otherwise
    #
    # === Attributes
    #
    # +*items+ - a list of items to compare with the resource
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
    
    # Convertion from concept to string
    #
    # ==== Attributes
    #
    # * +concept+ - concept (source, simple string or string with <>) 
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
    
    # Abbreviation into prefix#local_name
    #
    # === Attributes
    #
    # * +resource+ - Resource to abbreviate
    def self.abbreviate(resource)
      Namespace.prefix(resource).to_s + "#" + Namespace.localname(resource)
    end
    
  end
  
end