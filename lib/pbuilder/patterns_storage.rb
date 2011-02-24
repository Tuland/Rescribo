module Pbuilder
  
  class PatternsStorage
    
    ## Not Implemented methods
    
    def initialize
      raise NotImplementedError.
        new("#{self.class.name} is an abstract class")
    end
    
    # Common methods
    
    def update(concept)
      raise NotImplementedError.
        new("#{self.class.name}#update is an abstract method")
    end
    
    def list
      raise NotImplementedError.
        new("#{self.class.name}#list is an abstract method")
    end
    
    # Tree
    
    def root
      raise NotImplementedError.
        new("#{self.class.name}#root is an abstract method")
    end
    
    def leaves(concept)
      raise NotImplementedError.
        new("#{self.class.name}#leaves is an abstract method")
    end
    
    ## Implemented methods
    
    # Import new node (concept and property)
    #  
    # ==== Attributes  
    #
    # * +property+ - A property to queue 
    # * +concept+ - A concept to queue
    def import(concept, property)
      @temp << [concept.to_s, property.to_s]
    end
    
    # Empty a temporary list of new nodes
    def empty_temp
      @temp = Array.new
    end
    
  end
  
end