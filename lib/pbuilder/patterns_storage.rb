module Pbuilder
  
  class PatternsStorage
    
    def initialize
      raise NotImplementedError.
        new("#{self.class.name} is an abstract class")
    end
    
    def update(concept)
      raise NotImplementedError.
        new("#{self.class.name}#update is an abstract method")
    end
    
    def import(concept, property)
      @temp << [concept.to_s, property.to_s]
    end
    
    def empty_temp
      @temp = Array.new
    end
    
  end
  
end