module Pbuilder
    
  class ReachingInfo
    
    attr_reader :node, :id, :level, :parent_id
    
    def initialize( node,
                    id, 
                    level,
                    parent_id = 0)
      @node = node
      @id = id
      @level = level
      @parent_id = parent_id
    end
   
  end
  
end