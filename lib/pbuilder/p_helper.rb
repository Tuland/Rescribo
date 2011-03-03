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
  
end