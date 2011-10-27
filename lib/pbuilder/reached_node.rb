module Pbuilder
    
  class ReachedNode
    
    attr_reader :id, :level, :concept, :property, :pattern, :parent_id
    
    def initialize( id, level, concept, property = nil, parent_id = nil, pattern = nil)
      @id = id
      @level = level
      @concept = concept
      @property = property
      @parent_id = parent_id
      @pattern = pattern 
    end
   
  end
  
end