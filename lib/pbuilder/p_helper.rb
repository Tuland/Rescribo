module Pbuilder::PHelper
  
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
          concept.to_s
        when /^<([^>]*)>$/
          concept
        when String
          "<" + concept + ">"
      end
    end
    
  end
  
end