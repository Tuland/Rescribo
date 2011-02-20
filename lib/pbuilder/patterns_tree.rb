module Pbuilder
  
  class PatternsTree
      
    attr_reader :root, :leaves
    
    # Init
    #  
    # ==== Attributes  
    #  
    # * +init_concept+ - An initial concept to include
    def initialize(init_concept)
      @leaves = LeavesList.new()
      @root = @leaves.insert(init_concept.to_s)
      empty_temp
    end
    
    def import(concept, property)
      @temp[concept.to_s] = property.to_s
    end
    
    def update(concept)
      @leaves.substitute_concept_using_hash(concept, 
                                            @temp)
      empty_temp
    end
    
    private
    
    def empty_temp
      @temp = Hash.new
    end      
      
  end
    
end