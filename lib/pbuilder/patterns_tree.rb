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
      purge_cache
    end
    
    def import(concept, property)
      @cache[concept.to_s] = property.to_s
    end
    
    def update(concept)
      @leaves.substitute_concept_using_hash(concept, 
                                            @cache)
      purge_cache
    end
    
    private
    
    def purge_cache
      @cache = Hash.new
    end      
      
  end
    
end