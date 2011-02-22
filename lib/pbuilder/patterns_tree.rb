module Pbuilder
  
  class PatternsTree < PatternsStorage
      
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
    
    def update(concept)
      if ! @temp.empty?
        @leaves.substitute_concept_using_matrix(concept, 
                                              @temp)
        empty_temp
      end
    end   
      
  end
    
end